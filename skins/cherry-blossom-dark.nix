# skins/cherry-blossom-dark.nix
{ config, lib, pkgs, ... }:

{
  # Theme-Engine aktivieren
  horizon.theme.enable = true;

  horizon.theme.ui = {
    # --- SCHRIFTARTEN ---
    font = "DepartureMono Nerd Font Mono";
    font_propo = "DepartureMono Nerd Font Propo";
    
    # --- UI-GEOMETRIE & EFFEKTE ---
    opacity = "0.9";               # Leichte Transparenz für einen luftigeren Look im Terminal
    rounding = 8;                  # Weiche, abgerundete Ecken passen besser zum floralen Thema
    border_size = 2;               # Gut sichtbare Rahmen für die Pink-Töne
    blur_size = 4;                 # Sanfter Blur-Effekt für transparente UI-Elemente
    nixvim_transparent = true;     # Macht Neovim transparent, um den Blur/Hintergrund zu nutzen
    fastfetch_logo = "Sasanqua";
    fastfetch_color = "magenta";

    wallpaper = ./wallpaper/cherry-blossom-dark.jpg;

    homepage = {
      gaps_out = 25;      # Sehr große Ränder, um das Wallpaper in Szene zu setzen
      opacity = "0.85";   # Lässt das Wallpaper sanft durch die Dashboard-Karten scheinen
    };
  };

  horizon.theme.colors = {
    # --- BASIS-FARBEN (Hex-Werte ohne '#') ---
    bg = "1a1418";                 # Hintergrund - Sehr dunkles, warmes Grau mit leichtem Pink-Stich
    fg = "fce4ec";                 # Textfarbe - Zartes Kirschblüten-Weiß
    cursor = "f48fb1";             # Cursor-Farbe - Kräftiges Pink
    
    # --- UI AKZENTE ---
    accent_primary = "f48fb1";     # Aktive Fensterrahmen - Leuchtendes Kirschblüten-Pink
    accent_secondary = "f8bbd0";   # Highlights - Helleres, zartes Pink
    accent_tertiary = "ad8293";    # Subtile Akzente - Gedecktes Altrosa
    inactive_border = "3e2a35";    # Inaktive Fensterrahmen - Dunkles, erdiges Pflaumen-Grau
    
    # --- TERMINAL FARBEN (Semantisch, angepasst an das Frühlings-Thema) ---
    term = {
      black   = "2d1f27";          # Hintergrund-Nuance (Dunkles Altrosa-Grau)
      red     = "f06292";          # Fehler / Löschungen (Kräftiges, dunkleres Pink/Rot)
      green   = "a5d6a7";          # Erfolg (Sanftes Blattgrün als Kontrast zur Kirschblüte)
      yellow  = "ffe082";          # Warnungen (Zartes Pollen-Gelb)
      blue    = "81d4fa";          # Ordner (Sanftes Frühlingshimmel-Blau)
      magenta = "ce93d8";          # Keywords (Weiches Lila)
      cyan    = "80cbc4";          # Strings (Sanftes Türkis)
      white   = "fce4ec";          # Standard-Text (Identisch mit fg)

      bright_black   = "8e6f81"; # Ein sehr gut lesbares, mittleres Pink-Grau für Completions!
      bright_red     = "f48fb1"; # Helleres Pink
      bright_green   = "c8e6c9"; # Helleres Mint
      bright_yellow  = "fff59d"; # Helleres Gelb
      bright_blue    = "b3e5fc"; # Helleres Blau
      bright_magenta = "e1bee7"; # Helleres Lila
      bright_cyan    = "b2dfdb"; # Helleres Cyan
      bright_white   = "ffffff"; # Reines Weiß
    };
  };
}
