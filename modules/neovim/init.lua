local augroup = vim.api.nvim_create_augroup("Config", { clear = true })

--- Options

vim.o.mouse = "a"
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 10
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

vim.o.wrap = true
vim.o.breakindent = true
vim.o.showbreak = "↪ "

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = "split"

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true

vim.o.completeopt = "menuone,noselect,popup,fuzzy"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Colorscheme

vim.cmd.colorscheme("vague")

--- Plugins

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
			},
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "biome", "prettierd", stop_after_first = true },
		typescript = { "biome", "prettierd", stop_after_first = true },
		javascriptreact = { "biome", "prettierd", stop_after_first = true },
		typescriptreact = { "biome", "prettierd", stop_after_first = true },
		html = { "biome", "prettierd", stop_after_first = true },
		css = { "biome", "prettierd", stop_after_first = true },
		json = { "biome", "prettierd", stop_after_first = true },
		jsonc = { "biome", "prettierd", stop_after_first = true },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		toml = { "taplo" },
		python = { "ruff_organize_imports", "ruff_format" },
		go = { "gofmt" },
		lua = { "stylua" },
		nix = { "nixfmt" },
		_ = { "trim_whitespace" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
})

require("butter").setup({
	show_hidden = true,
	no_ignore = true,
	exclude = { ".git", "node_modules", "dist" },
	auto_open = true,
})

--- Keymaps

vim.keymap.set("n", "<leader>e", "<cmd>Butter<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>s", "<cmd>Telescope git_status<cr>")
vim.keymap.set("n", "<leader>'", "<cmd>Telescope resume<cr>")

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')

vim.keymap.set("v", "R", '"_dP')
vim.keymap.set("v", "<leader>R", '"_d"+P')

vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { silent = true })

vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "U", "<nop>")

--- LSP

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})

vim.lsp.config("vtsls", {
	settings = {
		javascript = {
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "js",
			},
		},
		typescript = {
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "js",
			},
		},
	},
})

vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://www.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig.json" },
					url = "https://www.schemastore.org/tsconfig.json",
				},
			},
		},
	},
})

vim.lsp.config("codebook", {
	filetypes = {
		"c",
		"config",
		"css",
		"fish",
		"gitcommit",
		"go",
		"haskell",
		"html",
		"java",
		"javascript",
		"javascriptreact",
		"lua",
		"markdown",
		"nix",
		"php",
		"python",
		"ruby",
		"rust",
		"swift",
		"text",
		"toml",
		"typescript",
		"typescriptreact",
		"zig",
	},
})

vim.lsp.enable({
	"biome",
	"codebook",
	"cssls",
	"fish_lsp",
	"jsonls",
	"lua_ls",
	"nixd",
	"taplo",
	"vtsls",
	"yamlls",
})

vim.lsp.semantic_tokens.enable(false)

local all_chars = {}
for i = 32, 126 do
	table.insert(all_chars, string.char(i))
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client and client:supports_method("textDocument/completion") then
			client.server_capabilities.completionProvider.triggerCharacters = all_chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

--- Diagnostics

vim.diagnostic.config({
	severity_sort = true,
})

--- Auto commands

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})
