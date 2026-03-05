{ config, pkgs, ... }:

{
  # Die zentrale Kontrollstation für dein gesamtes System-Ricing
  catppuccin = {
    enable = true;       # Themt automatisch ALLE unterstützten Programme
    flavor = "mocha";    
    accent = "mauve";    
  };

  # ICHTIG: Hier aktivieren wir die Programme "richtig" über Home-Manager.
  # Dadurch werden ihre Konfigurationsdateien generiert und Catppuccin kann seine Magie wirken.
  programs = {
    # Foot Terminal mit Transparenz ausstatten
    foot = {
      enable = true;
      settings = {
        main = {
          # Ein bisschen innerer Abstand (Padding) sieht mit Transparenz deutlich edler aus
          pad = "15x15"; 
        };
        colors = {
          # Hier stellst du die Transparenz ein (0.0 ist unsichtbar, 1.0 ist komplett deckend)
          # 0.85 ist ein super Sweetspot für Lesbarkeit und Ästhetik
          alpha = 0.85; 
        };
      };
    };
    #waybar.enable = true;
    #fuzzel.enable = true;
    #bat.enable = true;
    #zellij.enable = true;
    waybar.enable = true;
    fuzzel.enable = true;
    bat.enable = true;
    zellij.enable = true;
  };

  services = {
    mako.enable = true;
  };

  # GTK-Theming für Wayland-Fenster (Dateimanager etc.)
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
    };
  };
}
