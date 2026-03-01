{ pkgs, ... }:

{
  # Grundlegende Home-Manager-Einstellungen
  home.username = "haku";
  home.homeDirectory = "/home/haku";
  
  # Diese Version muss (genau wie in der systemweiten config) auf 25.11 bleiben
  home.stateVersion = "25.11";

  # 📦 Das Basis-Arsenal für unseren "Min-Maxing" Ansatz
  home.packages = with pkgs; [
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

  # Home-Manager darf sich selbst verwalten
  programs.home-manager.enable = true;

  # Später, wenn das System läuft, werden wir hier unsere Module importieren:
  # imports = [
  #   ./shell/default.nix
  #   ./desktop/default.nix
  #   ./programs/default.nix
  # ];
}
