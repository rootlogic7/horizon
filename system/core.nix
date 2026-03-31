{ config, pkgs, ... }:

{
  # oderne Nix-Features aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Speichermanagement: Alte Pakete automatisch aufräumen
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Zeitzone und Sprache (Deutschland)
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Globales Tastaturlayout
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.useXkbConfig = true;

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "de";
    XKB_DEFAULT_VARIANT = "nodeadkeys";
    NIXOS_OZONE_WL = "1";
  };
  # SOPS Secrets Konfiguration
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  
    # SOPS sagen, wo es den Host-Key zum Entschlüsseln findet.
    # Da impermanence aktiv ist, greifen wir am besten direkt auf den /persist Pfad zu,
    # um Probleme beim frühen Booten (early boot) zu vermeiden.
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    # Unser Passwort-Secret definieren
    secrets.haku_password = {
      neededForUsers = true; # Wichtig: Muss VOR dem Erstellen der User entschlüsselt werden!
    };
  };

  # Der Hauptnutzer: haku
  users.users.haku = {
    isNormalUser = true;
    description = "admin";
    # 'wheel' gibt dir sudo-Rechte, 'networkmanager' erlaubt WLAN-Änderungen ohne Passwort
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];

    hashedPasswordFile = config.sops.secrets.haku_password.path;
    
    # WICHTIG: Ein temporäres Passwort für den allerersten Login. 
    # Nach der Installation solltest du sofort "passwd" im Terminal ausführen!
    # initialPassword = "haku"; 
    # === -> sops-nix kümmert sich nun um das passwort für haku ===
  };

  #programs.bash.interactiveShellInit = ''
  #  if [[ $TERM != "dumb" && -z "''${BASH_EXECUTION_STRING}" ]]; then
  #    exec nu
  #  fi
  #'';

  # Damit Nushell als Login-Shell funktioniert, muss sie systemweit aktiviert sein
  environment.shells = [ pkgs.nushell ];

  # --- Container & Virtualisierung ---
  virtualisation.podman = {
    enable = true;
    # Optional: Macht 'docker' als Befehl verfügbar, nutzt aber im Hintergrund podman
    dockerCompat = true; 
  };

  virtualisation.containers.registries.insecure = [ "192.168.178.10:3000" ];
}
