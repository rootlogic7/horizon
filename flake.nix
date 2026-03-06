{
  description = "Horizon";

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
    impermanence = {
      url= "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware-Profile (enthält TLP, Microcode etc. für dein T470)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Nixvim für unsere Neovim Konfiguration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, impermanence, nixos-hardware, nixvim, sops-nix, ... }@inputs: {
    
    nixosConfigurations = {
      # Host: nova (ThinkPad T470)
      nova = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Wir geben alle Inputs an die Module weiter, damit wir sie überall nutzen können
        specialArgs = { inherit inputs; };
        
        modules = [
          # Hardware-Profil
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          
          # Globale Nix-Community Module
          inputs.impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          
          # Der Einsprungpunkt für den Host "nova". 
          # Ab hier übernimmt default.nix!
          ./hosts/nova/default.nix
        ];
      };
      
      # Platzhalter für zukünftige Hosts:
      # quasar = nixpkgs.lib.nixosSystem { ... };
    };
  };
}
