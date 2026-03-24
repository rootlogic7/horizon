{ pkgs, osConfig, ... }:

{
  # Alle CLI-Tools, die du primär in der Shell nutzt
  home.packages = with pkgs; [
    eza
    zoxide
    ripgrep
    fd
    bottom
    starship
  ];

  #programs.fastfetch = {
  #  enable = true;
  #};

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
        rebuild-pi = "ansible-playbook -i inventory.yml pi.yml";
      };

      # fastfetch
      extraConfig = ''
        $env.config.show_banner = false
        fastfetch
      '';
    };

    # Zoxide
    zoxide = {
      enable = true;
      enableNushellIntegration = true; 
    };

    # Starship
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Direnv
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
