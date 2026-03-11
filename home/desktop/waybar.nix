# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;

  # Hilfsfunktion, um Waybar CSS-Variablen zu generieren
  mkWaybarColors = palette: ''
    @define-color bg_alpha rgba(5, 5, 20, ${theme.ui.opacity});
    @define-color bg #${palette.bg};
    @define-color fg #${palette.fg};
    @define-color accent_primary #${palette.accent_primary};
    @define-color accent_secondary #${palette.accent_secondary};
    @define-color accent_tertiary #${palette.accent_tertiary};
    @define-color inactive #${palette.inactive_border};
    @define-color text_white #${palette.term_reg_7};
    @define-color status_green #${palette.term_reg_2};
    @define-color status_orange #${palette.term_reg_3};
    @define-color status_red #${palette.term_reg_1};
  '';

  # 1. GEMEINSAME MODULE
  modules = {
    "custom/nixos" = { format = ""; tooltip = false; };
    "hyprland/workspaces" = { format = "{icon}"; on-click = "activate"; format-icons = { active = ""; default = ""; }; };
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
  };

  # 2. TEMPLATES FÜR DIE LEISTEN (wie vorher)
  mkTopBar = output: { name = "topbar"; layer = "top"; position = "top"; height = 20; spacing = 4; inherit output; modules-left = [ "custom/nixos" "hyprland/workspaces" ]; modules-center = [ "hyprland/window" ]; modules-right = [ "idle_inhibitor" "tray" "clock" "custom/power" ]; } // modules;
  mkBottomBar = output: { name = "bottombar"; layer = "top"; position = "bottom"; height = 20; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ]; } // modules;
  mkTopBarQuasarMain = output: mkTopBar output;
  mkBottomBarQuasar = output: { name = "bottombar-quasar"; layer = "top"; position = "bottom"; height = 20; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "pulseaudio" ]; } // modules;
  mkTopBarQuasarSec = output: { name = "topbar-quasar-sec"; layer = "top"; position = "top"; height = 20; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "pulseaudio" ]; } // modules;

  # 3. DIE MODI GENERIEREN
  modeLaptop      = [ (mkTopBar "eDP-1") (mkBottomBar "eDP-1") ];
  modeDocking     = [ (mkTopBar "DP-6")  (mkBottomBar "eDP-1") ];
  modeDockingOnly = [ (mkTopBar "DP-6")  (mkBottomBar "DP-6")  ];
  modeQuasarSingle = [ (mkTopBar "DP-1") (mkBottomBarQuasar "DP-1") ];
  modeQuasarDual   = [ (mkTopBar "DP-1") (mkTopBarQuasarSec "HDMI-A-1") ];

  # 4. DAS INTELLIGENTE SWITCHER-SKRIPT
  barSwitcher = pkgs.writeShellScriptBin "statusbar-switcher" ''
    ${pkgs.procps}/bin/pkill waybar || true
    sleep 0.5
    
    # Hole Monitore und wandle sie in eine Liste um, die durch Leerzeichen getrennt ist.
    # WICHTIG: Wir setzen am Anfang und Ende auch ein Leerzeichen!
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name' || echo "")
    MONITORS_FLAT=" $(echo $MONITORS | tr '\n' ' ') "
    
    CONF_DIR="${config.home.homeDirectory}/.config/waybar"
    
    # Strikte Prüfung: " DP-1 " anstatt nur *"DP-1"*, weil sonst "eDP-1" fälschlicherweise triggert!
    if [[ "$MONITORS_FLAT" == *" DP-1 "* && "$MONITORS_FLAT" == *" HDMI-A-1 "* ]]; then
      CFG="$CONF_DIR/config-quasar-dual"
    elif [[ "$MONITORS_FLAT" == *" DP-1 "* ]]; then
      CFG="$CONF_DIR/config-quasar-single"
    elif [[ "$MONITORS_FLAT" == *" DP-6 "* && "$MONITORS_FLAT" == *" eDP-1 "* ]]; then
      CFG="$CONF_DIR/config-docking"
    elif [[ "$MONITORS_FLAT" == *" DP-6 "* ]]; then
      CFG="$CONF_DIR/config-docking-only"
    else
      # Wenn nichts anderes exakt passt, nimm den Standard-Laptop-Modus
      CFG="$CONF_DIR/config-laptop"
    fi

    # Waybar entkoppelt im Hintergrund starten (ohne Terminal-Spam)
    ${pkgs.waybar}/bin/waybar -c "$CFG" -s "$CONF_DIR/style.css" > /dev/null 2>&1 &
    disown
  '';

in {
  home.packages = [
    barSwitcher
    pkgs.jq
  ];

  # Schreibe die Farb-Definitionen als CSS in den Store
  xdg.configFile."horizon/themes/dark/waybar-colors.css".text = mkWaybarColors theme.palettes.dark;
  xdg.configFile."horizon/themes/light/waybar-colors.css".text = mkWaybarColors theme.palettes.light;

  xdg.configFile."waybar/config-laptop".text = builtins.toJSON modeLaptop;
  xdg.configFile."waybar/config-docking".text = builtins.toJSON modeDocking;
  xdg.configFile."waybar/config-docking-only".text = builtins.toJSON modeDockingOnly;
  xdg.configFile."waybar/config-quasar-single".text = builtins.toJSON modeQuasarSingle;
  xdg.configFile."waybar/config-quasar-dual".text = builtins.toJSON modeQuasarDual;

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = ''
      /* NEU: Importiere die dynamischen Farben */
      @import "${config.home.homeDirectory}/.config/horizon/themes/current/waybar-colors.css";

      * {
          border: none;
          border-radius: 0;
          font-family: "${theme.ui.font_propo}", monospace;
          font-size: 9px; 
          min-height: 0;
      }

      window#waybar {
          background-color: @bg_alpha;
          color: @fg;
      }

      window#waybar.topbar {
          border-bottom: ${toString theme.ui.border_size}px solid @accent_primary;
      }

      window#waybar.bottombar {
          border-top: ${toString theme.ui.border_size}px solid @accent_tertiary;
      }

      #workspaces button, #clock, #battery, #network, #pulseaudio, 
      #backlight, #memory, #cpu, #tray, #idle_inhibitor, #custom-power, #custom-nixos {
          padding: 1px 3px;
          margin: 1px 4px;
          color: @text_white;
      }

      #window {
          font-size: 11px;
          padding: 1px 3px;
          margin: 1px 4px;
          color: @accent_tertiary;
          font-weight: bold;
      }

      #workspaces button { color: @inactive; }
      #workspaces button.active { color: @accent_primary; font-weight: bold; }

      #battery.charging { color: @status_green; }
      #battery.warning:not(.charging) { color: @status_orange; }
      #battery.critical:not(.charging) { color: @status_red; animation: blink 2s linear infinite; }
      
      @keyframes blink { 50% { opacity: 0.3; } }
    '';
  };
}
