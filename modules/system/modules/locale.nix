{ locale, ... }:

{
  time.timeZone = locale.timezone;

  i18n.defaultLocale = locale.language;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale.region;
    LC_IDENTIFICATION = locale.region;
    LC_MEASUREMENT = locale.region;
    LC_MONETARY = locale.region;
    LC_NAME = locale.region;
    LC_NUMERIC = locale.region;
    LC_PAPER = locale.region;
    LC_TELEPHONE = locale.region;
    LC_TIME = locale.region;
  };

  console.keyMap = locale.keymap;
}
