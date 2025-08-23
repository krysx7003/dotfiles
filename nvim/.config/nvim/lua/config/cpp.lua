local pane_id = nil

local function inactive_pane_exists()
	local handle = io.popen("tmux list-panes -F '#{?pane_active,active,inactive}'")
	if not handle then
		return false
	end

	for line in handle:lines() do
		local status = line:match("^(.*)$")
		if status ~= "active" then
			handle:close()
			return true
		end
	end
	handle:close()
end

local function get_active_pane_id()
	local handle = io.popen("tmux list-panes -F '#{pane_id}::#{?pane_active,active,inactive}'")
	if not handle then
		return -1
	end

	for line in handle:lines() do
		local id, status = line:match("^(.*)::(.*)$")
		if status == "active" then
			handle:close()
			print(id)
			return id
		end
	end
	handle:close()
end

local function get_tmux_pane()
	if not inactive_pane_exists() then
		vim.fn.system({ "tmux", "split-window", "-l", "25%", "-c", vim.fn.getcwd() })
		pane_id = get_active_pane_id()
	end
end

local function execute_cmd(cmd)
	get_tmux_pane()
	if not pane_id then
		vim.notify("Failed to get/create tmux pane", vim.log.levels.ERROR)
	end

    -- stylua: ignore start
    vim.fn.system({
        "tmux", "send-keys", "-t", pane_id,
        cmd, "C-m"
    })
	-- stylua: ignore end
end
vim.api.nvim_create_user_command("CmakeCreate", function()
	local cwd = vim.fn.getcwd()
	local debug_dir = cwd .. "/build/debug"
	local release_dir = cwd .. "/build/release"

	vim.fn.system({ "mkdir", "-p", "build/debug" })
	vim.fn.system({ "mkdir", "-p", "build/release" })

	vim.fn.system({ "touch", "CMakeLists.txt" })

	execute_cmd(
		"cmake -S . -B "
			.. debug_dir
			.. " -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
	)

	execute_cmd(
		"cmake -S . -B"
			.. release_dir
			.. " -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
	)
	vim.fn.system({ "cp", vim.fn.expand("~/.config/nvim/.nvim/.clang-format"), vim.fn.expand("~/.nvim/") })
end, {})

vim.api.nvim_create_user_command("CmakeBuild", function(opts)
	local build_type = opts.args or "all"
	local debug = "cmake --build build/debug"
	local release = "cmake --build build/release"

	if build_type == "all" then
		execute_cmd(release)
		execute_cmd(debug)
	elseif build_type == "release" then
		execute_cmd(release)
	elseif build_type == "debug" then
		execute_cmd(debug)
	else
		print("Invalid build type. Use 'debug', 'release', or 'all'")
	end
end, {
	nargs = "?",
	complete = function()
		return { "debug", "release", "all" }
	end,
})
