{ config, pkgs, lib, inputs, ... }:

{
  system.stateVersion = "25.11"; # Oder deine aktuelle State Version

  imports = [ 
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    # ... hier kommen später deine Horizon-Module (z.B. horizon.hardware.nvidia.enable)
  ];

  networking.hostName = "quasar";
  networking.hostId = "8425e349";

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

    # --- Die alten HDDs (RAID 1 & Massenspeicher) einbinden ---
    initrd.luks.devices = {
      "crypt_safe1" = { device = "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_94JKP2VHS-part1"; preLVM = true; };
      "crypt_safe2" = { device = "/dev/disk/by-id/ata-WDC_WD40EZRZ-22GXCB0_WD-WCC7K5LD8Y9V-part1"; preLVM = true; };
      "crypt_extra" = { device = "/dev/disk/by-id/ata-WDC_WD40EZRZ-22GXCB0_WD-WCC7K5LD8Y9V-part2"; preLVM = true; };
    };

    # --- ZFS Erase Your Darlings Rollback (für die neuen SSDs) ---
    initrd.systemd.enable = true;
    initrd.systemd.services.zfs-rollback = {
      description = "Rollback ZFS datasets to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "zfs-import-rpool.service" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [ zfs ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "Rolling back ZFS root and home datasets..."
        zfs rollback -r rpool/root@blank
        zfs rollback -r rpool/home@blank
      '';
    };
  };

  # SSD TRIM für ZFS aktivieren
  services.zfs.trim.enable = true;

  # --- Mounts für die alten HDD-ZFS-Pools ---
  fileSystems."/storage/backup" = { device = "safe/backup"; fsType = "zfs"; };
  fileSystems."/storage/media"  = { device = "extra/media"; fsType = "zfs"; };

  # Disko generiert die Mounts für die SSDs automatisch. 
  # Wir markieren persist und home aber zusätzlich als 'neededForBoot', 
  # damit das Impermanence-Modul sauber funktioniert (wie in deiner alten Config).
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
}
