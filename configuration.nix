# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

let
  playwright-test = inputs.playwright.packages.${pkgs.system}.playwright-test;
  playwright-driver = inputs.playwright.packages.${pkgs.system}.playwright-driver;
in
{
  imports = [
    # Load modules from flakes.
    inputs.home-manager.nixosModules.default
  ];

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Enable networking.
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keyboard layout.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable multimedia via PipeWire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable home manager.
  # See options here https://home-manager-options.extranix.com/?query=&release=release-24.11
  home-manager = {
    # Use global nixpkgs config to allow unfree packages.
    useGlobalPkgs = true;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    usbutils
    vim
    curl
    git
    gcc

    # Playwright
    # Needs to be at system level because the environment variables point to system level as well.
    playwright-test
    playwright-driver
  ];

  # Environment variables.
  # Can't be set per user as the shell is not configured via home-manager.
  environment.sessionVariables = {
    # Set defaults.
    BROWSER = "zen";
    TERMINAL = "ghostty";
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";

    # Don't show "(.venv)" in shell prompt.
    VIRTUAL_ENV_DISABLE_PROMPT = "1";

    # Playwright.
    PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
