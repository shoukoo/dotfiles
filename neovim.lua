local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  -- golang
  { 'sebdah/vim-delve' },
  {
    'ray-x/go.nvim',
    config = function()
      require("go").setup()
    end
  },
  {
    'shoukoo/g0.nvim',
    config = function()
      require("g0").setup()
    end
  },

  {
    'dinhhuy258/git.nvim',
    config = function()
      require("git").setup()
    end,
  },

  { 'shoukoo/commentary.nvim' },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        options = { theme = 'gruvbox' },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      })
    end,
  },

  -- setup lua lsp correctly
  { "folke/neodev.nvim", opts = {} },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- telescope
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }
            end
          },
        }
      })

      require("telescope").load_extension("ui-select")
      require('telescope').load_extension('fzf')
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = true,
        },
        ensure_installed = {
          "bash",
          "css",
          "cue",
          "go",
          "hcl",
          "json",
          "lua",
          "rust",
          "toml",
          "tsx",
          "yaml",
        },
        autotag = {
          enable = true,
        },
      })
    end
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
      }
    end
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      luasnip.config.setup {}

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      require('cmp').setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format {
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
            },
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        -- don't auto select item
        preselect = cmp.PreselectMode.None,
        window = {
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            name = "custom",
            selection_order = "near_cursor",
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Insert,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer", keyword_length = 5 },
        },
      })
    end,
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))

        end
      })
    end,
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    config = function()
      require("oil").setup()
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require("neodev").setup({})
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
          if lsp == 'gopls' then
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
      local servers = { 'gopls', 'denols', "lua_ls", "rust_analyzer" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup({ on_attach = on_attach(lsp) })
      end
    end
  },
  --   use('posva/vim-vue')
  --   use({'prettier/vim-prettier', run = 'yarn install --frozen-lockfile --production' })
  --   use('windwp/nvim-autopairs')
  --   use('mattn/emmet-vim')
})

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
-- settings to insert spaces all the time.
vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
-- Hence override our indentation rules.
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setIndent', { clear = true }),
  pattern = { 'go' },
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})

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
---------------------------------------------------------------------
-- Lazygit
---------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '<leader>l', [[<cmd>LazyGit<CR>]], { noremap = true, silent = true })
---------------------------------------------------------------------
-- Git
---------------------------------------------------------------------
vim.keymap.set('n', '<leader>gb', '<CMD>lua require("git.blame").blame()<CR>')
vim.keymap.set('n', '<leader>go', "<CMD>lua require('git.browse').open(false)<CR>")
vim.keymap.set('x', '<leader>go', ":<C-u> lua require('git.browse').open(true)<CR>")
---------------------------------------------------------------------
-- Telescope
---------------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>xx', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fr', builtin.live_grep, {})
---------------------------------------------------------------------
-- Diagnostics
---------------------------------------------------------------------
vim.keymap.set('n', '<leader>xo', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>xp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>xn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>xs', vim.diagnostic.setqflist)
---------------------------------------------------------------------
-- Oil
---------------------------------------------------------------------
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
---------------------------------------------------------------------
-- Nerdtree
---------------------------------------------------------------------
vim.api.nvim_set_keymap("n", "<Leader>tt", ":NvimTreeToggle<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>t", ":NvimTreeFocus<CR>", { noremap = true })
---------------------------------------------------------------------
-- G0
---------------------------------------------------------------------
local format_sync_grp = vim.api.nvim_create_augroup("G0Import", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('g0.format').goimports()
  end,
  group = format_sync_grp,
})
---------------------------------------------------------------------
-- Function
---------------------------------------------------------------------
P = function(v)
  print(vim.inspect(v))
  return v
end

-- reload a module
R = function(name)
  local plugin = require("lazy.core.config").plugins[name]
  require("lazy.core.loader").reload(plugin)
end
