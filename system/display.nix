{ pkgs, ... }:

{
# Hyprland systemweit aktivieren
  programs.hyprland.enable = true;

  # greetd mit tuigreet als Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Startet tuigreet mit Uhrzeit (--time) und weist es an, Hyprland zu starten (--cmd)
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Schriftarten (Fonts)
  fonts.packages = with pkgs; [
    nerd-fonts.departure-mono
  ];
}
