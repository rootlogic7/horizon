# home/theme.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.theme;

  # Hilfsfunktionen, um Fuzzel und Mako Farb-Dateien zu generieren
  mkFuzzelColors = palette: ''
    [colors]
    background=${palette.bg}dd
    text=${palette.fg}ff
    match=${palette.accent_primary}ff
    selection=${palette.inactive_border}cc
    selection-text=${palette.accent_tertiary}ff
    selection-match=${palette.accent_secondary}ff
    border=${palette.accent_primary}ff
  '';

  mkMakoColors = palette: ''
    background-color=#${palette.bg}ee
    text-color=#${palette.fg}
    border-color=#${palette.accent_primary}
  '';

in {
  # 1. Wir definieren unsere Theme-Variablen (Die "Engine")
  options.horizon.theme = {
    enable = mkEnableOption "Enable Custom Horizon Theme Engine";
    
    ui = {
      font = mkOption { type = types.str; default = "DepartureMono Nerd Font Mono"; };
      font_propo = mkOption { type = types.str; default = "DepartureMono Nerd Font Propo"; };
      opacity = mkOption { type = types.str; default = "0.75"; };
      rounding = mkOption { type = types.int; default = 4; };
      border_size = mkOption { type = types.int; default = 2; };
      blur_size = mkOption { type = types.int; default = 8; };
    };

    palettes = {
      dark = {
        bg = mkOption { type = types.str; default = "050514"; };
        fg = mkOption { type = types.str; default = "e0d8ea"; };
        cursor = mkOption { type = types.str; default = "00e5ff"; };

        term_reg_0 = mkOption { type = types.str; default = "050514"; };
        term_reg_1 = mkOption { type = types.str; default = "ff0055"; };
        term_reg_2 = mkOption { type = types.str; default = "00ffcc"; };
        term_reg_3 = mkOption { type = types.str; default = "ff5500"; };
        term_reg_4 = mkOption { type = types.str; default = "00e5ff"; };
        term_reg_5 = mkOption { type = types.str; default = "b800ff"; };
        term_reg_6 = mkOption { type = types.str; default = "00ffff"; };
        term_reg_7 = mkOption { type = types.str; default = "e0d8ea"; };

        term_bri_0 = mkOption { type = types.str; default = "110b29"; };
        term_bri_1 = mkOption { type = types.str; default = "ff00aa"; };
        term_bri_2 = mkOption { type = types.str; default = "55ffdd"; };
        term_bri_3 = mkOption { type = types.str; default = "ff8800"; };
        term_bri_4 = mkOption { type = types.str; default = "66eeff"; };
        term_bri_5 = mkOption { type = types.str; default = "d166ff"; };
        term_bri_6 = mkOption { type = types.str; default = "66ffff"; };
        term_bri_7 = mkOption { type = types.str; default = "ffffff"; };
        
        accent_primary = mkOption { type = types.str; default = "ff00aa"; };
        accent_secondary = mkOption { type = types.str; default = "ff5500"; };
        accent_tertiary = mkOption { type = types.str; default = "00e5ff"; };
        inactive_border = mkOption { type = types.str; default = "110b29"; };
      };

      light = {
        bg = mkOption { type = types.str; default = "eff1f5"; };
        fg = mkOption { type = types.str; default = "4c4f69"; };
        cursor = mkOption { type = types.str; default = "1e66f5"; };

        term_reg_0 = mkOption { type = types.str; default = "bcc0cc"; };
        term_reg_1 = mkOption { type = types.str; default = "d20f39"; };
        term_reg_2 = mkOption { type = types.str; default = "40a02b"; };
        term_reg_3 = mkOption { type = types.str; default = "df8e1d"; };
        term_reg_4 = mkOption { type = types.str; default = "1e66f5"; };
        term_reg_5 = mkOption { type = types.str; default = "ea76cb"; };
        term_reg_6 = mkOption { type = types.str; default = "179299"; };
        term_reg_7 = mkOption { type = types.str; default = "4c4f69"; };

        term_bri_0 = mkOption { type = types.str; default = "acb0be"; };
        term_bri_1 = mkOption { type = types.str; default = "d20f39"; };
        term_bri_2 = mkOption { type = types.str; default = "40a02b"; };
        term_bri_3 = mkOption { type = types.str; default = "df8e1d"; };
        term_bri_4 = mkOption { type = types.str; default = "1e66f5"; };
        term_bri_5 = mkOption { type = types.str; default = "ea76cb"; };
        term_bri_6 = mkOption { type = types.str; default = "179299"; };
        term_bri_7 = mkOption { type = types.str; default = "4c4f69"; };
        
        accent_primary = mkOption { type = types.str; default = "ea76cb"; };
        accent_secondary = mkOption { type = types.str; default = "df8e1d"; };
        accent_tertiary = mkOption { type = types.str; default = "1e66f5"; };
        inactive_border = mkOption { type = types.str; default = "ccd0da"; };
      };
    };
  };

  # 2. Globale Tools direkt konfigurieren
  config = mkIf cfg.enable {
    
    # --- NEU: Wir schreiben die Farbdateien in den Store ---
    xdg.configFile."horizon/themes/dark/fuzzel.ini".text = mkFuzzelColors cfg.palettes.dark;
    xdg.configFile."horizon/themes/light/fuzzel.ini".text = mkFuzzelColors cfg.palettes.light;

    xdg.configFile."horizon/themes/dark/mako".text = mkMakoColors cfg.palettes.dark;
    xdg.configFile."horizon/themes/light/mako".text = mkMakoColors cfg.palettes.light;

    # Cursor
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    # Fuzzel (Launcher) 
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          # NEU: Der Include-Befehl bindet unsere dynamischen Farben ein
          include = "~/.config/horizon/themes/current/fuzzel.ini";
          font = "${cfg.ui.font}:size=12";
          terminal = "${pkgs.foot}/bin/foot";
          width = 45;
          lines = 8;
          line-height = 24;
          horizontal-pad = 20;
          vertical-pad = 20;
          inner-pad = 10;
        };
        # Der colors Block fällt hier weg, da er nun in der fuzzel.ini steht!
        border = {
          radius = cfg.ui.rounding;
          width = cfg.ui.border_size;
        };
      };
    };

    # Basis-Dienste
    programs.bat.enable = true;
    programs.zellij.enable = true;

    # Mako Notification Daemon
    services.mako = {
      enable = true;
      # Farben entfallen hier ebenfalls
      borderRadius = cfg.ui.rounding;
      borderSize = cfg.ui.border_size;
      # NEU: Einbinden der dynamischen Mako-Farbdatei
      extraConfig = ''
        include ~/.config/horizon/themes/current/mako
      '';
    };
  };
}
