{ config, pkgs, ... }:

{
  imports = [
    ./core.nix
    ./display.nix
    ./impermanence.nix
    ./network.nix
    ./security.nix
    ./power.nix
  ];
}
