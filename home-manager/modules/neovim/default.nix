{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.neovim;
in
{
  options.neovim.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        actions-preview-nvim
        blink-cmp
        conform-nvim
        copilot-lua
        leap-nvim
        lualine-nvim
        nvim-autopairs
        nvim-lspconfig
        nvim-spectre
        nvim-spider
        nvim-surround
        nvim-tree-lua
        nvim-treesitter.withAllGrammars
        nvim-various-textobjs
        nvim-web-devicons
        telescope-nvim
        vague-nvim
        zen-mode-nvim
      ];
    };

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style

      lua-language-server
      stylua

      nodejs_22
      vtsls
      prettierd
      tailwindcss-language-server

      go
      gopls

      rustc
      cargo
      rust-analyzer
      rustfmt

      python3
      pyright
      ruff
      uv

      flutter332

      taplo
      yaml-language-server
      vscode-json-languageserver

      codebook
      simple-completion-language-server
    ];
  };
}
