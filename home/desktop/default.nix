{ config, pkgs, lib, ... }:

{
  imports = [
    ./foot.nix
    ./waybar.nix
    ./hyprland.nix
    ./wlogout.nix
  ];

  # Hier könnten in Zukunft Pakete stehen, die *nur* für Systeme
  # mit Desktop-Umgebung gedacht sind (und nicht für headless Server).
  # home.packages = with pkgs; [
  #   ...
  # ];
}
