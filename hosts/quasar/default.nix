{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.11";

  imports = [ ./hardware-configuration.nix ];
  
  networking = {
    hostName = "quasar";
  };

  boot = {};
}
