{ config, pkgs, lib, ... }:

{
  xdg.configFile."waybar/config".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = lib.mkForce ./waybar/style.css;

  wayland.windowManager.hyprland = {
    enable = true;
    
    # hyprland.conf
    settings = {
      
      # 1. Monitore
      monitor = "eDP-1,preferred,auto,1";

      # 2. Tastatur
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = 1;
      };

      # 3. Variablen
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "fuzzel";

      exec-once = [
        "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.jpg} -m fill"
        "waybar"
      ];

      # 🎨 NEU: Das visuelle Ricing (Hier greifen die Catppuccin-Farben!)
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        
        # Hier nutzen wir das Catppuccin $mauve (Lila) und mischen es mit $sapphire
        "col.active_border" = "$mauve $sapphire 45deg"; 
        "col.inactive_border" = "$surface0"; # Ein dunkles Grau für inaktive Fenster
        
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      misc = {
        # Deaktiviert das Standard-Hyprland-Maskottchen
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };

      # 4. Tastenkürzel (Binds)
      bind = [
        # Programme starten
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        
        # Fenster-Management
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod SHIFT, Space, togglefloating,"
        
        # Hyprland beenden (Ausloggen)
        "$mod SHIFT, E, exit,"

        # Fokus wechseln (mit den Pfeiltasten)
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

	# Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
      ];
    };
  };
}
