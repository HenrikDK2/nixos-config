{ locale, pkgs, ... }:

{
  imports = [
    # Bootloader and kernel configuration
    ./modules/boot.nix

    # Network configuration (hostname, networking, firewall, etc.)
    ./modules/networking.nix

    # System locale, timezone, and keyboard settings
    ./modules/locale.nix

    # Audio stack configuration (PipeWire, ALSA, PulseAudio compatibility)
    ./modules/audio.nix
  ];

  # Desktop environment (GNOME)
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = locale.keymap;

  # Remove unwanted packages from gnome
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-music
    gnome-photos
    gnome-tour
    totem
    yelp
    simple-scan
    cheese
    gnome-text-editor
    gnome-connections
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-user-docs
    gnome-clocks
    loupe
    snapshot
  ];

  # Remove documentation application from nixos
  documentation.nixos.enable = false;

  # Needed for steam flatpak
  hardware.steam-hardware.enable = true;

  # Enable printing
  services.printing.enable = true;

  # Enable lact
  services.lact.enable = true;

  # System packages
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    micro
    wl-clipboard
    git
    gnome-software
    lynis
    gawk
    fastfetch

    gnomeExtensions.dash-to-panel
    gnomeExtensions.tiling-shell
    gnomeExtensions.wallpaper-carousel
  ];
}
