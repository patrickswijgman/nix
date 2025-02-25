{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Browsers.
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  # Terminal.
  programs.ghostty.enable = true;

  # Editor.
  programs.neovim = {
    enable = true;

    # Search for plugins here https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins+
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      rose-pine
      nvim-treesitter.withAllGrammars
      auto-session
      nvim-lspconfig
      conform-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      telescope-nvim
      neo-tree-nvim
      nvim-surround
      copilot-vim
      neogit

      plenary-nvim # telescope, neo-tree
      nui-nvim # neo-tree
    ];
  };

  # Packages (that don't have a 'programs.<package>' option).
  home.packages = with pkgs; [
    # Dot file management
    chezmoi

    # CLI
    fzf
    ripgrep
    tree
    openvpn
    slides
    graph-easy
    cowsay

    # Programming languages
    nodejs_22

    # Language servers and formatters
    nixd
    nixfmt-rfc-style
    taplo
    lua
    lua-language-server
    stylua
    typescript-language-server
    vscode-langservers-extracted
    prettierd

    # Desktop apps
    spotify
    slack
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
