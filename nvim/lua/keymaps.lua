-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })



-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- vim.keymap.set('n', '<leader>o', 'o<esc>', {})
-- vim.keymap.set('n', '<leader>O', 'O<esc>', {})
-- vim.keymap.set('i', 'jk', '<esc>', {})
-- vim.keymap.set('n', '<leader>l', ':BufferLineCycleNext<cr>', {})
-- vim.keymap.set('n', '<leader>h', ':BufferLineCyclePrev<cr>', {})
-- vim.keymap.set('n', '<leader>L', ':BufferLineMoveNext<cr>', {})
-- vim.keymap.set('n', '<leader>H', ':BufferLineMovePrev<cr>', {})
-- vim.keymap.set('n', '<leader>d', ':bp <BAR> bd #<cr>', {})


-- -- remove pauses after j in insert mode
-- vim.opt.timeoutlen = 1000
-- vim.opt.ttimeoutlen = 0

-- -- use system clipboard
-- vim.opt.clipboard:prepend({ 'unnamedplus' })

-- vim.keymap.set('n', '<leader>t', ':NeoTreeRevealToggle<cr>', {}) 

-- vim.api.nvim_create_augroup('neotree', {})
-- vim.api.nvim_create_autocmd('vimenter',  {
-- 	group = 'neotree',
-- 	pattern = '*',
-- 	command = 'Neotree show left',
-- }) 
