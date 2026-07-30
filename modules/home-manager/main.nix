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

      settings = {
        # Appearance
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };

        "org/gnome/Console" = {
          use-system-font = false;
          custom-font = "Monospace 14";
        };

        # Mouse
        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
        };

        # Extensions
        "org/gnome/shell" = {
          enabled-extensions = [
            "dash-to-panel@jderose9.github.com"
            "tilingshell@ferrarodomenico.com"
          ];
        };

        # Dash to Panel
        "org/gnome/shell/extensions/dash-to-panel" = {
          dot-position = "BOTTOM";
          extension-version = 73;
          hotkeys-overlay-combo = "TEMPORARILY";
          intellihide = false;

          panel-anchors = ''{"SAM-H1AK500000":"MIDDLE"}'';
          panel-element-positions = "{}";
          panel-lengths = ''{"SAM-H1AK500000":100}'';
          panel-positions = ''{"SAM-H1AK500000":"LEFT"}'';
          panel-sizes = ''{"SAM-H1AK500000":48}'';

          prefs-opened = false;
          window-preview-title-position = "TOP";
        };

        # Tiling Shell
        "org/gnome/shell/extensions/tilingshell" = {
          edge-tiling-mode = "default";
          enable-autotiling = true;

          inner-gaps = lib.hm.gvariant.mkUint32 0;
          outer-gaps = lib.hm.gvariant.mkUint32 0;
        };
      };
    };
  };
}
