{ pkgs, ... }:

{
  # ❄️ Moderne Nix-Features aktivieren
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Speichermanagement: Alte Pakete automatisch aufräumen
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Zeitzone und Sprache (Deutschland)
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  # Globales Tastaturlayout
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.useXkbConfig = true;

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "de";
    XKB_DEFAULT_VARIANT = "nodeadkeys";
  };

  # 👤 Der Hauptnutzer: haku
  users.users.haku = {
    isNormalUser = true;
    description = "Der Geist in der Maschine";
    # 'wheel' gibt dir sudo-Rechte, 'networkmanager' erlaubt WLAN-Änderungen ohne Passwort
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    
    # ⚠️ WICHTIG: Ein temporäres Passwort für den allerersten Login. 
    # Nach der Installation solltest du sofort "passwd" im Terminal ausführen!
    initialPassword = "haku"; 
    
    # Wir setzen Nushell direkt als Standard-Shell
    shell = pkgs.nushell;
  };

  # Damit Nushell als Login-Shell funktioniert, muss sie systemweit aktiviert sein
  environment.shells = [ pkgs.nushell ];
}
