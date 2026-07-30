let
  username = "henrik";

  locale = {
    timezone = "Europe/Copenhagen";
    language = "en_DK.UTF-8";
    region =   "da_DK.UTF-8";
    keymap =   "dk";
  };
in
{
  imports = [
    # Auto-generated hardware configuration (disks, filesystems, CPU, etc.)
    /etc/nixos/hardware-configuration.nix

    # System-wide packages, services and utilities
    ./modules/system/main.nix

    # Home Manager user configuration
    ./modules/home-manager/main.nix
  ];

  _module.args = {
    inherit username locale;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
