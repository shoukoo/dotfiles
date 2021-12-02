local install_path = '~/.local/share/nvim/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local use = require('packer').use
require('packer').startup(function()
  use('wbthomason/packer.nvim')
  use('tpope/vim-fugitive')
  use('junegunn/fzf.vim')
  use({
    'junegunn/fzf',
    run = function()
      vim.fn['fzf#install']()
    end,
  })
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  use('neovim/nvim-lspconfig')
  use('itchyny/lightline.vim')
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
  use('kristijanhusak/orgmode.nvim')
  use('tpope/vim-surround')
  use('shoukoo/stylua.nvim')
  use('shoukoo/mei.nvim')
  use('shoukoo/commentary.nvim')
end)

-- Color scheme
require('mei')

-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable number
vim.wo.number = true
vim.wo.relativenumber = true
-- Turn off swapfile
vim.o.swapfile = false
-- Share the systemclipboard
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
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
--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
--Enable break indent
vim.o.breakindent = true
-- terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {})
--Set statusbar
vim.g.lightline = {
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- Filetype indentation
vim.api.nvim_exec(
  [[
  augroup FiletypeDetect
    autocmd FileType lua setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType sh setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType typescriptreact setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType typescript setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
  augroup end
]],
  false
)

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
      buf_set_keymap('n', 'gf', [[<Cmd>lua Gopls(1000)<CR>]], opts)
    else
      buf_set_keymap('n', 'gf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'tsserver', 'terraformls', 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({ on_attach = on_attach(lsp) })
end

-- Instruction: https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- brew install ninja
-- git clone https://github.com/sumneko/lua-language-server.git
-- cd lua-language-server
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ./compile/install.sh
-- cd ../..
-- ./3rd/luamake/luamake rebuild

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local sumneko_root_path = vim.fn.getenv('HOME') .. '/Code/shoukoo/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/macOS/lua-language-server'

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

nvim_lsp.sumneko_lua.setup({
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  on_attach = on_attach('sumneko_lua'),
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

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
local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

cmp.setup({

  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        orgmode = '[ORG]',
        vsnip = '[SNIP]',
        buffer = '[BUFFER]',
      })[entry.source.name]
      return vim_item
    end,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'orgmode' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
})

---------------------------------------------------------------------
-- Orgmode
---------------------------------------------------------------------
local Orgmod_path = [[~/Library/Mobile\ Documents/com~apple~CloudDocs/vim/orgmode/]]
require('orgmode').setup({
  org_agenda_files = { Orgmod_path .. '*' },
  org_default_notes_file = Orgmod_path .. 'default.org',
  org_agenda_templates = {
    t = { description = 'default', template = '* TODO %?\n  %u' },
    n = { description = 'neovim', template = '* TODO %?\n %u', target = Orgmod_path .. 'nvim.org' },
  },
})

---------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------

-- Printout values
_G.Dump = function(tbl)
  if type(tbl) == 'table' then
    local s = '{ '
    for k, v in pairs(tbl) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(tbl)
  end
end

-- custom handler to call both goimports + gofmt.
-- vim.lsp.buf.formatting doesn't trigger goimports
Gopls = function(timeoutms)
  local context = { source = { organizeImports = true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = 'textDocument/codeAction'
  local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
  if resp and resp[1] then
    local result = resp[1].result
    if result and result[1] then
      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
  vim.lsp.buf.formatting_sync()
end
