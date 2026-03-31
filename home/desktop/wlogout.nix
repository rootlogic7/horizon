# home/desktop/wlogout.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;
in {
  programs.wlogout = {
    enable = true;

    # Layout der Buttons definieren
    layout = [
      { label = "lock"; action = "swaylock"; text = "Sperren"; keybind = "l"; }
      { label = "hibernate"; action = "systemctl hibernate"; text = "Ruhezustand"; keybind = "h"; }
      { label = "logout"; action = "hyprctl dispatch exit 0"; text = "Abmelden"; keybind = "e"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Herunterfahren"; keybind = "s"; }
      { label = "suspend"; action = "systemctl suspend"; text = "Standby"; keybind = "u"; }
      { label = "reboot"; action = "systemctl reboot"; text = "Neustart"; keybind = "r"; }
    ];

    # Styling dynamisch an den Horizon-Skin anpassen
    style = ''
      * {
        font-family: "${theme.ui.font}";
        background-image: none;
        transition: 200ms;
      }

      window {
        /* Ein leicht transparenter Hintergrund, falls Hyprland-Blur nicht reicht */
        background-color: rgba(0, 0, 0, 0.5); 
      }

      button {
        color: #${theme.colors.fg};
        background-color: #${theme.colors.bg};
        border: ${toString theme.ui.border_size}px solid #${theme.colors.accent_tertiary};
        border-radius: ${toString theme.ui.rounding}px;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.1);
        margin: 1rem;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: #${theme.colors.accent_primary};
        border: ${toString theme.ui.border_size}px solid #${theme.colors.accent_secondary};
        color: #${theme.colors.bg};
        outline: none;
      }

      /* Standard-Icons von wlogout wieder einblenden (da wir oben background-image: none gesetzt haben) */
      #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    '';
  };
}
