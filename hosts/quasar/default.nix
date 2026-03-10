# hosts/quasar/default.nix
{ config, pkgs, lib, inputs, ... }:

{
  system.stateVersion = "25.11"; # Oder deine entsprechende Version

  imports = [ 
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    
    # Unsere gebündelten System-Module (inkl. nvidia.nix)
    ../../system/default.nix

    # Home-Manager direkt im Host einbinden
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "quasar";
  networking.hostId = "DEINE_ALTE_ID"; # WICHTIG: Hier die ID des alten Systems eintragen!

  # === NEU: SoC Opt-In Features aktivieren ===
  horizon = {
    desktop.enable = true;
    impermanence.enable = true;
    network.enable = true;
    security.enable = true;
    
    # Nvidia & Wayland Tweaks aktivieren
    hardware.nvidia.enable = true;
  };

  # === Home Manager Setup ===
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    
    users.haku = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        ../../home/haku.nix
      ];
    };
  };

  # === Boot & Dateisystem (ZFS & LUKS) ===
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

    # --- Die alten HDDs (RAID 1 & Massenspeicher) via LUKS einbinden ---
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

  services.zfs.trim.enable = true;

  # --- Mounts für die alten HDD-ZFS-Pools ---
  fileSystems."/storage/backup" = { device = "safe/backup"; fsType = "zfs"; };
  fileSystems."/storage/media"  = { device = "extra/media"; fsType = "zfs"; };

  # Wichtig für Impermanence (Disko mountet den Rest automatisch)
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
}
