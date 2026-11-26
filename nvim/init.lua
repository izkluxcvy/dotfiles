vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = -1
-- vim.opt.cinoptions:append({ "(0" })
vim.opt.cinoptions = ":0,l1,(0"
vim.opt.number = true
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.termguicolors = true
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.number = false

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"maxmx03/solarized.nvim",
		lazy = false,
		priority = 1000,
		---@type solarized.config
		opts = {},
		config = function(_, opts)
			vim.o.termguicolors = true
			vim.o.background = "dark"
			require("solarized").setup(opts)
			vim.cmd.colorscheme "solarized"
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {
            enable_check_bracket_line = false,
        }
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufNewFile", "BufReadPre" }
	},
	{
		"mason-org/mason.nvim",
		event = {"BufNewFile", "BufReadPre"},
		opts = {}
	},
	{
		"stevearc/conform.nvim",
		opts = {}
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		event = "InsertEnter",
	},
	{
		"hrsh7th/cmp-buffer",
		event = "InsertEnter",
	},
	{
		"hrsh7th/cmp-path",
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"hrsh7th/cmp-cmdline",
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
	},
    -- {
    --     "saghen/blink.cmp",
    --     dependencies = {
    --         "saghen/blink.lib",
    --     },
    --     build = function()
    --         require("blink.cmp").build():wait(60000)
    --     end,
    --     opts = {}
    -- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {}
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {}
	},
	{
		"numToStr/Comment.nvim",
		opts = {}
	},
	{
		"github/copilot.vim",
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {}
	},
	{
		"romgrk/barbar.nvim",
		init = function() vim.g.barbar_auto_setup = false end,
	},
    {
        "nvim-neo-tree/neo-tree.nvim",
        -- dir = "/home/user/dev/neo-tree.nvim",
        -- branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
    }
})

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
	callback = function(ctx)
		pcall(vim.treesitter.start)
	end,
})

-- lsp
vim.lsp.enable({
	"rust-analyzer",
	"clangd",
})
vim.o.winborder = "rounded"
vim.diagnostic.config({
    float = {
        border = "rounded",
    },
})
vim.lsp.config("rust-analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_makers = { "Cargo.toml" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = {"sqlite", "web", "api"}
			}
		}
	}
})

-- conform
require("conform").setup({
	formatters_by_ft = {
		rust = { "rustfmt", lsp_format = "fallback" },
        c = { "clang-format" },
        cpp = { "clang-format" },
	},
    format_on_save = function(bufnr)
        if vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save then
            return
        end
        return {
            timeout_ms = 500,
        }
    end
})
vim.api.nvim_create_user_command("ConformDisable", function()
    vim.g.disable_format_on_save = true
end, { desc = "Disable format on save globally" })
vim.api.nvim_create_user_command("ConformEnable", function()
    vim.g.disable_format_on_save = false
end, { desc = "Enable format on save globally" })

-- cmp
local cmp = require("cmp")
cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" }
	}, {
        {
            name = "path",
            option = {
                -- trailing_slash = true,
                -- label_trailing_slash = true,
            }
        }
    }),
    window = {
        completion = {
            border = "rounded",
        },
        documentation = {
            border = "rounded",
        },
    },
	mapping = cmp.mapping.preset.insert({
		['<TAB>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		['<CR>'] = function(fallback)
			if cmp.visible() and cmp.get_selected_entry() then
				cmp.confirm()
			else
				fallback()
			end
		end,
		['<Up>'] = function(fallback)
			if cmp.visible() and cmp.get_selected_entry() then
				cmp.select_prev_item()
			else
				cmp.close()
				fallback()
			end
		end,
		['<Down>'] = function(fallback)
			if cmp.visible() and cmp.get_selected_entry() then
				cmp.select_next_item()
			else
				cmp.close()
				fallback()
			end
		end,
	}),
})
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{
            name = 'cmdline',
            option = {
                -- treat_trailing_slash = false
            }
        }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- barbar
require("barbar").setup{
	auto_hide = 1,
	icons = {
		filetype = {
			enabled = false,
		},
        button = false,
	}
}

-- keymaps
vim.keymap.set("n", "<C-_>", "<cmd>ToggleTerm<CR>")
vim.keymap.set("t", "<C-_>", "<cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>")
vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
vim.keymap.set("n", "<", "<cmd>BufferPrevious<CR>")
vim.keymap.set("n", ">", "<cmd>BufferNext<CR>")
vim.keymap.set("n", "td", "<cmd>BufferDelete<CR>")
vim.keymap.set("n", "tt", "<cmd>enew<CR>")
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle reveal<CR>")

-- pre
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})
