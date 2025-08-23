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

local function execute_cmd(gradle_cmd)
	get_tmux_pane()
	if not pane_id then
		vim.notify("Failed to get/create tmux pane", vim.log.levels.ERROR)
	end

    -- stylua: ignore start
    vim.fn.system({
        "tmux", "send-keys", "-t", pane_id,
        gradle_cmd, "C-m"
    })
	-- stylua: ignore end
end

vim.api.nvim_create_user_command("KotlinCreate", function()
	execute_cmd("gradle init --type kotlin-application")
end, {})

vim.api.nvim_create_user_command("KotlinBuild", function(opts)
	local build_type = opts.args or "releaseClean"

	if build_type:match("$Clean") then
		vim.cmd.KotlinClean()
	end

	if build_type == "release" then
		execute_cmd("echo 'Not yet implemented'")
	elseif build_type == "debug" then
		execute_cmd("echo 'Not yet implemented'")
	end
end, {
	nargs = "?",
	complete = function()
		return { "debug", "release", "debugClean", "releaseClean" }
	end,
})

vim.api.nvim_create_user_command("KotlinClean", function()
	execute_cmd("gradle ktlintFormat")
	execute_cmd("gradle ktlintCheck")
end, {})

vim.api.nvim_create_user_command("KotlinSync", function()
	execute_cmd("gradle --refresh-dependencies")
end, {})
