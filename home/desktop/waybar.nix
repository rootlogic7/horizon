# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;
in {
  # Die JSONC-Config laden wir weiterhin aus deiner Datei, das ist übersichtlicher
  xdg.configFile."waybar/config".source = ./waybar/config.jsonc;

  programs.waybar = {
    enable = true;
    
    # Home-Manager baut uns die style.css automatisch aus diesem String!
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "${theme.ui.font}", monospace;
          font-size: 12px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(10, 5, 18, ${theme.ui.opacity});
          color: #${theme.colors.fg};
          border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent};
      }

      tooltip {
          background: #${theme.colors.bg};
          border: 1px solid #${theme.colors.accent};
          border-radius: ${toString theme.ui.rounding}px;
      }

      #workspaces button {
          padding: 0 8px;
          color: #${theme.colors.inactive};
      }

      #workspaces button.active {
          color: #${theme.colors.accent};
          font-weight: bold;
          text-shadow: 0px 0px 8px #${theme.colors.accent};
      }

      #clock, #battery, #network, #pulseaudio, #tray {
          padding: 0 12px;
          margin: 4px 4px;
          border-radius: ${toString theme.ui.rounding}px;
          background-color: #${theme.colors.inactive};
          color: #${theme.colors.fg};
      }

      #battery.charging { color: #${theme.colors.accent_sec}; }
      #battery.warning:not(.charging) { color: #ff0000; }
    '';
  };
}
