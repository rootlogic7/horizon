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
      
      # --- Funktionale Einstellungen (about:config) ---
      settings = {
        # 1. Session & Startseite
        "browser.startup.page" = 3;                  # 3 = Letzte Session (Tabs) wiederherstellen
        "browser.startup.homepage" = "about:home";   # Die Standard-Startseite
        
        # 2. Sicherheit & Passwörter (WICHTIG für browserpass)
        "signon.rememberSignons" = false;            # Firefox soll sich keine Passwörter merken
        "password_manager_and_generate_password.enabled" = false; # Passwort-Generator abschalten
        "signon.autofillForms" = false;              # Kein automatisches Ausfüllen durch Firefox
        
        # 3. Telemetrie & Werbung deaktivieren (Optional, aber empfehlenswert)
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };

      # --- Suchmaschinen (Optional, falls du sie auch synchron haben willst) ---
      search = {
        default = "ddg";
        force = true; # Überschreibt manuelle Änderungen bei jedem Switch!
        engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@np" ];
          };
          "bing".metaData.hidden = true;
          "google".metaData.hidden = true;
        };
      };

    };
  };
}
