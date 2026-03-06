{ pkgs, osConfig, ... }:

{
  # Alle CLI-Tools, die du primär in der Shell nutzt
  home.packages = with pkgs; [
    eza
    zoxide
    ripgrep
    fd
    bottom
    fastfetch
    starship
  ];

  programs = {
    # Nushell Konfiguration
    nushell = {
      enable = true;
      
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        ls = "eza";
        tree = "eza --tree";

        # Git
        gs = "git status";
        ga = "git add";
        gc = "git commit -m";
        gp = "git push";

        # Nixos
        nix-switch = "sudo nixos-rebuild switch --flake .#${osConfig.networking.hostName}";
        nix-update = "nix flake update";
      };

      # Keine manuellen Init-Skripte mehr nötig für Zoxide/Starship!
      extraConfig = ''
        $env.config = {
          show_banner: false,
        }
        # Fastfetch beim Start anzeigen
        fastfetch
      '';
    };

    # Zoxide (Smarter cd-Ersatz)
    zoxide = {
      enable = true;
      enableNushellIntegration = true; # Home-Manager baut die Integration selbst!
    };

    # Starship Prompt
    starship = {
      enable = true;
      enableNushellIntegration = true; # Home-Manager baut die Integration selbst!
    };
  };
}
