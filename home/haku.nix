# home/haku.nix
{ config, lib, osConfig, ... }:

with lib;
{
  # Grundlegende Home-Manager-Einstellungen, die auf jedem System gleich sind
  home = {
    username = "haku";
    homeDirectory = "/home/haku";
    stateVersion = "25.11";
  };

  horizon.theme.enable = true;

  programs.home-manager.enable = true;

  # === SoC Magie ===
  # Core wird IMMER geladen.
  # Desktop wird NUR geladen, wenn der Host (z.B. nova) horizon.desktop.enable = true gesetzt hat!
  imports = [
    ./profiles/core.nix
  ] ++ optionals osConfig.horizon.desktop.enable [
    ./profiles/desktop.nix
  ];
}
