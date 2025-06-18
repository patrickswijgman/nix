{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Load home-manager modules.
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "patrick";
  home.homeDirectory = "/home/patrick";

  # Browsers
  programs.zen-browser.enable = true;
  programs.chromium.enable = true;

  # Editors
  programs.zed-editor.enable = true;
  programs.neovim.enable = true;

  # Terminal
  programs.ghostty.enable = true;

  # Packages (that don't have a 'programs.<package>' option).
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.hack # Install for nerd font icons.

    # Shell
    oh-my-posh

    # CLI
    chezmoi
    fzf
    ripgrep
    fd
    tree
    openvpn
    bat
    dive
    httpie
    presenterm
    npm-check-updates

    # Terminal apps
    lazygit
    lazydocker

    # Programming
    nixd
    nixfmt-rfc-style
    nodejs_22
    go
    python3

    # Music
    guitarix
    helvum
    qjackctl

    # Desktop apps
    gnome-tweaks
    aseprite
  ];

  # Gaming
  programs.lutris = {
    enable = true;
    protonPackages = [ pkgs.proton-ge-bin ];
    winePackages = [ pkgs.wineWow64Packages.full ];
    runners.steam.settings.system = {
      prefix_command = "gamemoderun";
    };
  };

  # Enable font config so that applications e.g. Zed can find installed fonts.
  fonts.fontconfig = {
    enable = true;
  };

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
