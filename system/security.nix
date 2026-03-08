{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.security;
in {
  options.horizon.security = {
    enable = mkEnableOption "Enable Security Tools (Polkit, Gnome Keyring, Sudo)";
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.rtkit.enable = true;
    security.sudo = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
