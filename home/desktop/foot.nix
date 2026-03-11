{ config, pkgs, ... }:

let
  theme = config.horizon.theme;
  
  # Hilfsfunktion, um eine [colors] Sektion für Foot zu generieren
  mkFootColors = palette: ''
    [colors]
    alpha=${theme.ui.opacity}
    background=${palette.bg}
    foreground=${palette.fg}
    
    regular0=${palette.term_reg_0}
    regular1=${palette.term_reg_1}
    regular2=${palette.term_reg_2}
    regular3=${palette.term_reg_3}
    regular4=${palette.term_reg_4}
    regular5=${palette.term_reg_5}
    regular6=${palette.term_reg_6}
    regular7=${palette.term_reg_7}

    bright0=${palette.term_bri_0}
    bright1=${palette.term_bri_1}
    bright2=${palette.term_bri_2}
    bright3=${palette.term_bri_3}
    bright4=${palette.term_bri_4}
    bright5=${palette.term_bri_5}
    bright6=${palette.term_bri_6}
    bright7=${palette.term_bri_7}
  '';
in {
  # Wir schreiben die generierten Strings in echte Konfigurationsdateien im XDG Config Ordner
  xdg.configFile."horizon/themes/dark/foot.ini".text = mkFootColors theme.palettes.dark;
  xdg.configFile."horizon/themes/light/foot.ini".text = mkFootColors theme.palettes.light;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "nu";
        pad = "15x15";
        font = "${theme.ui.font}:size=12";
        # Hier binden wir den Symlink ein, der später vom Skript geändert wird!
        include = "~/.config/horizon/themes/current/foot.ini";
      };
    };
  };
}
