{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.theme;
in {
  # 1. Wir definieren unsere Theme-Variablen (Die "Engine")
  options.horizon.theme = {
    enable = mkEnableOption "Enable Custom Horizon Theme Engine";

    colors = {
      # Hex-Werte ohne '#' für einfache Nutzung in Configs
      bg = mkOption { type = types.str; default = "0a0512"; description = "Deep Dark Purple/Black"; };
      fg = mkOption { type = types.str; default = "e0d8ea"; description = "Off-White / Foreground"; };
      accent = mkOption { type = types.str; default = "ff6600"; description = "Neon Orange"; };
      accent_sec = mkOption { type = types.str; default = "ff0055"; description = "Neon Pink (für Gradienten)"; };
      inactive = mkOption { type = types.str; default = "1a1025"; description = "Dark Purple for inactive elements"; };
    };

    ui = {
      font = mkOption { type = types.str; default = "DepartureMono Nerd Font Mono"; };
      opacity = mkOption { type = types.str; default = "0.75"; };
      rounding = mkOption { type = types.int; default = 4; };
      border_size = mkOption { type = types.int; default = 2; };
      blur_size = mkOption { type = types.int; default = 8; };
    };
  };

  # 2. Globale Tools direkt mit diesen Werten konfigurieren
  config = mkIf cfg.enable {
    
    # Cursor
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    # Fuzzel (Launcher) mit Theme-Variablen
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${cfg.ui.font}:size=12";
          terminal = "${pkgs.foot}/bin/foot";
          width = 45;
          lines = 8;
          line-height = 24;
          horizontal-pad = 20;
          vertical-pad = 20;
          inner-pad = 10;
        };
        colors = {
          # Hex-Werte + Alpha-Kanal (z.B. 'dd' für leichte Transparenz)
          background = "${cfg.colors.bg}dd";
          text = "${cfg.colors.fg}ff";
          match = "${cfg.colors.accent}ff";
          selection = "${cfg.colors.inactive}cc";
          selection-text = "${cfg.colors.accent}ff";
          selection-match = "${cfg.colors.accent_sec}ff";
          border = "${cfg.colors.accent}ff";
        };
        border = {
          radius = cfg.ui.rounding;
          width = cfg.ui.border_size;
        };
      };
    };

    # Basis-Dienste
    programs.bat.enable = true;
    programs.zellij.enable = true;
    services.mako = {
      settings = {
        enable = true;
        backgroundColor = "#${cfg.colors.bg}ee";
        textColor = "#${cfg.colors.fg}";
        borderColor = "#${cfg.colors.accent}";
        borderRadius = cfg.ui.rounding;
        borderSize = cfg.ui.border_size;
      };
    };
  };
}
