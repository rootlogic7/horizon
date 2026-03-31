# home/theme.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.theme;
in {
  # 1. Das "Schema" für alle künftigen Skins
  options.horizon.theme = {
    enable = mkEnableOption "Enable Horizon Theme Engine";

    ui = {
      font = mkOption { type = types.str; default = "monospace"; description = "System Default Font"; };
      font_propo = mkOption { type = types.str; default = "sans-serif"; };
      opacity = mkOption { type = types.str; default = "1.0"; };
      rounding = mkOption { type = types.int; default = 0; };
      border_size = mkOption { type = types.int; default = 1; };
      blur_size = mkOption { type = types.int; default = 0; };

      nixvim_transparent = mkOption { 
        type = types.bool; 
        default = true; 
        description = "Macht den Neovim Hintergrund transparent (Nutzt Terminal-Hintergrund)"; 
      };

      fastfetch_logo = mkOption { 
        type = types.str; 
        default = "nixos"; 
      };

      fastfetch_color = mkOption { 
        type = types.str; 
        default = "magenta"; 
        description = "Die ANSI-Farbe (z.B. 'magenta', 'cyan', 'blue') für Fastfetch";
      };

      wallpaper = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Pfad zum Wallpaper-Bild für dieses Theme";
      };

      homepage = {
        gaps_out = mkOption { 
          type = types.int; 
          default = 8; 
          description = "Abstand (Gaps) speziell für Workspace 1 (Dashboard)"; 
        };
        opacity = mkOption { 
          type = types.str; 
          default = "1.0"; 
          description = "Transparenz des Homepage-Fensters (z.B. '0.85')";
        };
      };
    };

    colors = {
        # --- BASIS-FARBEN ---
      # Sehr dunkles, fast reines Schwarz für den Hintergrund und weiches Weiß für den Text.
      bg = mkOption { type = types.str; default = "0a0a0a"; }; 
      fg = mkOption { type = types.str; default = "e0e0e0"; }; 
      cursor = mkOption { type = types.str; default = "ffffff"; };
      
      # --- UI AKZENTE (Graustufen) ---
      # Alles in der UI (Rahmen, Waybar-Linien, Fuzzel-Auswahl) bleibt streng monochrom.
      # So sticht später jede Farbe, die du hinzufügst, sofort heraus.
      accent_primary = mkOption { type = types.str; default = "888888"; };   # Aktive Fensterrahmen (Mittelgrau)
      accent_secondary = mkOption { type = types.str; default = "aaaaaa"; }; # Highlights (Helleres Grau)
      accent_tertiary = mkOption { type = types.str; default = "555555"; };  # Subtile Akzente
      inactive_border = mkOption { type = types.str; default = "222222"; };  # Inaktive Fensterrahmen (Sehr dunkel)

      # --- TERMINAL FARBEN (Semantisch) ---
      # Im Terminal behalten wir nützliche Farben für ls, git, Warnungen und Fehler.
      term = {
        black   = mkOption { type = types.str; default = "1a1a1a"; }; # Hintergrund-Nuance
        
        # Die semantischen Ampel-Farben (kräftig und gut lesbar auf dunkel)
        red     = mkOption { type = types.str; default = "ff5555"; }; # Fehler / Löschungen
        yellow  = mkOption { type = types.str; default = "ffcc00"; }; # Warnungen / Änderungen
        green   = mkOption { type = types.str; default = "44cc44"; }; # Erfolg / Hinzugefügtes
        
        # Blaue/Lila Töne für Ordner, Symlinks und Code-Syntax
        blue    = mkOption { type = types.str; default = "4488ff"; }; 
        magenta = mkOption { type = types.str; default = "cc55ff"; }; 
        cyan    = mkOption { type = types.str; default = "00cccc"; }; 
        
        white   = mkOption { type = types.str; default = "eeeeee"; }; # Standard-Text im Terminal
      };
    };
  };

  # 2. Globale Basis-Dienste (ohne spezifisches Styling)
  # 2. Globale Basis-Dienste (Direkt an das neutrale Schema gekoppelt)
  config = mkIf cfg.enable {
    
    # Neutraler Fallback-Cursor
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    # Basis-Dienste (ohne UI)
    programs.bat.enable = true;
    programs.zellij.enable = true;

    # --- FUZZEL ---
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
        border = {
          radius = cfg.ui.rounding;
          width = cfg.ui.border_size;
        };
        # Farben direkt aus dem Schema laden (fuzzel erwartet RGBA Hex-Strings, 
        # wir hängen also z.B. 'ff' für volle Deckkraft oder 'dd' für Transparenz an)
        colors = {
          background = "${cfg.colors.bg}dd";
          text = "${cfg.colors.fg}ff";
          match = "${cfg.colors.accent_primary}ff";
          selection = "${cfg.colors.inactive_border}cc";
          selection-text = "${cfg.colors.accent_tertiary}ff";
          selection-match = "${cfg.colors.accent_secondary}ff";
          border = "${cfg.colors.accent_primary}ff";
        };
      };
    };

    # --- MAKO ---
    services.mako = {
      enable = true;
      settings = {
        # UI-Werte
        border-radius = cfg.ui.rounding;
        border-size = cfg.ui.border_size;
      
        # Farben direkt aus dem Schema laden (Mako erwartet klassische #Hex-Werte)
        background-color = "#${cfg.colors.bg}ee";
        text-color = "#${cfg.colors.fg}";
        border-color = "#${cfg.colors.accent_primary}";
      };
    };

    # --- ROFI (Dient als GUI für unsere GPG-Passwortabfrage) ---
    programs.rofi = {
      enable = true;
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background-color = mkLiteral "#${cfg.colors.bg}ff"; # ff = volle Deckkraft
          text-color = mkLiteral "#${cfg.colors.fg}";
        };
        "window" = {
          border = mkLiteral "${toString cfg.ui.border_size}px";
          border-radius = mkLiteral "${toString cfg.ui.rounding}px";
          border-color = mkLiteral "#${cfg.colors.accent_primary}";
          padding = mkLiteral "10px";
        };
        "entry" = {
          background-color = mkLiteral "#${cfg.colors.inactive_border}";
        };
      };
    };

    # --- GTK THEMING (Zwingt Desktop-Apps unseren Hintergrund auf) ---
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk4.theme = null;
    };

    # Wir überschreiben die Kern-Variablen von GTK3 und GTK4 mit unserem bg-Hexwert
    xdg.configFile."gtk-3.0/gtk.css".text = ''
      @define-color theme_bg_color #${cfg.colors.bg};
      @define-color theme_base_color #${cfg.colors.bg};
      @define-color window_bg_color #${cfg.colors.bg};
    '';
    
    xdg.configFile."gtk-4.0/gtk.css".text = ''
      @define-color theme_bg_color #${cfg.colors.bg};
      @define-color theme_base_color #${cfg.colors.bg};
      @define-color window_bg_color #${cfg.colors.bg};
    '';

    # --- FIREFOX THEMING ---
    programs.firefox = {
      profiles.haku = {
        # Zwingt Firefox dazu, unsere custom CSS-Dateien zu akzeptieren
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.theme.content-theme" = 0; # Sagt Webseiten: "Ich bin im Darkmode"
        };

        # userChrome stylt die Benutzeroberfläche (Tabs, URL-Leiste, Menüs)
        userChrome = ''
          :root {
            /* Überschreibt die Standard-Firefox-Farben mit unserem Hintergrund */
            --toolbar-bgcolor: #${cfg.colors.bg} !important;
            --lwt-accent-color: #${cfg.colors.bg} !important;
            --tab-selected-bgcolor: #${cfg.colors.bg} !important;
            --lwt-text-color: #${cfg.colors.fg} !important;
            --toolbar-color: #${cfg.colors.fg} !important;
          }
          #navigator-toolbox {
            background-color: #${cfg.colors.bg} !important;
            color: #${cfg.colors.fg} !important;
            border-bottom: none !important;
          }
        '';

        # userContent stylt die Webseiten selbst (hier: Neuer Tab und leere Lade-Seiten)
        userContent = ''
          @-moz-document url("about:blank"), url("about:newtab"), url("about:home") {
            body {
              background-color: #${cfg.colors.bg} !important;
              color: #${cfg.colors.fg} !important;
            }
          }
        '';
      };
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = cfg.ui.fastfetch_logo;
          padding = {
            top = 1;
            right = 2;
            left = 2;
          };
        };
        display = {
          separator = "   "; # Ein schicker Pfeil aus dem Nerd Font
          color = {
            keys = cfg.ui.fastfetch_color;  
            title = cfg.ui.fastfetch_color;
          };
        };
        # Hier definieren wir, was angezeigt werden soll (schön kompakt)
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "wm"
          "terminal"
          "memory"
          "break"
          "colors" # Zeigt am Ende deine hübsche neue Farbpalette!
        ];
      };
    };


  };
}
