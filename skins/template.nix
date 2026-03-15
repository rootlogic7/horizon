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
    nixvim_transparent = false; # Nixvim background opacity toggle
    fastfetch_logo = "nixos_small"; # Alternativen: fastfetch --print-logos
    fastfetch_color = "magenta";
  };

  horizon.theme.colors = {
    # --- BASIS-FARBEN (Hex-Werte ohne '#') ---
    bg = "0a0a0a";        # Hintergrund (Sehr dunkles Grau/Schwarz)
    fg = "e0e0e0";        # Textfarbe (Weiß/Hellgrau)
    cursor = "ffffff";    # Cursor-Farbe
    
    # --- UI AKZENTE (Graustufen als Startpunkt) ---
    accent_primary = "888888";   # Aktive Fensterrahmen & Fokus-Elemente
    accent_secondary = "aaaaaa"; # Highlights (z.B. Hover-Zustände)
    accent_tertiary = "555555";  # Subtile Akzente (z.B. inaktive Workspaces)
    inactive_border = "222222";  # Inaktive Fensterrahmen
    
    # --- TERMINAL FARBEN (Semantisch) ---
    term = {
      black   = "1a1a1a"; # regular0 (Hintergrund-Nuance)
      red     = "ff5555"; # regular1 (Fehler, Löschungen in Git)
      green   = "44cc44"; # regular2 (Erfolg, Hinzugefügtes in Git)
      yellow  = "ffcc00"; # regular3 (Warnungen, Änderungen)
      blue    = "4488ff"; # regular4 (Ordner, Symlinks)
      magenta = "cc55ff"; # regular5 (Keywords, best. Code-Elemente)
      cyan    = "00cccc"; # regular6 (Strings, Infos)
      white   = "eeeeee"; # regular7 (Standard-Text)
    };
  };
}
