{ config, pkgs, lib, osConfig, ... }:

let
  theme = config.horizon.theme;
  isNvidia = osConfig.horizon.hardware.nvidia.enable or false;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      # 1. Monitore (Bleibt dynamisch aus der System-Config)
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

      # 3. Variablen & Environment
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "fuzzel";

      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
      ] ++ lib.optionals isNvidia [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      # Wallpaper und komplexe Switcher sind hier vorerst entfernt.
      # Waybar wird ganz regulär gestartet.
      exec-once = [
        "statusbar-switcher"
        (if theme.ui.wallpaper != null 
         then "${pkgs.swaybg}/bin/swaybg -i ${theme.ui.wallpaper} -m fill"
         else "${pkgs.swaybg}/bin/swaybg -c '#${theme.colors.bg}'")
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "firefox --new-instance --profile ~/.mozilla/firefox/dashboard --name dashboard http://192.168.178.10:3002"
      ];

      workspace = [
        "1, gapsout:${toString theme.ui.homepage.gaps_out}"
      ];
      # 4. Design & Layout (Verknüpft mit der neuen Theme-Engine)
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = theme.ui.border_size;
        
        # Direkte Nutzung der Nix-Variablen statt statischer Config-Dateien!
        "col.active_border" = "rgb(${theme.colors.accent_primary}) rgb(${theme.colors.accent_secondary}) 45deg";
        "col.inactive_border" = "rgb(${theme.colors.inactive_border})";
        
        layout = "dwindle";
      };

      decoration = {
        rounding = theme.ui.rounding;
        
        blur = {
          # Blur wird nur eingeschaltet, wenn die UI-Settings einen Wert > 0 haben
          enabled = theme.ui.blur_size > 0;
          size = theme.ui.blur_size;
          passes = 2;
        };
        
        # Schatten komplett deaktivieren für eine saubere Basis

        shadow = {
          enabled = false;
        };
      };

      # 5. Standard-Animationen (Cyberpunk-Beziers entfernt)
      animations = {
        enabled = true;
        # Wenn wir hier nichts weiter definieren, nutzt Hyprland 
        # angenehme, neutrale Default-Animationen.
      };

      cursor = lib.mkIf isNvidia {
        no_hardware_cursors = true;
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vrr = 1;
      };

      # 6. Window- und Layer-Rules (Nur funktionale)
      layerrule = [
        "blur on, match:namespace waybar"
        "ignore_alpha 0, match:namespace waybar"
      ];

      windowrule = [
        "float on, match:class ^(fuzzel)$"
        "float on, match:title ^(Picture-in-Picture)$"

        "workspace 1 silent, match:class ^(dashboard)$"
        "opacity ${theme.ui.homepage.opacity} ${theme.ui.homepage.opacity}, match:class ^(dashboard)$"
        "border_size 0, match:class ^(dashboard)$"
      ];

      # 7. Binds (Funktional identisch, Theme-Switcher entfernt)
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
