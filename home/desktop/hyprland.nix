# home/desktop/hyprland.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      
      # 1. Monitore
      monitor = "eDP-1,preferred,auto,1";

      # 2. Tastatur & Touchpad (Laptop-Optimierungen)
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true; # Fühlt sich auf Laptops deutlich besser an
        };
      };

      # 3. Variablen
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "fuzzel";

      env = [
        "XCURSOR_THEME,phinger-cursors-light"
        "XCURSOR_SIZE,24"
      ];

      exec-once = [
        "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.png} -m fill"
        "waybar"
      ];

      # 4. Design & Layout
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = theme.ui.border_size;
        
        "col.active_border" = "rgb(${theme.colors.accent}) rgb(${theme.colors.accent_sec}) 45deg";
        "col.inactive_border" = "rgb(${theme.colors.inactive})";
        
        layout = "dwindle";
      };

      decoration = {
        rounding = theme.ui.rounding;
        
        blur = {
          enabled = true;
          size = theme.ui.blur_size;
          passes = 3;
          ignore_opacity = true;
          new_optimizations = true;
        };

        # NEU: Die korrekte moderne Hyprland-Syntax für Schatten
        shadow = {
          enabled = true;
          range = 15;
          render_power = 2;
          color = "rgba(${theme.colors.accent}44)";
        };
      };

      # 5. Animationen (Snappy "Neon" Feeling)
      animations = {
        enabled = true;
        bezier = [
          "neon, 0.05, 0.9, 0.1, 1.05"
          "smooth, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 5, neon, slide"
          "windowsOut, 1, 4, smooth, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 5, smooth"
          "workspaces, 1, 6, default"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vrr = 1; # Variable Refresh Rate - hilft auf dem Laptop massiv beim Akkusparen!
      };

      # 6. Window- und Layer-Rules
      layerrule = [
        "blur on, match:namespace waybar"        # Macht den Hintergrund der Waybar unscharf
        "ignore_alpha 0, match:namespace waybar" # 'ignorezero' heißt jetzt 'ignore_alpha 0'
      ];
      windowrule = [
        "float on, match:class ^(fuzzel)$"
        "float on, match:title ^(Picture-in-Picture)$" # Wichtig für YouTube-Minifenster
      ];

      # 7. Binds
      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod SHIFT, Space, togglefloating,"
        "$mod SHIFT, E, exit,"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
      ];

      # NEU: Maus-Binds (Erlaubt dir, Fenster mit Super + Mausklick zu verschieben/skalieren)
      bindm = [
        "$mod, mouse:272, movewindow"   # Linke Maustaste
        "$mod, mouse:273, resizewindow" # Rechte Maustaste
      ];
    };
  };
}
