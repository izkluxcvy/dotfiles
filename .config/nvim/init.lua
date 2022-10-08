require("util")
require("options")
require("config.keys")

vim.notify("test")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
	require("plugins")
end, 0)
