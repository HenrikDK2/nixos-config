{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      isDefault = true;
      id = 0;

      settings = {
        # Privacy
        "privacy.resistFingerprinting" = false;

        # History & Session
        "places.history.enabled" = true;
        "browser.privatebrowsing.autostart" = false;
        "browser.sessionstore.privacy_level" = 0;
        "browser.sessionstore.resume_from_crash" = true;

        # Cookies
        "network.cookie.lifetimePolicy" = 0;
        "network.cookie.cookieBehavior" = 0;

        # Clear on Shutdown
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.sanitize.pending" = "[]";

        # Firefox Account
        "identity.fxaccounts.enabled" = true;

        # Mouse
        "middlemouse.paste" = false;
        "general.autoScroll" = true;

        # UI
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.uiCustomization.state" =
          "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"vertical-spacer\",\"urlbar-container\",\"downloads-button\",\"reset-pbm-toolbar-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"reset-pbm-toolbar-button\",\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":24,\"newElementCount\":3}";
      };
    };
  };
}
