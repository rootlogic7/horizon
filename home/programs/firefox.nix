# home/programs/firefox.nix
{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    # Wir definieren hier nur die Hülle des Profils
    profiles.haku = {
      id = 0;
      isDefault = true;
      name = "haku";
      
      # Hier kommen später funktionale Settings, Suchmaschinen etc. hin
    };
  };
}
