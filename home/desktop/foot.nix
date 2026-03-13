# home/desktop/foot.nix
{ config, pkgs, ... }:

let
  theme = config.horizon.theme;
in {
  programs.foot = {
    enable = true;
    
    settings = {
      main = {
        shell = "nu";
        pad = "15x15";
        # Wir nutzen direkt die Font-Variable aus dem Schema
        font = "${theme.ui.font}:size=12";
      };
      
      colors-dark = {
        alpha = theme.ui.opacity;
        background = theme.colors.bg;
        foreground = theme.colors.fg;
        
        # Reguläre Farben (0-7)
        regular0 = theme.colors.term.black;
        regular1 = theme.colors.term.red;
        regular2 = theme.colors.term.green;
        regular3 = theme.colors.term.yellow;
        regular4 = theme.colors.term.blue;
        regular5 = theme.colors.term.magenta;
        regular6 = theme.colors.term.cyan;
        regular7 = theme.colors.term.white;

        # Helle/Bright Farben (8-15)
        # Für unser neutrales Fallback nutzen wir hier einfach die gleichen Farben.
        # In einem späteren Skin kannst du diese bei Bedarf durch hellere Varianten ersetzen.
        bright0 = theme.colors.term.black;
        bright1 = theme.colors.term.red;
        bright2 = theme.colors.term.green;
        bright3 = theme.colors.term.yellow;
        bright4 = theme.colors.term.blue;
        bright5 = theme.colors.term.magenta;
        bright6 = theme.colors.term.cyan;
        bright7 = theme.colors.term.white;
      };
    };
  };
}
