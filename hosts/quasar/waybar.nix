# hosts/quasar/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;
  globalModules = config.horizon.desktop.waybar.modules;

  quasarModules = lib.recursiveUpdate globalModules {
    # quasar only modules
  };

  mainTop = {
    name = "main-top";
    output = [ "DP-1" ];
    layer = "top";
    position = "top";
    height = 30;
    spacing = 6;
    modules-left = [ "hyprland/workspaces#system" "hyprland/workspaces#server" "hyprland/workspaces" ];
    modules-center = [ "custom/context" "hyprland/window" ];
    modules-right = [ "pulseaudio" "clock" "custom/power" ];
  } // quasarModules;

  mainBottom = {
    name = "main-bottom";
    output = [ "DP-1" ];
    layer = "top";
    position = "bottom";
    height = 30;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" ];
  } // quasarModules;

  secTop = {
    name = "sec-top";
    output = [ "HDMI-A-1" ];
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [ "hyprland/workspaces#system" "hyprland/workspaces#server" "hyprland/workspaces" ];
    modules-center = [ "custom/context" "hyprland/window" ];
    modules-right = [ "pulseaudio" "clock" "custom/power" ];
  } // quasarModules;

in {
  programs.waybar = {
    settings = [
      mainTop
      mainBottom
      secTop
    ];

    # Quasar-spezifisches Styling
    style = ''
      * { 
        border: none;
        font-family: "${theme.ui.font}"; 
        font-size: 14px; 
        min-height: 0; 
      }
      
      window#waybar { 
        background-color: #${theme.colors.bg}; 
        color: #${theme.colors.fg};
      }

      window#waybar.main-top, 
      window#waybar.sec-top { 
        border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_primary};
      }
      
      window#waybar.main-bottom { 
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
        background-color: transparent;
        box-shadow: none;
        text-shadow: none;
        border: none;
        border-radius: ${toString theme.ui.rounding}px; 
        transition: all 0.2s ease;

        /* ZUSTAND 1: LEER */
        color: #${theme.colors.inactive_border}; 
        font-size: 13px;
      }
      
      #workspaces button:hover {
        color: #${theme.colors.accent_secondary};
        background: transparent;
        background-color: transparent;
      }
      
      #workspaces button:not(.empty):not(.active) {
        color: #${theme.colors.accent_tertiary};
      }

      #workspaces button.active { 
        color: #${theme.colors.accent_primary};
        font-weight: bold;
      }

      /* --- SPECIAL WORKSPACES (System & Server) --- */
      #workspaces.system {
        padding-right: 0;
        margin-top: 4px;
        margin-bottom: 4px;
      }

      #workspaces.server {
        padding-left: 0;
        border-right: 1px solid #${theme.colors.accent_tertiary};
        margin-top: 4px;    
        margin-bottom: 4px;
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
        color: #${theme.colors.accent_primary}; 
      }

      /* --- USER/HOST CONTEXT PILLE --- */
      #custom-context {
        padding: 0 12px;
        margin-right: 8px;
        margin-top: 4px;    
        margin-bottom: 4px;
        border-radius: ${toString theme.ui.rounding}px;
        font-weight: bold;
        min-width: 140px;
      }

      /* Zustand 1: Lokal (Normaler Zustand) */
      #custom-context.local {
        background-color: transparent; 
        color: #${theme.colors.accent_tertiary};
        border: 1px solid #${theme.colors.accent_tertiary};
      }

      /* Zustand 2: SSH Verbindung (Alarm / Highlight!) */
      /* Sobald du auf einen Pi per SSH gehst, springt diese Pille ins Auge */
      #custom-context.ssh {
        background-color: #${theme.colors.accent_primary}; 
        color: #${theme.colors.bg}; /* Dunkler Text auf leuchtender Akzentfarbe */
        border: 1px solid #${theme.colors.accent_primary};
      }

      /* --- WINDOW TITLE (Mitte) --- */
      #window {
        min-width: 400px;
        padding: 0 12px;
        margin-top: 4px;    
        margin-bottom: 4px;
        background-color: #${theme.colors.accent_tertiary};
        color: #${theme.colors.bg};
        border-radius: ${toString theme.ui.rounding}px;
        font-weight: normal;
      }

      #window.empty {
        color: transparent;
        background-color: transparent;
      }
    '';
  };
}
