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

  # Enable flatpak
  services.flatpak.enable = true;
  hardware.steam-hardware.enable = true; # Needed for steam flatpak
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];

    script = ''
      flatpak remote-add --if-not-exists \
        flathub \
        https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

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
    flatpak
    lynis
    gawk
    ignition
    fastfetch

    gnomeExtensions.dash-to-panel
    gnomeExtensions.tiling-shell
    gnomeExtensions.wallpaper-carousel
  ];
}
