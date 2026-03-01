{
  description = "Enso - NixOS Flake Configuration";

  inputs = {
    # Wir nutzen den Unstable-Branch für modernste Pakete (Hyprland, Rust-Tools etc.)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-Manager für das User-Ricing
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Verhindert, dass Home-Manager eigene nixpkgs lädt
    };

    # Disko für die deklarative Festplatten-Partitionierung
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence für "Erase your Darlings"
    impermanence.url = "github:nix-community/impermanence";

    # NixOS Hardware-Profile (enthält TLP, Microcode etc. für dein T470)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Nixvim für unsere Neovim Konfiguration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # greetd display manager and greeter
    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, impermanence, nixos-hardware, nixvim, ... }@inputs: {
    
    nixosConfigurations = {
      # 💻 Host: kaze (ThinkPad T470)
      kaze = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Wir geben alle Inputs an die Module weiter, damit wir sie überall nutzen können
        specialArgs = { inherit inputs; };
        
        modules = [
          # Hardware-spezifische Module
          nixos-hardware.nixosModules.lenovo-thinkpad-t470
          ./hosts/kaze/disko.nix
          disko.nixosModules.disko
          
          # Das Impermanence Modul systemweit laden
          impermanence.nixosModules.impermanence

          # Die Hauptkonfiguration für diesen Host
          ./hosts/kaze/default.nix
          
          # Systemweite Kern-Konfigurationen
          ./system/core.nix
          ./system/network.nix

          # Home-Manager als NixOS-Modul einbinden
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.haku = import ./home/haku.nix;
          }
        ];
      };
      
      # Platzhalter für zukünftige Hosts:
      # yama = nixpkgs.lib.nixosSystem { ... };
    };
  };
}
