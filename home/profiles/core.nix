# home/profiles/core.nix
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    yazi
    wget
    curl
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "haku";
        user.email = "haku@horizon.net";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    gpg.enable = true;
    
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };
  };

  services.gpg-agent = {
    enable = true;
    # Für Server nutzen wir standardmäßig die CLI-Passwortabfrage (Curses)
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ../shell/default.nix
    ../programs/nixvim.nix
  ];
}
