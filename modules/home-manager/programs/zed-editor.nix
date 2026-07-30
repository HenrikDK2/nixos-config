{
  programs.zed-editor = {
    enable = true;

    userSettings = {
      ui_font_size = 20;
      buffer_font_size = 20;

      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
    };
  };
}
