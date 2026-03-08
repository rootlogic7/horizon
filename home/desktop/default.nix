# home/desktop/default.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./foot.nix
    ./waybar.nix
    ./hyprland.nix
  ];
}
