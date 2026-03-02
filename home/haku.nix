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
      waybar
      mako
      fuzzel
    
      # Terminal & Workflow
      foot
      zellij
      yazi

      # Rust-basierte CLI-Tools (Die modernen Alternativen)
      eza      # Moderner ls-Ersatz
      bat      # Moderner cat-Ersatz
      zoxide   # Smarter cd-Ersatz
      ripgrep  # Extrem schnelles grep
      fd       # Schnelleres find
      bottom   # Moderner Systemmonitor (htop-Ersatz)

      # Web & Development
      firefox
      git
      wget
      curl
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  # Später:
  # imports = [
  #   ./shell/default.nix
  #   ./desktop/default.nix
  #   ./programs/default.nix
  # ];
}
