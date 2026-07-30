{ lib, ... }:
{
  "org/gnome/shell" = {
    enabled-extensions = [
      "dash-to-panel@jderose9.github.com"
      "tilingshell@ferrarodomenico.com"
    ];
  };
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
  "org/gnome/shell/extensions/tilingshell" = {
    edge-tiling-mode = "default";
    enable-autotiling = true;
    inner-gaps = lib.hm.gvariant.mkUint32 0;
    outer-gaps = lib.hm.gvariant.mkUint32 0;
  };
}
