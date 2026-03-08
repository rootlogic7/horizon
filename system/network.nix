{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.network;
in {
  options.horizon.network = {
    enable = mkEnableOption "Enable NetworkManager, WiFi-Secrets and SSH";
  };

  config = mkIf cfg.enable {
    sops.secrets.wifi_psk = {};
    sops.templates."networkmanager.env".content = ''
      WIFI_PSK=${config.sops.placeholder.wifi_psk}
    '';

    networking.networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ config.sops.templates."networkmanager.env".path ];
      ensureProfiles.profiles = {
        "Home" = {
          connection = {
            id = "Home";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "FRITZBox-WG";
            mode = "infrastructure";
          };
          "wifi-security" = {
            key-mgmt = "wpa-psk";
            psk = "$WIFI_PSK";
          };
          ipv4 = { method = "auto"; };
          ipv6 = { method = "auto"; };
        };
      };
    };

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };
}
