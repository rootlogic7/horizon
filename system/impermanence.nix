{ config, lib, ... }:

{
  fileSystems."/persist".neededForBoot = true;

  # Wir konfigurieren das Impermanence-Modul für das Root-Verzeichnis
  environment.persistence."/persist" = {
    # hideMounts sorgt dafür, dass Tools wie `df` oder `lsblk` nicht 
    # mit hunderten Bind-Mounts zugespammt werden. Das hält das System sauber.
    hideMounts = true;

    # Verzeichnisse, die den Neustart (den "Wind") überleben sollen
    directories = [
      "/var/log"                               # System-Logs (Journald) behalten
      "/var/lib/nixos"                         # Kritisch: Speichert UID/GID-Mappings der User
      "/var/lib/systemd/coredump"              # Nützlich fürs Debugging, falls mal was abstürzt
      "/etc/NetworkManager/system-connections" # Bekannte WLAN-Netzwerke & Passwörter
      "/var/lib/bluetooth"                     # Gekoppelte Bluetooth-Geräte (Maus, Kopfhörer)
    ];

    # Einzelne Dateien, die den Neustart überleben sollen
    files = [
      "/etc/machine-id"                        # Eindeutige ID für systemd (wichtig für Logs)
      # SSH Host Keys: Ohne diese würde der Laptop bei jedem Boot eine neue 
      # kryptografische Identität bekommen und andere Rechner würden Warnungen ausgeben!
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    # Persistente Daten für deinen Benutzer 'haku'
    users.haku = {
      directories = [
        "enso"
        ".ssh"
        ".config/sops"
      ];
    };  
  };

  # (Optional) Erlaube anderen Nutzern keinen Zugriff auf persistierte Systemdaten
  # Dies erhöht die Sicherheit, besonders bei LUKS-Verschlüsselung
  systemd.tmpfiles.rules = [
    "d /persist/var/lib 0755 root root -"
  ];
}
