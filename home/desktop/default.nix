# home/desktop/default.nix
{ config, pkgs, lib, ... }:

let
  # Das Skript zum Wechseln des Themes
  themeSwitcher = pkgs.writeShellScriptBin "theme-switcher" ''
    THEME=$1
    if [[ "$THEME" != "dark" && "$THEME" != "light" ]]; then
      echo "Fehler: Bitte 'dark' oder 'light' angeben!"
      echo "Beispiel: theme-switcher light"
      exit 1
    fi

    echo "Wechsle zu Theme: $THEME..."

    # 1. Den Symlink auf das neue Theme umbiegen
    ln -sfn ~/.config/horizon/themes/$THEME ~/.config/horizon/themes/current

    # 2. Programme zwingen, die Konfiguration neu zu laden
    
    # Hyprland (Lädt meist automatisch, aber zur Sicherheit erzwingen wir es)
    ${pkgs.hyprland}/bin/hyprctl reload
    
    # Waybar (SIGUSR2 lädt die CSS-Datei neu, ohne dass das Programm beendet wird)
    ${pkgs.procps}/bin/pkill -SIGUSR2 waybar
    
    # Foot (SIGUSR1 zwingt alle offenen Terminals, die foot.ini neu einzulesen)
    ${pkgs.procps}/bin/pkill -USR1 foot

    # Mako (falls du ihn für Benachrichtigungen nutzt)
    if command -v makoctl >/dev/null 2>&1; then
      makoctl reload
    fi

    # 3. Hintergrundbild nahtlos wechseln
    # Starte ein neues swaybg über dem alten
    ${pkgs.swaybg}/bin/swaybg -i ~/.config/horizon/themes/current/wallpaper -m fill &
    NEW_PID=$!
    sleep 0.5 # Kurz warten bis es gerendert ist
    # Dann alle alten swaybg Instanzen töten, außer die neue!
    for pid in $(${pkgs.procps}/bin/pgrep swaybg); do
      if [ "$pid" != "$NEW_PID" ]; then
        kill $pid
      fi
    done

    echo "Theme erfolgreich auf $THEME geändert!"
  '';

in {
  imports = [
    ./foot.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  # Wir fügen das Skript als Paket hinzu, damit es in der Kommandozeile verfügbar ist
  home.packages = [ 
    themeSwitcher 
  ];

  # Wir verknüpfen deine Hintergrundbilder (aus deinem Repo) mit den Themes!
  # So musst du sie nicht manuell irgendwo hinkopieren.
  xdg.configFile."horizon/themes/dark/wallpaper".source = ./wallpaper.jpg;
  xdg.configFile."horizon/themes/light/wallpaper".source = ./wallpaper.png;

  # Das Default-Theme (Dark) wird beim ersten System-Build als 'current' gesetzt
  # Der Switcher kann es danach überschreiben.
  home.activation.setupDefaultTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/horizon/themes
    if [ ! -e ~/.config/horizon/themes/current ]; then
      ln -sfn ~/.config/horizon/themes/dark ~/.config/horizon/themes/current
    fi
  '';
}
