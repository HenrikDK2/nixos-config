{ username, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "1234";
    shell = pkgs.fish;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # Home Manager
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.${username} = { lib, ... }: {
    home.stateVersion = "26.05";

    # Programs
    imports = [
      ./programs/zed-editor.nix
      ./programs/fish.nix
      ./programs/librewolf.nix
    ];

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg.desktopEntries.xterm = {
      name = "xterm";
      noDisplay = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "dev.zed.Zed.desktop" ];
      };
    };

    dconf = {
      enable = true;
      settings =
        (import ./dconf/appearance.nix { inherit lib; })
        // (import ./dconf/mouse.nix { inherit lib; })
        // (import ./dconf/keybindings.nix { inherit lib; })
        // (import ./dconf/extensions.nix { inherit lib; })
        // (import ./dconf/wm.nix { inherit lib; });
    };
  };
}
