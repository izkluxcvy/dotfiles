require("plugins")
require("plugin_config")
require("keymap")

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.cmd("colorscheme terafox")
vim.notify = require("notify")
vim.cmd("set mouse=nvcr")
vim.cmd("hi DiagnosticVirtualTextError guibg=dark")
vim.cmd("hi DiagnosticVirtualTextHint guibg=dark")
vim.cmd("hi DiagnosticVirtualTextWarn guibg=dark")
vim.cmd("hi DiagnosticVirtualTextInfo guibg=dark")
vim.opt.pumblend = 15
