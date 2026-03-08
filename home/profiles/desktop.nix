# home/profiles/desktop.nix
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    firefox
  ];

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  # Wir überschreiben die CLI-Passwortabfrage aus dem Core-Profil mit der schicken GUI-Variante
  services.gpg-agent.pinentry.package = lib.mkForce pkgs.pinentry-rofi;

  imports = [
    ../desktop/default.nix
    ../theme.nix
  ];
}
