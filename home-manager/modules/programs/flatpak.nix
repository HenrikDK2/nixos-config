{ config, pkgs, ... }:

let
  flatpaks = [
    "com.valvesoftware.Steam"
    "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "com.mastermindzh.tidal-hifi"
    "com.discordapp.Discord"
    "org.qbittorrent.qBittorrent"
  ];

  installScript = pkgs.writeShellScript "install-flatpaks" ''
    set -euo pipefail

    FLATPAK=${pkgs.flatpak}/bin/flatpak

    if ! $FLATPAK remotes --user | grep -q '^flathub'; then
      $FLATPAK remote-add --user --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo
    fi

    latest_branch() {
      local app="$1"

      $FLATPAK remote-ls --user --runtime \
        --columns=ref,branch flathub 2>/dev/null \
        | awk -v id="$app" '
            $1 == "runtime/"id"/x86_64/"$2 {print $2}
          ' \
        | sort -V \
        | tail -n1
    }

    install_latest() {
      local app="$1"

      if $FLATPAK info --user "$app" >/dev/null 2>&1; then
        echo "$app already installed"
        return
      fi

      local branch=$(latest_branch "$app")

      if [ -n "$branch" ]; then
        echo "Installing latest runtime $app//$branch..."
        $FLATPAK install --noninteractive --user -y \
          flathub "$app//$branch"
      else
        echo "Installing $app..."
        $FLATPAK install --noninteractive --user -y \
          flathub "$app"
      fi
    }

    ${builtins.concatStringsSep "\n" (map (app: ''
      install_latest "${app}"
    '') flatpaks)}

    echo "Updating Flatpaks..."
    $FLATPAK update --user -y
  '';
in
{
  # Install Flatpak through Home Manager
  home.packages = with pkgs; [
    flatpak
  ];

  # Flatpak
  home.activation.flatpakInstall =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ${installScript}
    '';

  # Hacky way to get a mutable config file for qBittorrent
  home.activation.qbittorrentDefaults =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      QB_DIR="$HOME/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent"
      mkdir -p "$QB_DIR"
      if [ ! -e "$QB_DIR/blue.qbtheme" ]; then
        $DRY_RUN_CMD cp --no-preserve=mode ${../dotfiles/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent/qBittorrent.conf} "$QB_DIR/qBittorrent.conf"
        $DRY_RUN_CMD cp --no-preserve=mode ${../dotfiles/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent/blue.qbtheme} "$QB_DIR/blue.qbtheme"
        $DRY_RUN_CMD ${pkgs.gnused}/bin/sed -i "s#/home/[^/]*#$HOME#g" "$QB_DIR/qBittorrent.conf"
      fi
    '';
}
