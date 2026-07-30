{ config, pkgs, ... }:

{
  xdg.autostart.enable = true;

  xdg.configFile."autostart/auto-connect-vpn.desktop".text = ''
    [Desktop Entry]
    Hidden=false
    Name=Auto connect to VPN
    Comment=Makes sure that VPN selected as auto connect is actually connected to on login
    Terminal=false
    Exec=/home/henrik/nixos/autostart/auto_connect_vpn.sh
    Type=Application
  '';
}
