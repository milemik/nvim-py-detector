-- lua/nvim_venv_detector/init.lua

local M = {}

-- Function to find the .venv directory
local function find_venv()
	local current_dir = vim.fn.getcwd()
	while current_dir ~= "/" do
		local venv_path = current_dir .. "/.venv"
		if vim.fn.isdirectory(venv_path) == 1 then
			return venv_path
		end
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end
	return nil
end

-- Function to find the poetry virtual environment
local function find_poetry_venv()
	local current_dir = vim.fn.getcwd()
	while current_dir ~= "/" do
		local poetry_lock = current_dir .. "/poetry.lock"
		if vim.fn.filereadable(poetry_lock) == 1 then
			local poetry_venv = vim.fn.system("poetry env info -p")
			if vim.v.shell_error == 0 and vim.fn.trim(poetry_venv) ~= "" then
				return vim.fn.trim(poetry_venv)
			end
		end
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end
	return nil
end

-- Function to find the pipenv virtual environment
local function find_pipenv_venv()
	local current_dir = vim.fn.getcwd()
	while current_dir ~= "/" do
		local pipfile = current_dir .. "/Pipfile"
		if vim.fn.filereadable(pipfile) == 1 then
			local pipenv_venv = vim.fn.system("pipenv --venv")
			if vim.v.shell_error == 0 and vim.fn.trim(pipenv_venv) ~= "" then
				return vim.fn.trim(pipenv_venv)
			end
		end
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end
	return nil
end

local function set_python_path(venv_path)
	if venv_path then
		local python_path = venv_path .. "/bin/python"
		if vim.fn.executable(python_path) == 1 then
			-- Find the active Pyright LSP client
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
				if client.name == "pyright" then
					client.config.settings.python.pythonPath = python_path
					vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", {
						settings = client.config.settings,
					})
					print("Python path set to: " .. python_path)
					return
				end
			end
			print("Pyright LSP is not active.")
		else
			print("Python executable not found in: " .. venv_path)
		end
	else
		print("No virtual environment found in the project")
	end
end
-- Function to find and set the virtual environment
local function find_and_set_venv()
	local venv_path = find_venv() or find_poetry_venv() or find_pipenv_venv()
	set_python_path(venv_path)
end

-- Setup function to be called from your Neovim configuration
function M.setup()
	-- Find and set the virtual environment
	find_and_set_venv()

	-- Optionally, you can set up an autocommand to re-check the virtual environment on entering a buffer
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*.py",
		callback = function()
			find_and_set_venv()
		end,
	})
end

return M
