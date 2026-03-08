{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.impermanence;
in {
  options.horizon.impermanence = {
    enable = mkEnableOption "Enable Impermanence (Erase your Darlings)";
  };

  config = mkIf cfg.enable {
    fileSystems."/persist".neededForBoot = true;

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
      users.haku = {
        directories = [
          "horizon"
          ".ssh"
          ".config/sops"
          ".gnupg"
          ".password-store"
          ".mozilla"
          ".config/mozilla"
          ".local/share/nushell"
          ".local/share/zoxide"
          ".local/share/keyrings"
          ".local/state/nvim"
          ".local/share/nvim"
        ];
        files = [
          ".config/nushell/history.txt"
        ];
      };  
    };

    systemd.tmpfiles.rules = [
      "d /persist/var/lib 0755 root root -"
    ];
  };
}
