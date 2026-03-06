{ pkgs, ... }:

{
  programs.foot = {
    enable = true;
    
    settings = {
      main = {
        # Hier weisen wir foot an, standardmäßig Nushell zu starten!
        shell = "nu";
        
        # Ein bisschen innerer Abstand (Padding) sieht mit Transparenz deutlich edler aus
        pad = "15x15";

        font = "DepartureMono Nerd Font Mono:size=12";
      };
      
      colors = {
        # Hier stellst du die Transparenz ein (0.85 ist ein super Sweetspot)
        alpha = 0.8;
      };
    };
  };
}
