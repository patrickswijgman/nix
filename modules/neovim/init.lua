-------------------
---- VARIABLES ----
-------------------

local augroup = vim.api.nvim_create_augroup("Config", { clear = true })

-----------------
---- OPTIONS ----
-----------------

-- General
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

-- Line wrapping
vim.o.wrap = true
vim.o.breakindent = true
vim.o.showbreak = "↪ "

-- Splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- Persistence
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = "nosplit"

-- Indentation
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true

-- Completion
vim.o.completeopt = "menuone,noselect,popup,fuzzy"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable builtin file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---------------------
---- COLORSCHEME ----
---------------------

vim.cmd.colorscheme("vague")

-----------------
---- PLUGINS ----
-----------------

require("telescope").setup({
  defaults = {
    path_display = { "filename_first" },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
        ["<c-s>"] = require("telescope.actions").select_horizontal,
        ["<c-v>"] = require("telescope.actions").select_vertical,
        ["<c-up>"] = require("telescope.actions").cycle_history_prev,
        ["<c-down>"] = require("telescope.actions").cycle_history_next,
        ["<m-p>"] = require("telescope.actions.layout").toggle_preview,
      },
    },
    vimgrep_arguments = { "rg", "--vimgrep", "--smart-case", "--trim", "--hidden", "--no-ignore", "--glob=!.git", "--glob=!node_modules", "--glob=!dist" },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type=file", "--hidden", "--no-ignore", "--exclude=.git", "--exclude=node_modules", "--exclude=dist" },
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

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

require("bulb").setup({
  clients = {
    enabled = {
      "biome",
      "codebook",
      "cssls",
      "fish_lsp",
      "jsonls",
      "lua_ls",
      "nixd",
      "vtsls",
    },
    config = {
      lua_ls = {
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
      },
      vtsls = {
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
      },
      codebook = {
        filetypes = {
          "css",
          "fish",
          "gitcommit",
          "go",
          "html",
          "javascript",
          "javascriptreact",
          "lua",
          "markdown",
          "nix",
          "python",
          "rust",
          "text",
          "toml",
          "typescript",
          "typescriptreact",
        },
      },
    },
    semantic_tokens = false,
  },
  completion = {
    enable = true,
    autotrigger = true,
    trigger_characters = require("bulb.core").get_trigger_characters(),
  },
})

require("birb").setup({
  use_folds = true,
  auto_open_folds = true,
})

local function filename()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  return vim.fs.joinpath(cwd, file)
end

require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  tabline = {
    lualine_a = { "buffers" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "tabs" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = { filename },
    lualine_x = { "searchcount", "diagnostics", "filetype", "location" },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { filename },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

require("nvim-surround").setup({})
require("nvim-autopairs").setup({})
require("scope").setup({})

-----------------
---- KEYMAPS ----
-----------------

-- General
vim.keymap.set("n", "<leader>e", "<cmd>Butter<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>s", "<cmd>Telescope git_status<cr>")
vim.keymap.set("n", "<leader>'", "<cmd>Telescope resume<cr>")
vim.keymap.set("n", "<leader>i", "<cmd>Inspect<cr>")
vim.keymap.set("n", "<leader>x", "<cmd>source %<cr>")

-- Tabs
vim.keymap.set("n", "<c-h>", "<cmd>tabprev<cr>")
vim.keymap.set("n", "<c-l>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<c-t>", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<c-q>", "<cmd>tabclose<cr>")

-- Buffers
vim.keymap.set("n", "H", "<cmd>bprev<cr>")
vim.keymap.set("n", "L", "<cmd>bnext<cr>")
vim.keymap.set("n", "Q", "<cmd>Bwipeout<cr>")

-- LSP
vim.keymap.set("n", "<c-]>", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "gri", "<cmd>Telescope lsp_implementations<cr>")
vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references<cr>")
vim.keymap.set("n", "grt", "<cmd>Telescope lsp_type_definitions<cr>")
vim.keymap.set("n", "gre", "<cmd>Telescope diagnostics bufnr=0<cr>")
vim.keymap.set("n", "grO", "<cmd>Telescope lsp_workspace_symbols<cr>")
vim.keymap.set("n", "gO", "<cmd>Telescope lsp_document_symbols<cr>")

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')

-- Replace
vim.keymap.set("v", "R", '"_dP')
vim.keymap.set("v", "<leader>R", '"_d"+P')

-- Other
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { silent = true })

-- Disabled
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "U", "<nop>")

---------------------
---- DIAGNOSTICS ----
---------------------

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
})

--------------------
---- TREESITTER ----
--------------------

-- Use normal highlights for lua docs.
vim.treesitter.query.set("lua", "injections", "")

-----------------------
---- AUTO COMMANDS ----
-----------------------

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})
