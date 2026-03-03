# 🌌 horizon - NixOS Flotilla

> "Past the event horizon, nothing returns."

Dieses Repository enthält die deklarative Konfiguration für meine Maschinen-Flotte, basierend auf **NixOS Flakes**. Das Kernkonzept des Laptops (`nova`) ist **Erase your Darlings (Impermanence)**: Bei jedem Neustart überschreitet das System seinen Ereignishorizont. Das Root-Dateisystem (`/`) wird komplett gelöscht und aus einem leeren Btrfs-Snapshot neu generiert. Nur explizit definierte Daten überleben.

## 🪐 Die Flotte
* **`nova` (Laptop):** Lenovo ThinkPad T470 (Intel i5, 8GB RAM). Eine grelle, flüchtige Sternenexplosion. Portabel, schnell, wird bei jedem Shutdown ausgelöscht.
* **`quasar` (Desktop):** High-End PC (Geplant). Purer Energiekern, massiv und leistungsstark.
* **`pulsar` (Server):** Headless Server (Geplant). Rotiert stumm in der Dunkelheit. Bewahrer der persistenten Daten.

## 🛠️ Tech Stack (`nova`)
* **OS:** NixOS Unstable (25.11+)
* **Deployment:** Flakes & Home-Manager
* **Dateisystem:** Btrfs mit LUKS Full Disk Encryption (via Disko)
* **Desktop:** Hyprland (Wayland)
* **Terminal:** Foot, Zellij, Nushell, Starship
* **Editor:** Neovim (Nixvim)
* **Theme:** Catppuccin Mocha (Kosmische Ästhetik)

## 🚀 Bootstrap (`nova`)
*(Kurzanleitung für die Neuinstallation)*
1. NixOS Live-USB booten.
2. LUKS-Passwort setzen: `echo -n "passwort" > /tmp/secret.key`
3. Disko Partitionierung ausführen: `sudo nix run github:nix-community/disko -- --mode disko /pfad/zu/horizon/hosts/nova/disko.nix`
4. System installieren: `sudo nixos-install --flake .#nova`
