{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.11";

  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "nova";
  };

  # 🚀 Bootloader Konfiguration
  boot = {
    # Dem Kernel einen Maulkorb verpassen, damit Plymouth glänzen kann
    kernelParams = [ 
      "quiet" 
#      "splash" 
      "loglevel=3" 
#      "rd.systemd.show_status=false" 
      "systemd.show_status=auto"
      "rd.udev.log_level=3" 
      "udev.log_priority=3" 
    ];
    # Konsolen-Logs während des Bootens komplett verstecken
    consoleLogLevel = 0;
    initrd.verbose = false;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # Plymouth für den Boot-Splash
    plymouth = {
      enable = true;
      theme = "cyanide";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "cyanide" ];
        })
      ];
    };

    # odernes Impermanence: systemd in der initrd
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
        mount -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp

        if [ -d "/btrfs_tmp/root" ]; then
            # Lösche erst alle verschachtelten Subvolumes (z.B. von systemd)
            btrfs subvolume list -o /btrfs_tmp/root | cut -f9 -d' ' |
            while read subvolume; do
                btrfs subvolume delete "/btrfs_tmp/$subvolume"
            done &&
            btrfs subvolume delete /btrfs_tmp/root
        fi

        btrfs subvolume create /btrfs_tmp/root
      
        umount /btrfs_tmp
      '';
    };
  };
}
