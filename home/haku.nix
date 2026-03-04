{ pkgs, ... }:

{
  # Grundlegende Home-Manager-Einstellungen
  home = {

    # home.stateVersion
    stateVersion = "25.11";

    username = "haku";
    homeDirectory = "/home/haku";
  

    # home.packages
    packages = with pkgs; [
      # Wayland & Desktop
      hyprpaper
      hypridle
    
      # File Explorer
      yazi

      # Rust-basierte CLI-Tools (Die modernen Alternativen)
      eza      # Moderner ls-Ersatz
      zoxide   # Smarter cd-Ersatz
      ripgrep  # Extrem schnelles grep
      fd       # Schnelleres find
      bottom   # Moderner Systemmonitor (htop-Ersatz)

      # Web & Development
      firefox
      wget
      curl
    ];
  };

  programs = {
    home-manager.enable = true;

    # Deine neue deklarative Git-Konfiguration
    git = {
      enable = true;

      settings = {
        user.name = "haku";
        user.email = "haku@horizon.net";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    # GPG konfigurieren
    gpg.enable = true;

    # ass konfigurieren
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]); # Optional: OTP-Support
    };

    # Browserpass (Die Brücke zwischen 'pass' und Firefox)
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    # Nushell deklarativ konfigurieren
    nushell = {
      enable = true;
      # Das hier setzt den GPG_TTY automatisch bei jedem Start der Shell
      environmentVariables = {
        GPG_TTY = "(tty)";
      };
    };
  };

  # Den GPG-Agent als Service starten (fragt nach dem Passwort zum Entschlüsseln)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3; # Eine saubere GUI-Passwortabfrage für Wayland
  };

  imports = [
  #   ./shell/default.nix
    ./desktop/default.nix
    ./theme.nix
  #   ./programs/default.nix
  ];
}
