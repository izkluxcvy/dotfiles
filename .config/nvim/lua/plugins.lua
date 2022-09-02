local packer = require("util.packer")

local config = {
	profile = {
		enable = true,
		threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
	},
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
	opt_default = true,
	-- list of plugins that should be taken from ~/projects
	-- this is NOT packer functionality!
	local_plugins = {},
}

local function plugins(use)
	-- Packer can manage itself as an optional plugin
	use({ "wbthomason/packer.nvim" })
	use({ "stevearc/dressing.nvim", event = "VimEnter" })
	use({
		"rcarriga/nvim-notify",
		after = "mason.nvim",
		config = function()
			vim.notify = require("notify")
		end,
	})
	-- LSP
	use({
		"neovim/nvim-lspconfig",
		after = { "mason-lspconfig.nvim", "mason.nvim" },
		config = function()
			require("config.lsp")
			vim.cmd("LspStart")
		end,
		requires = {
			{ "jose-elias-alvarez/null-ls.nvim", module = "null-ls" },
		},
	})

	use({
		"williamboman/mason.nvim",
		after = "fidget.nvim",
		-- module = "nvim-lsp-installer",
	})

	use({
		"williamboman/mason-lspconfig.nvim",
		after = "fidget.nvim",
	})

	use({
		"kkharji/lspsaga.nvim",
		after = "mason.nvim",
		config = function()
			require("config.lsp.saga")
			require("config.lsp.diagnostics")
		end,
		requires = "neovim/nvim-lspconfig",
	})

	use({
		"onsails/lspkind-nvim",
		opt = false,
	})

	use({
		"j-hui/fidget.nvim",
		after = "nvim-treesitter",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({
		"simrat39/rust-tools.nvim",
		module = "rust-tools",
	})

	use({ "kazhala/close-buffers.nvim", cmd = "BDelete" })

	use({
		"hrsh7th/nvim-cmp",
		after = { "LuaSnip", "nvim-autopairs" },
		config = function()
			require("config.compe")
		end,
		wants = { "LuaSnip" },
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{
				"L3MON4D3/LuaSnip",
				event = { "InsertEnter", "CmdlineEnter" },
				wants = "friendly-snippets",
				config = function()
					require("config.snippets")
				end,
			},
			"rafamadriz/friendly-snippets",
			{
				module = "nvim-autopairs",
				"windwp/nvim-autopairs",
				event = { "InsertEnter", "CmdlineEnter" },
				config = function()
					require("config.autopairs")
				end,
			},
		},
	})

	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })

	use({
		"windwp/nvim-autopairs",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("config.autopairs")
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("config.snippets")
		end,
	})

	use({
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline" },
	})

	use({
		"numToStr/Comment.nvim",
		keys = { "gc", "gcc", "gbc" },
		config = function()
			require("config.comments")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		opt = false,
		-- event = "BufReadPre",
		module = "nvim-treesitter",
		requires = {
			{ "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
		},
		config = [[require('config.treesitter')]],
	})

	-- Theme: color schemes
	-- use({
	--     "jayden-chan/base46.nvim",
	--     opt = false,
	--     -- event = "VimEnter",
	--     config = function()
	--         require("config.theme")
	--     end,
	-- })
	--
	use({
		"folke/tokyonight.nvim",
		opt = false,
		config = function()
			require("config.theme")
		end,
	})

	-- Theme: icons
	use({
		"kyazdani42/nvim-web-devicons",
		module = "nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	})

	-- Dashboard
	use({ "glepnir/dashboard-nvim", opt = false, config = [[require('config.dashboard')]] })

	use({ "nvim-lua/plenary.nvim", module = "plenary" })
	use({ "nvim-lua/popup.nvim", module = "popup" })

	use({
		"sidebar-nvim/sidebar.nvim",
		cmd = { "SidebarNvimFocus", "SidebarNvimClose" },
		config = function()
			require("config.sidebar")
		end,
	})

	-- Fuzzy finder
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("config.telescope")
		end,
		cmd = { "Telescope" },
		module = "telescope",
		keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
	})

	-- Indent Guides and rainbow brackets
	use({
		"lukas-reineke/indent-blankline.nvim",
		after = "nvim-treesitter",
		config = function()
			require("config.blankline")
		end,
	})

	-- Tabs
	use({
		"akinsho/nvim-bufferline.lua",
		event = "TabNew",
		wants = "nvim-web-devicons",
		config = function()
			require("config.bufferline")
		end,
	})

	-- Terminal
	use({
		"akinsho/nvim-toggleterm.lua",
		keys = "<C-\\>",
		config = function()
			require("config.terminal")
		end,
	})

	-- Smooth Scrolling
	use({
		"karb94/neoscroll.nvim",
		keys = { "<C-u>", "<C-d>", "gg", "G" },
		config = function()
			require("config.scroll")
		end,
	})
	use({
		"edluffy/specs.nvim",
		after = "neoscroll.nvim",
		config = function()
			require("config.specs")
		end,
	})
	-- use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }
	use({
		"petertriho/nvim-scrollbar",
		after = "nvim-hlslens",
		config = function()
			require("config.scrollbar")
		end,
	})

	use({
		"kevinhwang91/nvim-hlslens",
		after = "mason.nvim",
	})

	-- Git Gutter
	use({
		"lewis6991/gitsigns.nvim",
		wants = "plenary.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		setup = function()
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				callback = function()
					vim.fn.system("git rev-parse " .. vim.fn.expand("%:p:h"))
					if vim.v.shell_error == 0 then
						vim.schedule(function()
							require("packer").loader("gitsigns.nvim")
						end)
					end
				end,
			})
		end,
		config = function()
			require("config.gitsigns")
		end,
	})
	-- use {
	--   "kdheepak/lazygit.nvim",
	--   cmd = "LazyGit",
	--   config = function() vim.g.lazygit_floating_window_use_plenary = 0 end
	-- }
	use({
		"TimUntersberger/neogit",
		cmd = "Neogit",
		config = function()
			require("config.neogit")
		end,
	})
	use({ "rlch/github-notifications.nvim", module = "github-notifications" })
	-- Statusline
	use({
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = [[require('config.lualine')]],
		wants = "nvim-web-devicons",
	})

	use({
		"norcalli/nvim-colorizer.lua",
		after = "mason.nvim",
		config = function()
			require("config.colorizer")
		end,
	})

	use({ "npxbr/glow.nvim", cmd = "Glow" })

	use({
		"plasticboy/vim-markdown",
		requires = "godlygeek/tabular",
		ft = "markdown",
	})
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
		cmd = { "MarkdownPreview" },
	})

	-- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

	-- use({ "wfxr/minimap.vim", config = function()
	--   require("config.minimap")
	-- end })

	use({
		"phaazon/hop.nvim",
		keys = { "gh" },
		cmd = { "HopWord", "HopChar1" },
		config = function()
			require("util").nmap("gh", "<cmd>HopWord<CR>")
			-- require("util").nmap("s", "<cmd>HopChar1<CR>")
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({})
		end,
	})

	use({
		"ggandor/lightspeed.nvim",
		keys = { "f", "F", "t", "T" },
		config = function()
			require("config.lightspeed")
		end,
	})

	use({
		"folke/trouble.nvim",
		after = "mason.nvim",
		wants = "nvim-web-devicons",
		cmd = { "TroubleToggle", "Trouble" },
		config = function()
			require("trouble").setup({
				auto_open = false,
				use_diagnostic_signs = true, -- en
			})
		end,
	})

	use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

	use({ "mbbill/undotree", cmd = "UndotreeToggle" })

	-- use({ "mjlbach/babelfish.nvim", module = "babelfish" })

	use({ "folke/twilight.nvim", module = "twilight" })
	use({
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		config = function()
			require("zen-mode").setup({
				plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
			})
		end,
	})

	use({
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		module = "diffview",
		config = function()
			require("config.diffview")
		end,
	})

	use({
		"RRethy/vim-illuminate",
		event = "CursorHold",
		module = "illuminate",
		config = function()
			vim.g.Illuminate_delay = 1000
		end,
	})

	use("nanotee/luv-vimdocs")
	use({
		"andymass/vim-matchup",
		after = "mason.nvim",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	})

	use({
		"nathom/filetype.nvim",
		opt = false,
		config = function()
			require("config.filetype")
		end,
	})

	use({
		"lewis6991/impatient.nvim",
		opt = false,
		config = function()
			require("impatient")
		end,
	})
end

return packer.setup(config, plugins)
