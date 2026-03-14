{ config, pkgs, lib, inputs, ... }:

{
  system.stateVersion = "25.11";

  imports = [
    # Hardware
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    
    # System
    ../../system/default.nix

    # Home Manager
    inputs.home-manager.nixosModules.home-manager
  ];

  networking = {
    hostName = "nova";
  };

  # === SoC Opt-In Features ===
  horizon = {
    desktop.enable = true;
    desktop.monitors = [
      "eDP-1,1366x768@60,0x0,1"
      "DP-6,1280x1024@60,0x-1024,1"
    ];

    impermanence.enable = true;
    network.enable = true;
    security.enable = true;

    power = {
      enable = true;
      chargeThreshold = 85; # Überschreibt den 80% Standard, falls du etwas mehr Kapazität willst
    };
  };

  # Home Manager  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    
    users.haku = {
      imports = [
        #inputs.catppuccin.homeModules.catppuccin
        ../../home/haku.nix
        ../../skins/template.nix
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
      "systemd.show_status=false"
      "udev.log_level=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
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
    
      after = [ "systemd-cryptsetup@cryptroot.service" ];
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
