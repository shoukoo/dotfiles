local api = vim.api
local global = {}

local win_default_opts = function(percentage)
	local width = math.floor(vim.o.columns * percentage)
	local height = math.floor(vim.o.lines * percentage)
	local top = math.floor(((vim.o.lines - height) / 2) - 1)
	local left = math.floor((vim.o.columns - width) / 2)

	local opts = {
		relative = "editor",
		row = top,
		col = left,
		width = width,
		height = height,
		style = "minimal",
	}

	opts.border = {
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
		{ " ", "NormalFloat" },
	}

	return opts
end

global.info = function()
	local win_opts = win_default_opts(0.8)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local win_id = vim.api.nvim_open_win(bufnr, true, win_opts)

	local buf_lines = {}
	vim.cmd([[
    redir @a
    silent highlight
    redir END
  ]])

  local content = vim.fn.getreg('a')
  local content2 = vim.split(content, "\n")

	vim.list_extend(buf_lines, content2)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
	vim.api.nvim_win_set_buf(win_id, buf_lines)

  vim.cmd("silent! g/ cleared%/d")
  vim.cmd("%s/xxx //d")

	vim.cmd("setlocal nocursorcolumn")
	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
	-- esc key exectes background delete (bd) command
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<cmd>bd<CR>", { noremap = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>bd<CR>", { noremap = true })
end
--
--highlight.startup = function()
--	vim.cmd([[command! HighLightInfo lua require('op').info()]])
--end
--
return global
