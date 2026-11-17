{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.locale;

  lcCategories = [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ];
in {
  options.modules.system.locale = {
    enable = lib.mkEnableOption "Locale and time zone settings";

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Rome";
      description = "System time zone (see timedatectl list-timezones).";
    };

    language = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      example = "it_IT.UTF-8";
      description = "Default locale: UI language and messages (i18n.defaultLocale).";
    };

    formats = lib.mkOption {
      type = lib.types.str;
      default = "es_VE.UTF-8";
      example = "it_IT.UTF-8";
      description = "Locale used for the LC_* categories (dates, numbers, currency, paper, ...).";
    };

    formatOverrides = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {LC_PAPER = "it_IT.UTF-8";};
      description = "Per-category overrides applied on top of `formats`.";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.language;

    i18n.extraLocaleSettings =
      lib.genAttrs lcCategories (_: cfg.formats)
      // cfg.formatOverrides;
  };
}
