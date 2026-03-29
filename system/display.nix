{ config, lib, pkgs, ... }:

with lib;
let
  # Wir definieren einen kurzen Alias für unsere neue Option
  cfg = config.horizon.desktop;
in {
  # 1. Optionen definieren (Das "Interface" für die Hosts)
  options.horizon.desktop = {
    enable = mkEnableOption "Enable Desktop Environment (Hyprland, Greetd, Fonts)";
    monitors = mkOption {
      type = types.listOf types.str;
      default = [ ",preferred,auto,1" ]; # Fallback, falls mal nichts definiert ist
      description = "Liste der Monitor-Konfigurationen für Hyprland";
    };
  };

  # 2. Die eigentliche Konfiguration (wird nur angewendet, wenn enable = true)
  config = mkIf cfg.enable {
    # Hyprland systemweit aktivieren
    programs.hyprland.enable = true;

    # greetd mit tuigreet als Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
          user = "greeter";
        };
      };
    };

    # Schriftarten (Fonts)
    fonts.packages = with pkgs; [
      nerd-fonts.departure-mono
      noto-fonts-cjk-sans
    ];
  };
}
