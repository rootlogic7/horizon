# skins/kawaii.nix
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
    rounding = 8;         # Eckenabrundung in Pixeln (0 = eckig)
    border_size = 4;      # Rahmendicke für Fenster und Fuzzel
    blur_size = 0;        # Stärke des Hintergrund-Blurs in Hyprland
  };

  horizon.theme.colors = {
    # --- BASIS-FARBEN (Hex-Werte ohne '#') ---
    bg = "f1fffd";        # Hintergrund (pastel-yellow)
    fg = "586664";        # Textfarbe (pastel-turquoise)
    cursor = "ffffff";    # Cursor-Farbe
    
    # --- UI AKZENTE (Graustufen als Startpunkt) ---
    accent_primary = "ffdef2";   # Aktive Fensterrahmen & Fokus-Elemente (pastel-rose)
    accent_secondary = "ffdef2"; # Highlights (z.B. Hover-Zustände) (pastel-purple)
    accent_tertiary = "ffdef2";  # Subtile Akzente (z.B. inaktive Workspaces) (pastel-blue)
    inactive_border = "fff5fb";  # Inaktive Fensterrahmen
    
    # --- TERMINAL FARBEN (Semantisch) ---
    term = {
      black   = "1e1e2e"; # regular0 (Hintergrund-Nuance)
      red     = "f38ba8"; # regular1 (Fehler, Löschungen in Git)
      green   = "a6e3a1"; # regular2 (Erfolg, Hinzugefügtes in Git)
      yellow  = "f9e2af"; # regular3 (Warnungen, Änderungen)
      blue    = "89b4fa"; # regular4 (Ordner, Symlinks)
      magenta = "f5c2e7"; # regular5 (Keywords, best. Code-Elemente)
      cyan    = "89dceb"; # regular6 (Strings, Infos)
      white   = "eeeeee"; # regular7 (Standard-Text)
    };
  };
}
