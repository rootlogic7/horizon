# horizon

Deklarative NixOS- und Ansible-Konfiguration.

## Hosts
* `nova` (192.168.178.12): ThinkPad T470. NixOS, Btrfs auf LUKS, Impermanence.
* `quasar` (192.168.178.11): Workstation. NixOS, ZFS auf LUKS, Impermanence.
* `pi` (192.168.178.10): Alpine Linux. Ansible, awall (restricted to .11 & .12), Rootless Podman.

## Secrets & State (Impermanence)
* `/` und `/home` sind flüchtig (ZFS/Btrfs blank snapshot rollback bei Boot).
* State in `/persist` (NetworkManager, SOPS, SSH-Host-Keys).
* Verschlüsselung via `sops-nix` (`secrets/secrets.yaml`).
* SOPS Age-Key wird via Home-Manager Activation automatisch aus `~/.ssh/id_ed25519_main` generiert.

## Installation / Bootstrap (NixOS)
1. NixOS Live-ISO booten.
2. Repo klonen und in das Verzeichnis wechseln.
3. LUKS-Passwort für Disko temporär setzen:
   ```bash
   echo -n "passwort" > /tmp/secret.Age-Key
   ```
4. Disko Partitionierung (ACHTUNG: Löscht Ziel-Datenträger):
   ```bash
   sudo nix run github:nix-community/disko -- --mode disko ./hosts/<hostname>/disko.nix
   ```
5. NixOS installieren:
   ```bash
   sudo nixos-install --flake .#<hostname>
   ```
6. Reboot ins neue System.
7. Privaten SSH-Key (`id_ed25519_main`) nach `~/.ssh/` kopieren.
8. Home-Manager/NixOS rebuild ausführen (generiert den Age-Key für SOPS).

## Server Deployment (Ansible / Pi)
1. In den Flake-Ordner wechseln.
2. DevShell starten (lädt Ansible, SOPS, sshpass):
   ```bash
   nix develop
   ```
3. Playbook ausführen:
   ```bash
   ansible-playbook ops/pi/pi.yml -K
   ```
