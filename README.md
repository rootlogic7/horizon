# ⭕ Enso - NixOS Flotilla

> "Aus dem Nichts geboren, ins Nichts zurückkehrend."

Dieses Repository enthält die deklarative Konfiguration für meine Maschinen-Flotte, basierend auf **NixOS Flakes**. Das Kernkonzept des Laptops (`kaze`) ist **Erase your Darlings (Impermanence)**: Bei jedem Neustart wird das Root-Dateisystem (`/`) komplett gelöscht und aus einem leeren Btrfs-Snapshot neu generiert. Nur explizit definierte Daten überleben.

## 🌬️ Die Flotte
* **`kaze` (Wind):** Lenovo ThinkPad T470 (Intel i5, 8GB RAM). Portabel, flüchtig, schnell.
* **`yama` (Berg):** High-End PC (Geplant). Unerschütterlich, massiv.
* **`kura` (Tresor):** Headless Server (Geplant). Bewahrer der Daten.

## 🛠️ Tech Stack (`kaze`)
* **OS:** NixOS Unstable (25.11+)
* **Deployment:** Flakes & Home-Manager
* **Dateisystem:** Btrfs mit LUKS Full Disk Encryption (via Disko)
* **Desktop:** Hyprland (Wayland)
* **Terminal:** Foot, Zellij, Nushell, Starship
* **Editor:** Neovim (Nixvim)
* **Theme:** Gruvbox / Kanagawa (Zen-Ästhetik)

## 🚀 Bootstrap (`kaze`)
*(Kurzanleitung für die Neuinstallation)*
1. NixOS Live-USB booten.
2. LUKS-Passwort setzen: `echo -n "passwort" > /tmp/secret.key`
3. Disko Partitionierung ausführen: `sudo nix run github:nix-community/disko -- --mode disko /pfad/zu/enso/hosts/kaze/disko.nix`
4. System installieren: `sudo nixos-install --flake .#kaze`
