# skins/template.nix
# -------------------------------------------------------------------------
# BLAUPAUSE FÜR NEUE THEMES
# Anleitung: 
# 1. Kopiere diese Datei (z.B. zu skins/mein_theme.nix)
# 2. Binde die neue Datei in deiner Host-Config (z.B. hosts/nova/default.nix) ein.
# 3. Ändere die Werte unten nach Belieben!
# -------------------------------------------------------------------------

{ config, lib, pkgs, ... }:

{
  # Theme-Engine aktivieren
  horizon.theme.enable = true;

  horizon.theme.ui = {
    # --- SCHRIFTARTEN ---
    font = "DepartureMono Nerd Font Mono";
    font_propo = "DepartureMono Nerd Font Propo";
    
    # --- UI-GEOMETRIE & EFFEKTE ---
    opacity = "1.0";      # Transparenz für Foot-Terminal (0.0 bis 1.0)
    rounding = 0;         # Eckenabrundung in Pixeln (0 = eckig)
    border_size = 2;      # Rahmendicke für Fenster und Fuzzel
    blur_size = 0;        # Stärke des Hintergrund-Blurs in Hyprland
    nixvim_transparent = true;
    fastfetch_logo = "Sasanqua";
    fastfetch_color = "magenta";
  };

  horizon.theme.colors = {
    # --- BASIS-FARBEN (Hex-Werte ohne '#') ---
    bg = "1a1523";        # Hintergrund - Midnight Plum
    fg = "fce4ec";        # Textfarbe - Cherry Blossom
    cursor = "ffffff";    # Cursor-Farbe
    
    # --- UI AKZENTE (Graustufen als Startpunkt) ---
    accent_primary = "f5c2e7";   # Pastell-Pink
    accent_secondary = "89b4fa"; # Pastell-Blau
    accent_tertiary = "cba6f7";  # Lavendel
    inactive_border = "2e263d";  # Helles Plum-Grau
    
    # --- TERMINAL FARBEN (Semantisch) ---
    term = {
      black   = "93808e"; # Rauchiges Lila
      red     = "ff8fa3"; # Erdbeer-Pink
      green   = "a6e3a1"; # Mintgrün
      yellow  = "fae3b0"; # Pfirsich-Gelb
      blue    = "89b4fa"; # Pastell-Blau
      magenta = "cba6f7"; # Lavendel
      cyan    = "89dceb"; # Aqua
      white   = "fce4ec"; # Cherry Blossom
    };
  };
}
