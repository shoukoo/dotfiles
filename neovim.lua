local install_path = '~/.local/share/nvim/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local use = require('packer').use
require('packer').startup(function()
  use('wbthomason/packer.nvim')
  use('google/vim-jsonnet')
  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb')
  use('tpope/vim-surround')
  use('shoukoo/stylua.nvim')
  use('shoukoo/commentary.nvim')
  -- golang
  use('sebdah/vim-delve')
  use('ray-x/go.nvim')
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('ray-x/guihua.lua')
  use('theHamsta/nvim-dap-virtual-text')
  -- colorscheme
  use {"ellisonleao/gruvbox.nvim"}
  use('seblj/nvim-echo-diagnostics')
  use('nvim-tree/nvim-web-devicons')
  use {
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup{}
  end
  }
  -- fzf
  use('junegunn/fzf.vim')
  use({
    'junegunn/fzf',
    run = function()
      vim.fn['fzf#install']()
    end,
  })
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use('neovim/nvim-lspconfig')
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
    },
  })
  use({ 'akinsho/toggleterm.nvim' })
  use('itchyny/lightline.vim')


  -- javascript 
  -- use('leafOfTree/vim-vue-plugin')
  use({'prettier/vim-prettier', run = 'yarn install --frozen-lockfile --production' })
  use('windwp/nvim-autopairs')
  use('mattn/emmet-vim')

end)

-- Color scheme
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable number
vim.wo.number = true
vim.wo.relativenumber = true
-- Turn off swapfile
vim.o.swapfile = false
-- Share the systemclipboard
vim.opt.clipboard:prepend({ 'unnamedplus' })
-- Save undo history
vim.cmd([[set undofile]])
-- Set split
vim.cmd([[set splitbelow]])
vim.cmd([[set splitright]])
-- Ignore cases
vim.g.ignorecase = true
-- Remap leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Enable break indent
vim.o.breakindent = true
-- terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {})
-- Custom keys
vim.api.nvim_set_keymap('n', '<leader>sv', '<cmd>source $MYVIMRC<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ev', '<cmd>vsplit $MYVIMRC<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>so $MYVIMRC<cr><cmd>PackerInstall<cr>', { noremap = true })

-- Filetype indentation
vim.api.nvim_exec(
  [[
  augroup FiletypeDetect
    autocmd FileType lua setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType javascriptreact setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType sh setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType vue setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType python setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType typescriptreact setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType typescript setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  augroup end
]],
  false
)

---------------------------------------------------------------------
-- Tree sitter
---------------------------------------------------------------------
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "css",
    "go",
    "hcl",
    "html",
    "json",
    "lua",
    "bash",
    "toml",
    "tsx",
    "yaml",
  },
  autotag = {
    enable = true,
  },
})

---------------------------------------------------------------------
-- Lightline
---------------------------------------------------------------------
vim.g.lightline = {
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  colorscheme = 'solarized',
  component_function = { gitbranch = 'fugitive#head' },
}

---------------------------------------------------------------------
-- LSP Clients
---------------------------------------------------------------------
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(lsp)
  return function(_, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    if lsp == 'sumneko_lua' then
      buf_set_keymap('n', 'gf', [[<Cmd>lua require"stylua".format_file()<CR>]], opts)
    elseif lsp == 'gopls' then
      buf_set_keymap('n', 'gf', [[<Cmd>lua require"go.format".gofmt()<CR>]], opts)
    else
      buf_set_keymap('n', 'gf', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
    end
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua require("echo-diagnostics").echo_entire_diagnostic()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  end
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'quick_lint_js', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({ on_attach = on_attach(lsp) })
end

require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

---------------------------------------------------------------------
-- Tree sitter
---------------------------------------------------------------------
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.cc' },
    disable = { 'org' }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = { 'org' },
  },
  filetype = 'org',
}

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  ensure_installed = { 'org' },
})

---------------------------------------------------------------------
-- Fzf
---------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>History<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>Files<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>Commits<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', [[<cmd>Rg<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fl', [[<cmd>Lines<CR>]], { noremap = true, silent = true })

---------------------------------------------------------------------
-- Cmp
---------------------------------------------------------
local cmp = require('cmp')

cmp.setup({

  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({
      select = true,
    }),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        vsnip = '[SNIP]',
        buffer = '[BUFFER]',
      })[entry.source.name]
      return vim_item
    end,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
})

---------------------------------------------------------------------
-- nvim-echo-diagnostics
---------------------------------------------------------------------
require("echo-diagnostics").setup{
    show_diagnostic_number = true,
    show_diagnostic_source = false,
}

---------------------------------------------------------------------
-- trouble
---------------------------------------------------------------------
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)

---------------------------------------------------------------------
-- ToggleTerm
---------------------------------------------------------------------
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'CONFIG_DIR=~/.config/lazygit lazygit', hidden = true, direction = 'float' })
-- not use
local term = Terminal:new({ hidden = true, direction = 'float' })

function Lazygit_toggle()
  lazygit:toggle()
end

function Term_toggle()
  term:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true })

---------------------------------------------------------------------
-- auto pair
---------------------------------------------------------------------
local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

---------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------
require('go').setup()
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})
