# hosts/nova/waybar.nix
{ config, pkgs, lib, ... }:

let
  # 1. Globale Theme- und Modul-Basis laden
  theme = config.horizon.theme;
  globalModules = config.horizon.desktop.waybar.modules;

  # 2. Nova-spezifische Modul-Anpassungen (Deep Merge)
  # Hier nutzen wir lib.recursiveUpdate statt dem einfachen // Operator.
  # So können wir z.B. dem Batterie-Modul neue Eigenschaften geben, 
  # ohne die globalen Icons oder Schwellenwerte zu überschreiben.
  novaModules = lib.recursiveUpdate globalModules {
    
    # Beispiel-Erweiterung: Detailliertere Akku-Anzeige für den Laptop
    "battery" = {
      format-alt = "{time} {icon}"; # Zeigt beim Klicken die verbleibende Zeit an
    };

    # Beispiel-Erweiterung: Backlight-Scroll-Speed anpassen
    "backlight" = {
      scroll-step = 5.0;
    };
    
    # Ein Modul, das NUR auf Nova existiert
    "custom/laptop_mode" = {
      format = "";
      tooltip-format = "Portable Mode Active";
    };
  };

  # 3. Definition der einzelnen Leisten (Bars)
  
  # 3.1 Portable Top (Laptop-Bildschirm, oben)
  portableTop = {
    name = "portable-top";
    output = [ "eDP-1" ];
    layer = "top";
    position = "top";
    height = 24;
    spacing = 6;
    modules-left = [ "hyprland/workspaces#system" "hyprland/workspaces#server" "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "custom/laptop_mode" "idle_inhibitor" "tray" "clock" "custom/power" ];
  } // novaModules;

  # 3.2 Portable Bottom (Laptop-Bildschirm, unten)
  portableBottom = {
    name = "portable-bottom";
    output = [ "eDP-1" ];
    layer = "top";
    position = "bottom";
    height = 24;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ];
  } // novaModules;

  # 3.3 Docked Top (Externer Monitor)
  dockedTop = {
    name = "docked-top";
    output = [ "DP-6" ]; 
    layer = "top";
    position = "top";
    height = 24;
    modules-left = [ "custom/nixos" "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "idle_inhibitor" "tray" "network" "cpu" "memory" "pulseaudio" "clock" ];
  } // novaModules;

in {
  programs.waybar = {
    # 4. Zusammenbau der Konfiguration
    # Das Array ist jetzt wunderbar übersichtlich!
    settings = [
      portableTop
      portableBottom
      dockedTop
    ];

    # 5. Styling
    style = ''
      * { 
        border: none;
        font-family: "${theme.ui.font}"; 
        font-size: 11px; 
        min-height: 0; 
      }
      
      window#waybar { 
        background-color: #${theme.colors.bg}; 
        color: #${theme.colors.fg};
      }
      
      /* Linien-Design für die Bars */
      window#waybar.portable-top, 
      window#waybar.docked-top { 
        border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_primary};
      }
      
      window#waybar.portable-bottom { 
        border-top: ${toString theme.ui.border_size}px solid #${theme.colors.accent_tertiary};
      }
      
      /* Workspaces */

      /* --- WORKSPACES GENERAL --- */
      #workspaces {
        padding: 0 4px;
      }
      
      #workspaces button { 
        padding: 0;
        min-width: 28px;

        background: transparent;
        box-shadow: none;
        text-shadow: none;
        border: none;
        border-radius: ${toString theme.ui.rounding}px; 
        transition: all 0.2s ease;

        /* ZUSTAND 1: LEER (Standard-Ansicht für persistente Workspaces) */
        color: #${theme.colors.accent_tertiary}; 
        font-size: 13px;
      }
      
      #workspaces button:hover {
        color: #${theme.colors.accent_secondary};
        background-color: #${theme.colors.inactive_border}; /* Dezenter Hintergrund-Highlight */
        box-shadow: none;
        text-shadow: none;
      }
      
      #workspaces button:not(.empty):not(.active) {
        color: #${theme.colors.fg}; /* Weiß/Hell, damit man sofort sieht: Hier läuft was */
      }

      /* Belegte, aber nicht aktive Workspaces
      #workspaces button:not(.empty) {
        color: #${theme.colors.inactive_border}; 
      }*/
      
      #workspaces button.active { 
        color: #${theme.colors.accent_primary};
        background-color: transparent;
        font-weight: bold;
        box-shadow: none;
      }

      /* --- SPECIAL WORKSPACES (System & Server) --- */
      /* Das '#special' am Ende erlaubt es uns, dieses Modul separat zu stylen */
      #workspaces.system {
        padding-right: 0; /* Rückt näher an das Server-Icon */
      }

      #workspaces.server {
        padding-left: 0;
        border-right: 1px solid #${theme.colors.inactive_border};
        margin-right: 8px; 
        padding-right: 8px;
      }

      #workspaces.system button,
      #workspaces.server button {
        color: #${theme.colors.inactive_border};
        font-size: 14px; 
        min-width: 28px;
      }
      
      #workspaces.system button.active,
      #workspaces.server button.active {
        color: #${theme.colors.fg}; 
      }
    '';
  };
}
