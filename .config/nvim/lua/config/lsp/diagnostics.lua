local M = {}

M.signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

function M.setup()
    -- Automatically update diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
    })

    for type, icon in pairs(M.signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

vim.cmd("hi DiagnosticVirtualTextError guibg=dark")
vim.cmd("hi DiagnosticVirtualTextHint guibg=dark")
vim.cmd("hi DiagnosticVirtualTextWarn guibg=dark")
vim.cmd("hi DiagnosticVirtualTextInfo guibg=dark")
vim.cmd("hi DiagnosticVirtualTextError gui=underline")
vim.cmd("hi DiagnosticVirtualTextHint gui=underline")
vim.cmd("hi DiagnosticVirtualTextWarn gui=underline")
vim.cmd("hi DiagnosticVirtualTextInfo gui=underline")

return M
