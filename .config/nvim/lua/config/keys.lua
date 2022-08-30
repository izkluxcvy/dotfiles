local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

local presets = require("which-key.plugins.presets")
presets.objects["a("] = nil
wk.setup({
    show_help = false,
    triggers = "auto",
    plugins = { spelling = true },
    key_labels = { ["<leader>"] = "SPC" },
})

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

wk.register({
    ["]"] = {
        name = "next",
        r = { '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', "Next Reference" },
    },
    ["["] = {
        name = "previous",
        r = { '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', "Next Reference" },
    },
})

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
    [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]]   ,
    false
)

local leader = {
    ["w"] = {
        name = "+windows",
        ["w"] = { "<C-W>p", "other-window" },
        ["d"] = { "<C-W>c", "delete-window" },
        ["-"] = { "<C-W>s", "split-window-below" },
        ["|"] = { "<C-W>v", "split-window-right" },
        ["2"] = { "<C-W>v", "layout-double-columns" },
        ["h"] = { "<C-W>h", "window-left" },
        ["j"] = { "<C-W>j", "window-below" },
        ["l"] = { "<C-W>l", "window-right" },
        ["k"] = { "<C-W>k", "window-up" },
        ["H"] = { "<C-W>5<", "expand-window-left" },
        ["J"] = { ":resize +5", "expand-window-below" },
        ["L"] = { "<C-W>5>", "expand-window-right" },
        ["K"] = { ":resize -5", "expand-window-up" },
        ["="] = { "<C-W>=", "balance-window" },
        ["s"] = { "<C-W>s", "split-window-below" },
        ["v"] = { "<C-W>v", "split-window-right" },
    },
    c = { v = { "<cmd>Vista!!<CR>", "Vista" }, o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" } },
    b = {
        name = "+buffer",
        ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
        ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
        ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
        ["d"] = { "<cmd>:BDelete this<CR>", "Delete Buffer" },
        ["D"] = { "<cmd>:bd<CR>", "Delete Buffer & Window" },
        ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
    },
    g = {
        name = "+git",
        g = { "<cmd>Neogit kind=split<CR>", "NeoGit" },
        l = {
            function()
                require("util").float_terminal("lazygit")
            end,
            "LazyGit",
        },
        c = { "<Cmd>Telescope git_commits<CR>", "commits" },
        b = { "<Cmd>Telescope git_branches<CR>", "branches" },
        s = { "<Cmd>Telescope git_status<CR>", "status" },
        d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
        h = { name = "+hunk" },
    },
    ["h"] = {
        name = "+help",
        t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
        c = { "<cmd>:Telescope commands<cr>", "Commands" },
        h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
        m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
        k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
        s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
        l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
        f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
        o = { "<cmd>:Telescope vim_options<cr>", "Options" },
        a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
        p = {
            name = "+packer",
            p = { "<cmd>PackerSync<cr>", "Sync" },
            s = { "<cmd>PackerStatus<cr>", "Status" },
            i = { "<cmd>PackerInstall<cr>", "Install" },
            c = { "<cmd>PackerCompile<cr>", "Compile" },
        },
    },
    u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
    s = {
        name = "+search",
        g = { "<cmd>Telescope live_grep<cr>", "Grep" },
        b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
        s = {
            function()
                require("telescope.builtin").lsp_document_symbols({
                    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait" },
                })
            end,
            "Goto Symbol",
        },
        h = { "<cmd>Telescope command_history<cr>", "Command History" },
        m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
        r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
    },
    f = {
        name = "+file",
        t = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        n = { "<cmd>enew<cr>", "New File" },
        z = "Zoxide",
        d = "Dot Files",
    },
    o = {
        name = "+open",
        p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
        g = { "<cmd>Glow<cr>", "Markdown Glow" },
        n = { "<cmd>lua require('github-notifications.menu').notifications()<cr>", "GitHub Notifications" },
    },
    p = {
        name = "+project",
        p = "Open Project",
        b = { ":Telescope file_browser cwd=~/projects<CR>", "Browse ~/projects" },
    },
    t = {
        name = "toggle",
        f = {
            require("config.lsp.formatting").toggle,
            "Format on Save",
        },
        s = {
            function()
                util.toggle("spell")
            end,
            "Spelling",
        },
        w = {
            function()
                util.toggle("wrap")
            end,
            "Word Wrap",
        },
        n = {
            function()
                util.toggle("relativenumber", true)
                util.toggle("number")
            end,
            "Line Numbers",
        },
    },
    ["<tab>"] = {
        name = "workspace",
        ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },

        n = { "<cmd>tabnext<CR>", "Next" },
        d = { "<cmd>tabclose<CR>", "Close" },
        p = { "<cmd>tabprevious<CR>", "Previous" },
        ["]"] = { "<cmd>tabnext<CR>", "Next" },
        ["["] = { "<cmd>tabprevious<CR>", "Previous" },
        f = { "<cmd>tabfirst<CR>", "First" },
        l = { "<cmd>tablast<CR>", "Last" },
    },
    ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    [" "] = "Find File",
    ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
    [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
    [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
    q = {
        name = "+quit/session",
        q = { "<cmd>:qa<cr>", "Quit" },
        ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
        s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
        l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
        d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
    },
    x = {
        name = "+errors",
        x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
        t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
        T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
        l = { "<cmd>lopen<cr>", "Open Location List" },
        q = { "<cmd>copen<cr>", "Open Quickfix List" },
    },
    Z = { [[<cmd>lua require("zen-mode").reset()<cr>]], "Zen Mode" },
    z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
    T = { [[<Plug>PlenaryTestFile]], "Plenary Test" },
    D = {
        function()
            util.docs()
        end,
        "Create Docs from README.md",
    },
}

for i = 0, 10 do
    leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto", h = "Hop Word" }, s = "Hop Word1" })
