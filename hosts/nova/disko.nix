{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # 1. Die EFI-Boot-Partition (Vergrößert auf 1 GB)
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # 2. Die LUKS-verschlüsselte Partition
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                # Liest das Passwort bei der Installation aus dieser Datei:
                passwordFile = "/tmp/secret.key";
                settings = {
                  allowDiscards = true; # TRIM-Support für NVMe (wichtig für SSD-Gesundheit)
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Erzwingt Formatierung
                  subvolumes = {
                    # Das flüchtige Root-Verzeichnis
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Der Nix-Store (System-Kern)
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Persistente Daten (Home-Manager, Secrets, SSH-Keys)
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Swap-Subvolume (Für Hibernation! Kein CoW, keine Kompression)
                    "/swap" = {
                      mountpoint = "/swap";
                      # 'nodatacow' ist kritisch, damit Btrfs die Datei nicht fragmentiert,
                      # was Voraussetzung für Hibernation (resume_offset) ist.
                      mountOptions = [ "noatime" "nodatacow" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
