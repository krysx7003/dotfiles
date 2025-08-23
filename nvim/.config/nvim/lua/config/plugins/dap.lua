return {
	"mfussenegger/nvim-dap",
	ft = { "python", "cpp" }, --
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		require("dap-python").setup("venv/bin/python3")

		local dap = require("dap")
		local dapui = require("dapui")

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}
		dap.configurations.cpp = {
			{
				name = "Launch file (codelldb)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		dap.configurations.c = dap.configurations.cpp

		dap.adapters.kotlin = {
			type = "executable",
			command = "kotlin-debug-adapter",
			options = { auto_continue_if_many_stopped = false },
		}

		dap.configurations.kotlin = {
			{
				type = "kotlin",
				request = "launch",
				name = "This file",
				mainClass = function()
					local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1]
						or ""
					local fname = vim.api.nvim_buf_get_name(0)
					return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", "."):sub(2, -1)
				end,
				projectRoot = "${workspaceFolder}",
				jsonLogFile = "",
				enableJsonLogging = false,
			},
			{
				type = "kotlin",
				request = "attach",
				name = "Attach to debugging session",
				port = 5005,
				args = {},
				projectRoot = vim.fn.getcwd,
				hostName = "localhost",
				timeout = 2000,
			},
		}

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition" })
		vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ff8800" })

		dapui.setup()
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		------------------- REMAP --------------------------
		vim.keymap.set("n", "<leader>bb", function()
			dap.toggle_breakpoint()
			vim.cmd("redraw!")
		end, { desc = "Toggle breakpoint" })

		vim.keymap.set("n", "<leader>bc", function()
			dap.toggle_breakpoint(vim.fn.input("Breakpoint condition: "))
			vim.cmd("redraw!")
		end, { desc = "Set conditional breakpoint" })

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })

		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Step into" })
		vim.keymap.set("n", "<F2>", dap.step_out, { desc = "Step into" })
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step into" })

		vim.keymap.set("n", "<leader>dt", function()
			dap.close()
			dapui.close()
		end, { desc = "End debug session" })

		vim.keymap.set("n", "<leader>de", function()
			dapui.eval()
			dapui.eval()
		end, { desc = "Eval and focus float" })
	end,
}
