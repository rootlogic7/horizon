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

      starship
      fastfetch
      zoxide
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

    # pass konfigurieren
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
      # Hier kannst du Aliase definieren, die eza nutzen
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        ls = "eza";
        tree = "eza --tree";
      };
      extraConfig = ''
        $env.config = {
          show_banner: false,
        }

        # zoxide
        source-env ~(zoxide init nushell | lines | where ($it | str contains "env") | str join "\n" | save -f ~/.cache/zoxide_env.nu; print "")

        # Starship direkt initialisieren
        # starship init nu | save -f ~/.cache/starship_init.nu
        # source ~/.cache/starship_init.nu

        # Fastfetch beim Start
        fastfetch
      '';

      # environmentVariables = {
      #   GPG_TTY = "(tty)";
      # };
    };
    
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Starship für ein schönes Prompt
    starship = {
      enable = true;
      enableNushellIntegration = true;
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
