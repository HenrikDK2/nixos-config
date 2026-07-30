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

    imports = [
      # Programs
      ./modules/programs/zed-editor.nix
      ./modules/programs/fish.nix
      ./modules/programs/librewolf.nix

      # Autostart scripts
      ./modules/autostart/auto_connect_vpn.nix
    ];

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg.autostart.enable = true;
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
        (import ./modules/dconf/appearance.nix { inherit lib; })
        // (import ./modules/dconf/mouse.nix { inherit lib; })
        // (import ./modules/dconf/keybindings.nix { inherit lib; })
        // (import ./modules/dconf/extensions.nix {
          inherit username;
          inherit lib;
        })
        // (import ./modules/dconf/wm.nix { inherit lib; });
    };
  };
}
