# home/desktop/hyprland.nix
{ config, pkgs, lib, osConfig, ... }:

let
  theme = config.horizon.theme;
  isNvidia = osConfig.horizon.hardware.nvidia.enable or false;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      
      # 1. Monitore
      monitor = osConfig.horizon.desktop.monitors;

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
      ] ++ lib.optionals isNvidia [
        # Hyprland-spezifische Envs für Nvidia
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      exec-once = [
        "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.jpg} -m fill"
        #        "statusbar-listener"
      ];

      # 4. Design & Layout
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = theme.ui.border_size;
        
        # Ein 3-Farb-Gradient: Pink -> Orange -> Cyan
        "col.active_border" = "rgb(${theme.colors.pink}) rgb(${theme.colors.orange}) rgb(${theme.colors.cyan}) 45deg";
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
          color = "rgba(${theme.colors.orange}44)";
        };
      };
      
      animations = {
        enabled = true;
        bezier = [
          "neon, 0.05, 0.9, 0.1, 1.05"
          "smooth, 0.25, 1, 0.5, 1"
          "linear, 0.0, 0.0, 1.0, 1.0" # NEU: Für die Endlos-Rotation
        ];
        animation = [
          "windows, 1, 5, neon, slide"
          "windowsOut, 1, 4, smooth, slide"
          "border, 1, 10, default"
          "borderangle, 1, 50, linear, loop" # NEU: Die Farben im Rahmen drehen sich endlos!
          "fade, 1, 5, smooth"
          "workspaces, 1, 6, default"
        ];
      };

      # Hardware-Cursor-Fix für Nvidia
      cursor = lib.mkIf isNvidia {
        no_hardware_cursors = true;
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
        "$mod SHIFT, W, exec, statusbar-switcher"

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

      bindl = [
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 1366x768@60, 0x0, 1\""
      ];
    };
  };
}
