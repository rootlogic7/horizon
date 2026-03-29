# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

{
  # Wir erstellen eine eigene Option, um die Module DRY an die Hosts weiterzugeben
  options.horizon.desktop.waybar.modules = lib.mkOption {
    type = lib.types.attrs;
    description = "Zentrale Definition aller Waybar-Module für Horizon";
    default = {
      "custom/nixos" = { format = ""; tooltip = false; };
      #"hyprland/workspaces" = { format = "{icon}"; on-click = "activate"; format-icons = { active = ""; default = ""; }; };
      "hyprland/window" = { format = "{title}"; max-length = 50; };
      "clock" = { format = " {:%H:%M}"; tooltip-format = "<tt>{calendar}</tt>"; };
      "idle_inhibitor" = { format = "{icon}"; format-icons = { activated = ""; deactivated = ""; }; };
      "tray" = { icon-size = 14; spacing = 6; };
      "custom/power" = { format = "⏻"; on-click = "wlogout"; };
      "network" = { format-wifi = " {essid}"; format-ethernet = "󰈀 LAN"; format-disconnected = "⚠ Offline"; };
      "cpu" = { format = " {usage}%"; };
      "memory" = { format = " {percentage}%"; };
      "backlight" = { format = "{icon} {percent}%"; format-icons = ["󰃞" "󰃟" "󰃠"]; };
      "pulseaudio" = { format = "{icon} {volume}%"; format-muted = " Muted"; format-icons = { headphone = ""; default = ["" ""]; }; };
      "battery" = { states = { warning = 30; critical = 15; }; format = "{icon} {capacity}%"; format-charging = " {capacity}%"; format-icons = ["" "" "" "" ""]; };
      # --- 1. Die Special Workspaces (Statisch) ---
      # --- 1a. Special Workspace: System ---
      "hyprland/workspaces#system" = { 
        format = "{icon}"; 
        on-click = "activate"; 
        persistent-workspaces = {
          "System" = [];
        };
        # Ignoriert Server und alle Zahlen-Workspaces
        ignore-workspaces = [ "Server" "^[0-9]+$" ]; 
        format-icons = { 
          "System" = ""; 
        }; 
      };

      # --- 1b. Special Workspace: Server ---
      "hyprland/workspaces#server" = { 
        format = "{icon}"; 
        on-click = "activate"; 
        persistent-workspaces = {
          "Server" = [];
        };
        # Ignoriert System und alle Zahlen-Workspaces
        ignore-workspaces = [ "System" "^[0-9]+$" ]; 
        format-icons = { 
          "Server" = "󰒋"; 
        }; 
      };
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
        ignore-workspaces = [ "System" "Server" ];
        format-icons = { 
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          # Ein Fallback, falls dynamisch Workspace 6+ geöffnet wird
          "default" = "〇";
        };
      };
    };
  };

  config = {
    programs.waybar = {
      enable = true;
      # Überlässt Systemd das Starten/Stoppen von Waybar passend zu Hyprland
      systemd.enable = true; 
    };
  };
}
