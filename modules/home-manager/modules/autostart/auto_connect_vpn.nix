{ config, pkgs, ... }:

let
  autoConnectVpn = pkgs.writeShellScript "auto-connect-vpn" ''
    PRIMARY_CONN=$(${pkgs.networkmanager}/bin/nmcli -t -f NAME,AUTOCONNECT connection show \
      | ${pkgs.gnugrep}/bin/grep -v "lo" \
      | ${pkgs.gnugrep}/bin/grep ":yes" \
      | ${pkgs.coreutils}/bin/head -n 1 \
      | ${pkgs.coreutils}/bin/cut -d: -f1)

    if [ -n "$PRIMARY_CONN" ]; then
      ${pkgs.networkmanager}/bin/nmcli connection up "$PRIMARY_CONN" 2>/dev/null

      for i in {1..10}; do
        if ${pkgs.networkmanager}/bin/nmcli -t -f NAME,STATE connection show --active \
          | ${pkgs.gnugrep}/bin/grep -q "^''${PRIMARY_CONN}:activated$"; then
          echo "Connected to $PRIMARY_CONN (''${i}s)"
          break
        fi
        sleep 1
      done

      SECONDARY_UUID=$(${pkgs.networkmanager}/bin/nmcli -t -f connection.secondaries connection show "$PRIMARY_CONN" \
        | ${pkgs.coreutils}/bin/cut -d: -f2)

      if [ -n "$SECONDARY_UUID" ]; then
        sleep 2
        ${pkgs.networkmanager}/bin/nmcli connection up uuid "$SECONDARY_UUID"

        for i in {1..10}; do
          if ${pkgs.networkmanager}/bin/nmcli connection show --active \
            | ${pkgs.gnugrep}/bin/grep -q "$SECONDARY_UUID"; then
            break
          fi
          sleep 1
        done
      fi
    fi
  '';
in
{
  xdg.configFile."autostart/auto-connect-vpn.desktop".text = ''
    [Desktop Entry]
    Hidden=false
    Name=Auto connect to VPN
    Comment=Makes sure that the VPN selected as auto connect is connected on login
    Terminal=false
    Exec=${autoConnectVpn}
    Type=Application
  '';
}
