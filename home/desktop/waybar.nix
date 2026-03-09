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
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background-color: transparent;
      }

      /* Die Kapseln (Gruppen) */
      .modules-left, .modules-center, .modules-right {
          background-color: rgba(5, 5, 20, ${theme.ui.opacity});
          border: 2px solid #${theme.colors.pink};
          border-radius: 18px;
          margin: 10px 15px 0px 15px;
          box-shadow: 0px 0px 18px rgba(255, 0, 170, 0.45);
          padding: 2px 4px;
      }

      tooltip {
          background: #${theme.colors.bg};
          border: 1px solid #${theme.colors.cyan};
          border-radius: ${toString theme.ui.rounding}px;
          box-shadow: 0px 0px 10px rgba(0, 229, 255, 0.4);
      }

      /* =========================================================
         FESTE BREITEN (Damit die Kapseln nie wackeln)
         ========================================================= */
      #custom-nixos, #custom-userhost, #cpu, #memory, #workspaces,
      #window, #network, #pulseaudio, #battery, #clock {
          padding: 0 7px;
          margin: 2px 4px;
          color: #${theme.colors.fg};
          text-shadow: 0px 0px 6px #${theme.colors.fg};
          font-weight: bold;
      }

      /* Spezifische Breiten pro Element */
      #custom-nixos {
          min-width: 15px;
          color: #${theme.colors.cyan};
          text-shadow: 0px 0px 8px #${theme.colors.cyan};
          font-size: 16px;
      }

      #custom-userhost {
          min-width: 100px;
          color: #${theme.colors.magenta};
          text-shadow: 0px 0px 8px #${theme.colors.magenta};
      }

      #cpu, #memory, #pulseaudio, #battery, #clock {
          min-width: 50px;
      }

      #network {
          min-width: 100px;
      }

      #workspaces {
          min-width: 120px;
      }

      #window {
          min-width: 300px;
          color: #${theme.colors.white};
          text-shadow: 0px 0px 8px #${theme.colors.white};
      }

      /* Workspaces Logik */
      #workspaces button {
          padding: 0 5px;
          color: #4a3b69;
          transition: all 0.3s ease;
      }

      #workspaces button.active {
          color: #${theme.colors.cyan};
          text-shadow: 0px 0px 10px #${theme.colors.cyan};
      }

      /* Batterie Farben */
      #battery.charging { 
          color: #${theme.colors.green};
          text-shadow: 0px 0px 8px #${theme.colors.green}; 
      }
      #battery.warning:not(.charging) { 
          color: #${theme.colors.orange};
          text-shadow: 0px 0px 8px #${theme.colors.orange}; 
      }
      #battery.critical:not(.charging) {
          color: #${theme.colors.red};
          text-shadow: 0px 0px 12px #${theme.colors.red};
          animation: blink 2s linear infinite;
      }

      @keyframes blink {
          50% { opacity: 0.3; }
      }
    '';
  };
}
