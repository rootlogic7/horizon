{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.11";

  # Importiere später die hardware-configuration.nix
  # imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "kaze";
  };

  # 🚀 Bootloader Konfiguration
  boot = { 
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
  };

    # Plymouth für den Boot-Splash
    plymouth.enable = true;

    # ⚙️ Modernes Impermanence: systemd in der initrd
    initrd.systemd.enable = true;

    # Der systemd-Service für den Btrfs-Rollback
    initrd.systemd.services.btrfs-rollback = {
      description = "Rollback Btrfs root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
    
      # 🔗 Die entscheidenden Abhängigkeiten:
      # 1. Muss NACH der LUKS-Entschlüsselung laufen (cryptroot ist der Name aus disko.nix)
      after = [ "systemd-cryptsetup@cryptroot.service" ];
      # 2. Muss VOR dem eigentlichen Mounten von / laufen
      before = [ "sysroot.mount" ];
    
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
    
      script = ''
        mkdir -p /btrfs_tmp
        # Wir mounten das Top-Level Btrfs-Volume (Subvolid 5)
        mount -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp

        # Wenn das alte root-Subvolume existiert, wird es gelöscht
        if [ -d "/btrfs_tmp/root" ]; then
            btrfs subvolume delete /btrfs_tmp/root
        fi

        # Wir erstellen ein brandneues, leeres root-Subvolume
        btrfs subvolume create /btrfs_tmp/root
      
        umount /btrfs_tmp
      '';
    };
  };
}
