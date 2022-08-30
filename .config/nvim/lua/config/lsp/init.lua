local mason = require("mason")
local mason_package = require("mason-core.package")
local mason_registry = require("mason-registry")
local null_ls = require("null-ls")

mason.setup({})


local null_sources = {}
table.insert(null_sources, null_ls.builtins.formatting["rustfmt"]) -- rustfmt

for _, package in ipairs(mason_registry.get_installed_packages()) do
	local package_categories = package.spec.categories[1]
	if package_categories == mason_package.Cat.Formatter then
		table.insert(null_sources, null_ls.builtins.formatting[package.name])
	end
	if package_categories == mason_package.Cat.Linter then
		table.insert(null_sources, null_ls.builtins.diagnostics[package.name])
	end
end

null_ls.setup({

	sources = null_sources,
	on_attach = function(client, bufnr)

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format()
					vim.cmd("Lspsaga toggle_virtual_text")
				end,
			})
		end
	end,
})

require("mason-lspconfig").setup({})

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({})
	end,
})

require("lspconfig").rust_analyzer.setup({

	["rust-analyzer"] = {
		checkOnSave = {
			command = "clippy",
		},
	},

})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = true,
	signs = true,
	update_in_insert = false,
})
