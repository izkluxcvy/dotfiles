local util = require("util")

vim.o.timeoutlen = 300

-- Escape
util.nnoremap("<C-j>", "<ESC>")
util.inoremap("<C-j>", "<ESC>")
util.vnoremap("<C-j>", "<ESC>")

-- Plugins
util.nnoremap(
	";s",
	"<cmd>if stridx(@%, 'SidebarNvim') == -1<CR>SidebarNvimFocus<CR>else<CR>SidebarNvimClose<CR>endif<CR>"
)
util.nnoremap(";w", "<cmd>bdelete<CR>")
util.nnoremap(";t", "<cmd>tabnew<CR>")
util.nnoremap(";f", "<cmd>Telescope find_files<CR>")
util.nnoremap("n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>")
util.nnoremap("N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>")
util.nnoremap("*", "*<Cmd>lua require('hlslens').start()<CR>")
util.nnoremap("#", "#<Cmd>lua require('hlslens').start()<CR>")
util.nnoremap("<space>l", ":noh<CR>")
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("t", "<C-w>h", "<cmd>wincmd h<CR>", opts)
vim.api.nvim_set_keymap("t", "<C-w>j", "<cmd>wincmd j<CR>", opts)
vim.api.nvim_set_keymap("t", "<C-w>k", "<cmd>wincmd k<CR>", opts)
vim.api.nvim_set_keymap("t", "<C-w>l", "<cmd>wincmd l<CR>", opts)

-- Switch buffers with tab
util.nnoremap("<C-h>", "<cmd>BufferLineCyclePrev<cr>")
util.nnoremap("<C-l>", ":BufferLineCycleNext<cr>")

-- Easier pasting
util.nnoremap("[p", ":pu!<cr>")
util.nnoremap("]p", ":pu<cr>")

-- Clear search with <esc>
util.map("", "<esc>", ":noh<cr>")
util.nnoremap("gw", "*N")
util.xnoremap("gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
util.nnoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.xnoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.onoremap("n", "'Nn'[v:searchforward]", { expr = true })
util.nnoremap("N", "'nN'[v:searchforward]", { expr = true })
util.xnoremap("N", "'nN'[v:searchforward]", { expr = true })
util.onoremap("N", "'nN'[v:searchforward]", { expr = true })

-- better indenting
util.vnoremap("<", "<gv")
util.vnoremap(">", ">gv")

util.nnoremap("<space>cu", function()
	local number = math.random(math.pow(2, 127) + 1, math.pow(2, 128))
	return "i" .. string.format("%.0f", number)
end, {
	expr = true,
})
