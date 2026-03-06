{ config, ... }:

{
  # 1. SOPS: Das WLAN-Passwort aus der secrets.yaml laden
  sops.secrets.wifi_psk = {};

  # 2. SOPS Template: Wir erstellen eine temporäre .env-Datei im RAM
  # Diese wird vom NetworkManager gelesen, um das $WIFI_PSK aufzulösen.
  sops.templates."networkmanager.env".content = ''
    WIFI_PSK=${config.sops.placeholder.wifi_psk}
  '';

  # 3. NetworkManager Konfiguration
  networking.networkmanager = {
    enable = true;
    
    # Hier übergeben wir den Pfad zu unserer sicheren, von SOPS generierten .env Datei
    ensureProfiles.environmentFiles = [ config.sops.templates."networkmanager.env".path ];
    
    # Hier definieren wir die WLAN-Profile deklarativ
    ensureProfiles.profiles = {
      "Home" = {
        connection = {
          id = "Home";
          type = "wifi";
          autoconnect = true; # Verbindet sich automatisch, wenn in Reichweite
        };
        wifi = {
          ssid = "FRITZBox-WG";
          mode = "infrastructure";
        };
        "wifi-security" = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PSK"; # Wird sicher durch die .env Datei ersetzt!
        };
        ipv4 = { method = "auto"; };
        ipv6 = { method = "auto"; };
      };
    };
  };

  # Firewall aktivieren
  networking.firewall.enable = true;
  # SSH-Port (22) öffnen
  networking.firewall.allowedTCPPorts = [ 22 ];

  # SSH-Server (OpenSSH) konfigurieren
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
