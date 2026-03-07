{ config, pkgs, lib, inputs, ... }:

{
  #System
  system.stateVersion = "25.11";

  # Imports
  imports = [ 
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    
    # Unsere gebündelten System-Module
    ../../system/default.nix

    # Home-Manager direkt im Host einbinden
    inputs.home-manager.nixosModules.home-manager
  ];

  # Networking
  networking = {
    hostName = "nova";
  };

  # Home Manager  
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

  # Bootloader Konfiguration
  boot = {
    initrd.availableKernelModules = [ "i915" ];
    initrd.kernelModules = [ "i915" ];
    # Dem Kernel einen Maulkorb verpassen, damit Plymouth glänzen kann
    kernelParams = [ 
      "quiet"
      #"loglevel=3"
      "systemd.show_status=false"
      "udev.log_level=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      #"plymouth.use-simpledrm"
    ];
    # Konsolen-Logs während des Bootens komplett verstecken
    consoleLogLevel = 3;
    initrd.verbose = false;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # Plymouth für den Boot-Splash
    plymouth = {
      enable = true;
      theme = "spin";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "spin" ];
        })
      ];
    };

    # modernes Impermanence: systemd in der initrd
    initrd.systemd.enable = true;

    # Der systemd-Service für den Btrfs-Rollback
    initrd.systemd.services.btrfs-rollback = {
      description = "Rollback Btrfs root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
    
      # Die entscheidenden Abhängigkeiten:
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
  # Hardware-Spezifische Sicherheit (ThinkPad T470 Fingerprint)
  # services.fprintd.enable = true;
  
  # PAM so konfigurieren, dass sudo und su den Fingerabdruck akzeptieren
  #security.pam.services.sudo.fprintAuth = true;
  #security.pam.services.su.fprintAuth = true;
}
