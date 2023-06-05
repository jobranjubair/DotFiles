
vim.diagnostic.reset()
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
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
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
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

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

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
--   { import = 'custom.plugins' },
}, {})


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
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
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






-- old stuff below


-- return require('packer').startup({
-- 	function(use)

-- 		use({
-- 			'nvim-neo-tree/neo-tree.nvim',
-- 			branch = 'v2.x',
-- 			requires = {
-- 				'nvim-lua/plenary.nvim',
-- 				'kyazdani42/nvim-web-devicons',
-- 				'MunifTanjim/nui.nvim',
-- 			},
-- 			config = function()
-- 				require('neo-tree').setup({
-- 					close_if_last_window = true,
-- 					enable_diagnostics = false,
-- 					enable_git_status = true,
-- 					hijack_netrw_behavior = 'open_default',
-- 					window = {
-- 						mappings = {
-- 							['<esc>'] = 'close_window',
-- 						},
-- 					},
-- 					default_component_configs = {
-- 						icon = {
-- 							default = '',
-- 						},
-- 					},
-- 				})
-- 			end,
-- 		})
-- 		use({
-- 			'akinsho/nvim-bufferline.lua',
-- 			requires = 'kyazdani42/nvim-web-devicons',
-- 			config = function()
-- 				require('bufferline').setup({
-- 					options = {
-- 						diagnostics = 'nvim_lsp',
-- 						separator_style = 'slant',
-- 						max_name_length = 30,
-- 						show_close_icon = false,
-- 						show_buffer_close_icons = false,
-- 						right_mouse_command = '',
-- 						middle_mouse_command = 'bdelete! %d',
-- 					},
-- 				})
-- 			end,
-- 		})
-- 		use({ 'gruvbox-community/gruvbox', config = function()
-- 			vim.opt.background = 'dark' -- or "light" for light mode
-- 			vim.g.gruvbox_italic = 1
-- 			vim.g.gruvbox_sign_column = 'bg0'
-- 			vim.cmd('colorscheme gruvbox')
-- 		end,
-- 	})
-- 	use({
-- 		'hrsh7th/nvim-cmp',
-- 		requires = {
-- 			{ 'hrsh7th/cmp-buffer' },
-- 			{ 'hrsh7th/cmp-path' },
-- 			{ 'hrsh7th/cmp-calc' },
-- 			{ 'hrsh7th/cmp-nvim-lsp' },
-- 			{ 'hrsh7th/cmp-nvim-lsp-signature-help' },
-- 			{ 'hrsh7th/cmp-emoji' },
-- 		},
-- 		config = function()
-- 			vim.cmd([[
-- 			hi CmpItemKind guifg=#928374
-- 			hi CmpItemMenu guifg=#d5c4a1
-- 			]])
-- 			local cmp = require('cmp')
-- 			cmp.setup({
-- 				preselect = cmp.PreselectMode.None,
-- 				mapping = {
-- 					['<CR>'] = cmp.mapping.confirm({ select = true }),
-- 					['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
-- 				},
-- 				sources = {
-- 					{ name = 'nvim_lsp' },
-- 					{ name = 'nvim_lsp_signature_help' },
-- 					{ name = 'luasnip' },
-- 					{ name = 'path' },
-- 					{ name = 'buffer', keyword_length = 6 },
-- 					{ name = 'emoji' },
-- 					{ name = 'calc' },
-- 				},
-- 				snippet = {
-- 					expand = function(args)
-- 					end,
-- 				},
-- 			})
-- 		end,
-- 	})
-- 	use {
-- 		'nvim-telescope/telescope.nvim', tag = '0.1.0',
-- 		requires = { {'nvim-lua/plenary.nvim'} }
-- 	}
-- 	use({
-- 		'numToStr/Comment.nvim',
-- 		-- requires = { { 'JoosepAlviste/nvim-ts-context-commentstring' } },
-- 		config = function()
-- 			require('Comment').setup({
-- 				ignore = '^$',
-- 				--		pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
-- 			})
-- 		end,
-- 	})
-- 	use({
-- 		'tpope/vim-surround',
-- 		config = function()
-- 			-- make surround around [",',`] work as expected
-- 			vim.cmd[[
-- 			nmap ysa' ys2i'
-- 			nmap ysa" ys2i"
-- 			nmap ysa` ys2i`
-- 			]]
-- 		end,
-- 	})
-- 	use({
-- 		'williamboman/mason.nvim',
-- 		config = function()
-- 			require('mason').setup({})
-- 		end,
-- 	})
-- 	use({
-- 		'jose-elias-alvarez/null-ls.nvim',
-- 		requires = {
-- 			{ 'nvim-lua/plenary.nvim' },
-- 		},
-- 		config = function()
-- 			local null_ls = require('null-ls')
-- 			null_ls.setup({
-- 				sources = {
-- 					-- javascript
-- 					null_ls.builtins.formatting.prettier.with({
-- 						extra_args = { '--no-semi', '--single-quote' },
-- 					}),
-- 				},
-- 				root_dir = require('lspconfig/util').root_pattern(
-- 				'.null-ls-root',
-- 				'Makefile',
-- 				'.git',
-- 				'package.json'
-- 				),
-- 			})
-- 		end,
-- 	})
-- 	use({ -- required with tmux
-- 	'christoomey/vim-tmux-navigator',
-- 	init = function()
-- 		vim.g.tmux_navigator_no_mappings = 1
-- 	end,
-- 	config = function()
-- 		local map = vim.keymap.set
-- 		map('n', '<c-a><left>', ':TmuxNavigateLeft<cr>', { noremap = true, silent = true })
-- 		map('n', '<c-a><down>', ':TmuxNavigateDown<cr>', { noremap = true, silent = true } )
-- 		map('n', '<c-a><up>', ':TmuxNavigateUp<cr>', { noremap = true, silent = true })
-- 		map('n', '<c-a><right>', ':TmuxNavigateRight<cr>', { noremap = true, silent = true })

-- 	end,
-- })

-- end,
-- config = {
-- 	display = {
-- 		open_fn = function()
-- 			return require('packer.util').float({ border = 'single' })
-- 		end,
-- 	},
-- },
-- })

