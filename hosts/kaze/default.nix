{ config, pkgs, lib, ... }:

{
  # Importiere zukünftig die von NixOS generierte Hardware-Config (kommt später vom USB-Stick)
  # imports = [ ./hardware-configuration.nix ];

  # Hostname für den Laptop (Kaze = Wind)
  networking.hostName = "kaze";

  # 🚀 Bootloader Konfiguration (systemd-boot)
  boot.loader.systemd-boot.enable = true;
  # Wir behalten nur die letzten 10 Generationen im Bootmenü, um die 1GB EFI-Partition sauber zu halten
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Plymouth für einen schönen Boot-Splash (Theme fügen wir später hinzu)
  boot.plymouth.enable = true;

  # 🧹 "Erase your Darlings" - Die Magie passiert hier!
  # Dieses Skript läuft VOR dem eigentlichen Systemstart.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    # Wir mounten das Btrfs-Top-Level-Volume (wo alle Subvolumes liegen)
    mount /dev/mapper/cryptroot /btrfs_tmp
    
    # Wenn ein altes root-Subvolume existiert, löschen wir es
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/root_$timestamp"
    fi

    # Behalte alte Roots für 30 Tage (als Backup), lösche ältere
    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    # Erstelle ein brandneues, leeres Root-Subvolume für diesen Bootvorgang!
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  # State-Version (Bitte niemals ändern, das definiert die Kompatibilität der Init-Dateien)
  system.stateVersion = "25.11";
}
