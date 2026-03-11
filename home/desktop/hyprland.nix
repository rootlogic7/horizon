# home/desktop/hyprland.nix
{ config, pkgs, lib, osConfig, ... }:

let
  theme = config.horizon.theme;
  isNvidia = osConfig.horizon.hardware.nvidia.enable or false;

  # Hilfsfunktion, um die Hyprland-Farbvariablen zu generieren
  mkHyprlandColors = palette: ''
    $bg = rgb(${palette.bg})
    $accent_primary = rgb(${palette.accent_primary})
    $accent_secondary = rgb(${palette.accent_secondary})
    $accent_tertiary = rgb(${palette.accent_tertiary})
    $inactive_border = rgb(${palette.inactive_border})
    # Die Schattenfarbe braucht einen Alpha-Wert (44 in Hex = ca. 26% transparent)
    $shadow_color = rgba(${palette.accent_secondary}44)
  '';

in {
  # 1. Wir schreiben die Farbdateien in den XDG-Config Ordner
  xdg.configFile."horizon/themes/dark/hyprland-colors.conf".text = mkHyprlandColors theme.palettes.dark;
  xdg.configFile."horizon/themes/light/hyprland-colors.conf".text = mkHyprlandColors theme.palettes.light;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      
      # NEU: Lade die Farben dynamisch aus dem aktuellen Theme-Symlink
      source = "~/.config/horizon/themes/current/hyprland-colors.conf";

      # 1. Monitore
      monitor = osConfig.horizon.desktop.monitors;

      # 2. Tastatur & Touchpad
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
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
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      exec-once = [
        # NEU: swaybg nutzt jetzt immer das Wallpaper aus dem aktuellen Theme-Ordner!
        "${pkgs.swaybg}/bin/swaybg -i ~/.config/horizon/themes/current/wallpaper -m fill"
      ];

      # 4. Design & Layout
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = theme.ui.border_size;
        
        # Nutzen jetzt die dynamischen $ Variablen!
        "col.active_border" = "$accent_primary $accent_secondary $accent_tertiary 45deg";
        "col.inactive_border" = "$inactive_border";
        
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

        shadow = {
          enabled = true;
          range = 15;
          render_power = 2;
          color = "$shadow_color"; # Dynamische Schattenfarbe
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "neon, 0.05, 0.9, 0.1, 1.05"
          "smooth, 0.25, 1, 0.5, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];
        animation = [
          "windows, 1, 5, neon, slide"
          "windowsOut, 1, 4, smooth, slide"
          "border, 1, 10, default"
          "borderangle, 1, 50, linear, loop"
          "fade, 1, 5, smooth"
          "workspaces, 1, 6, default"
        ];
      };

      cursor = lib.mkIf isNvidia {
        no_hardware_cursors = true;
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vrr = 1;
      };

      # 6. Window- und Layer-Rules
      layerrule = [
        "blur on, match:namespace waybar"
        "ignore_alpha 0, match:namespace waybar"
      ];

      windowrule = [
        "float on, match:class ^(fuzzel)$"
        "float on, match:title ^(Picture-in-Picture)$"
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

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 1366x768@60, 0x0, 1\""
      ];
    };
  };
}
