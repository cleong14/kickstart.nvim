--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
      {
          "jcdickinson/http.nvim",
          build = "cargo build --workspace --release"
      },
      {
          "jcdickinson/codeium.nvim",
          dependencies = {
              "jcdickinson/http.nvim",
              "nvim-lua/plenary.nvim",
              "hrsh7th/nvim-cmp",
          },
          config = function()
              require("codeium").setup({
              })
          end
      }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      --- A native neovim extension for Codeium
      -- https://github.com/jcdickinson/codeium.nvim
      'jcdickinson/codeium.nvim',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = require("custom.plugins.gitsigns"),
  },
  {
    --- Extensible Neovim Scrollbar
    -- https://github.com/petertriho/nvim-scrollbar
    'petertriho/nvim-scrollbar',
    config = require("custom.plugins.scrollbar"),
  },
  {
    --- Hlsearch Lens for Neovim
    -- https://github.com/kevinhwang91/nvim-hlslens
    'kevinhwang91/nvim-hlslens',
    config = require("custom.plugins.hlslens"),
  },

  {
    -- doom-emacs' doom-one Lua port for Neovim
    -- https://github.com/NTBBloodbath/doom-one.nvim
    'NTBBloodbath/doom-one.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'doom-one'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = require("custom.plugins.lualine"),
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    config = require("custom.plugins.indent-blankline"),
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Set highlight on cursorline & cursorcolumn
vim.o.cursorcolumn = true
vim.o.cursorline = true

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 100
vim.o.timeoutlen = 400

-- 'block' style cursor all modes no blink
vim.o.guicursor = "a:blinkon0"

-- [Side]Scrolloff
vim.o.scrolloff = 999
vim.o.sidescrolloff = 999

-- reduce signcolumn movement. (1 - overwrites git, 2 - signs swap)
-- vim.o.signcolumn = "yes:2"

-- `10000` is the max history size allowed in nvim
vim.o.history = 10000

-- `10000` is the max number of changes that can be undone
vim.o.undolevels = 10000

-- exec cmds global by default
vim.o.gdefault = true

-- set window title
vim.o.title = true

-- expand tabs to spaces
vim.o.expandtab = true

-- round to next shiftwidth increment
vim.o.shiftround = true

-- number column width
-- vim.o.numberwidth = 4

-- autoindenting when starting a new line
vim.o.smartindent = true

-- copy structure of the existing lines indent when autoindenting
vim.o.copyindent = true

-- ignore case in search patterns
vim.o.ignorecase = true

-- honor case in search patterns if uppercase char is present
vim.o.smartcase = true

-- Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text
vim.o.breakindent = true

-- wrap long lines at a character in 'breakat' rather than at the last character
vim.o.linebreak = true

-- -- ["grepprg"] = "rg --vimgrep --no-heading --smart-case",
-- ["grepprg"] = "rg --hidden --vimgrep --smart-case --",
vim.o.grepprg = "rg --hidden --vimgrep --smart-case --"

vim.o.grepformat = "%f:%l:%c:%m"

vim.o.showbreak = "↳ "
vim.o.list = false
vim.o.listchars = "eol:↲,tab:▸ ,space:·,trail:_"

-- 0 forces user confirmation on initial load
vim.o.cmdheight = 1

-- Time in milliseconds to wait for a key code sequence to complete
-- vim.o.ttimeoutlen = 10

-- If this many milliseconds nothing is typed the swap file will be written to disk (see |crash-recovery|).  Also used for the |CursorHold| autocommand event.
vim.o.updatetime = 100

-- diff mode options
-- vim.o.diffopt = "internal,filler,closeoff"

-- conceal text
vim.o.conceallevel = 0

-- good spelling wordlist
vim.o.dictionary = "~/.config/nvim/spell/en.utf-8.add"
vim.o.spell = true
vim.o.spelllang = "en_us"

-- split directions
vim.o.splitbelow = true
vim.o.splitright = true

-- avoid all the |hit-enter| prompts caused by file messages
vim.o.shortmess = "filnxtToOsCFAI"

-- define what chars a part of keywords
vim.o.iskeyword = "@,48-57,192-255,$,_,-"

-- vim.o.tags = "./tags,**5/tags,tags;~"

-- sequence of letters describing how automatic formatting is done
--    no auto-formatting `gw`/`gww`: format line; `gp`/`gwap`: format paragraph
vim.o.formatoptions = "roqnl1"

vim.o.more = false
vim.o.wrap = false

-- do not include linebreak in selection
vim.o.selection = "old"

-- 0: default; 2: possibly fixes "'redrawtime' exceeded, syntax highlighting disabled" issue?
-- vim.o.regexpengine = 2

-- Set popup menu max height
vim.o.pumheight = 20

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,preview,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "awk",
    "bash",
    "comment",
    "commonlisp",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "dot",
    "fennel",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "gpg",
    "hcl",
    "html",
    "htmldjango",
    "http",
    "hurl",
    "ini",
    "java",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "jsonc",
    "julia",
    "latex",
    "luadoc",
    "luap",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "ninja",
    "nix",
    "passwd",
    "pem",
    "perl",
    "php",
    "puppet",
    "python",
    "regex",
    "requirements",
    "robot",
    "rst",
    "ruby",
    "rust",
    "scss",
    "smithy",
    "sql",
    "terraform",
    "todotxt",
    "toml",
    "tsv",
    "tsx",
    "typescript",
    "xml",
    "yaml",
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
local cmp = require("cmp")
local luasnip = require("luasnip")
require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.fn.stdpath("config") .. "/my-snippets/" })
luasnip.config.setup {}

local kind_icons = {
  Text          = "  ",
  Method        = " 󰆧 ",
  Function      = " 󰊕 ",
  Constructor   = "  ",
  Field         = " 󰇽 ",
  Variable      = "  ",
  Class         = " 󰠱 ",
  Interface     = "  ",
  Module        = "  ",
  Property      = " 󰜢 ",
  Unit          = "  ",
  Value         = " 󰎠 ",
  Enum          = "  ",
  Keyword       = " 󰌋 ",
  Snippet       = "  ",
  Color         = " 󰏘 ",
  File          = " 󰈙 ",
  Reference     = "  ",
  Folder        = " 󰉋 ",
  EnumMember    = "  ",
  Constant      = " 󰏿 ",
  Struct        = "  ",
  Event         = "  ",
  Operator      = " 󰆕 ",
  TypeParameter = " 󰅲 ",
  Codeium       = "  ",
}

--- Given an LSP item kind, returns a nerdfont icon
--- @param kind_type string LSP item kind
--- @return string Nerdfont Icon
local function get_kind_icon(kind_type)
  return kind_icons[kind_type]
end

--- Wraps nvim_replace_termcodes
--- @param str string
--- @return string
local function replace_termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
--- Helper function to check what <Tab> behaviour to use
--- @return boolean
local function check_backspace()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

--- Register codeium
-- local has_codeium, codeium = pcall(require, "codeium.source")
-- -- local has_codeium, codeium = pcall(require, "codeium.nvim.cmp")
-- if has_codeium then
--   cmp.register_source("codeium", codeium.new())
-- end

local Source = require("codeium.source")
local Server = require("codeium.api")
local update = require("codeium.update")

local s = Server:new()
update.download(function(err)
	if not err then
		Server.load_api_key()
		s.start()
	end
end)

local source = Source:new(s)
cmp.register_source("codeium", source)

cmp.setup({
  completion = {
    autocomplete = { "InsertEnter", "TextChanged" },
    completeopt = table.concat(vim.opt.completeopt:get(), ","),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  view = {
    entries = { name = 'custom' }, -- can be "custom", "wildmenu" or "native"
    docs = {
      auto_open = true,
    },
  },
  window = {
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      scrolloff = 999,
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      scrolloff = 999,
    },
  },
  formatting = {
    expandable_indicator = true,
    format = function(entry, item)
      item.kind = string.format("%s %s", get_kind_icon(item.kind), item.kind)
      item.menu = ({
        nvim_lsp                    = "[NvLSP]",
        luasnip                     = "[LSnip]",
        -- dynamic                     = "[Dynamic]",
        codeium                     = "[Codeium]",
        -- env                         = "[Env]",
        -- buffer                      = "[Buf]",
        -- nvim_lua                    = "[NvLua]",
        -- mdlink                      = "[Mdlink]",
        -- cmdline                     = "[Cmd]",
        -- -- treesitter                  = "[Tree]",
        -- -- vim_lsp                     = "[VLSP]",
        -- path                        = "[Path]",
        -- -- nvim_lsp_signature_help     = "[Sig]",
        -- -- cmp_tabnine                 = "[TNine]",
        -- rg                          = "[RG]",
        -- -- look                        = "[Look]",
        -- -- tags                        = "[Tags]",
        -- -- doxygen                     = "[Doxygen]",
        -- spell                       = "[Spell]",
        -- -- dictionary                  = "[Dict]",
        -- -- buffer_lines                = "[BufL]",
      })[entry.source.name]
      item.dup = ({
        nvim_lsp = 1,
        luasnip = 1,
        -- dynamic = 1,
        codeium = 1,
        -- env = 1,
        -- buffer = 1,
        -- nvim_lua = 1,
        -- mdlink = 1,
        -- cmdline = 1,
        -- -- treesitter = 1,
        -- -- vim_lsp = 1,
        -- path = 1,
        -- -- nvim_lsp_signature_help = 1,
        -- -- cmp_tabnine = 1,
        -- rg = 1,
        -- -- look = 1,
        -- -- tags = 1,
        -- -- doxygen = 1,
        -- spell = 1,
        -- -- dictionary = 1,
        -- -- buffer_lines = 1,
      })[entry.source.name] or 0
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- ['<C-n>'] = cmp.mapping.select_next_item(),
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.complete(),
    ['<C-s>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-q>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'codeium' },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
