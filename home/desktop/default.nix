{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    # hyprland.conf
    settings = {
      
      # 1. Monitore
      monitor = ",preferred,auto,1";

      # 2. Tastatur
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = 1;
      };

      # 3. Variablen
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "fuzzel";

      # 4. Tastenkürzel (Binds)
      bind = [
        # Programme starten
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        
        # Fenster-Management
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod SHIFT, Space, togglefloating,"
        
        # Hyprland beenden (Ausloggen)
        "$mod SHIFT, E, exit,"

        # Fokus wechseln (mit den Pfeiltasten)
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

	# Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
      ];
    };
  };
}
