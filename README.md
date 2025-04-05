# Proxmox Migration Helper

A simple Python/Bash-based tool for migrating VMs and LXC containers between Proxmox hosts – interactive, safe, and reusable.

Ein einfaches Python-/Bash-basiertes Tool zur Migration von VMs und LXC-Containern zwischen Proxmox-Hosts – interaktiv, sicher und wiederverwendbar.

---

## 🇬🇧 English

### Contents
- `pve-migrate.py` → Python script for selecting, backing up, and transferring guests
- `setup-pve-migrate.sh` → Installer for Python + Virtualenv + dependencies
- `restore-lxc.sh` → Bash script for restoring LXC containers and VMs

### Features (Python Script)
- 🔧 Prompt for the IP of the target Proxmox host
- 📋 Automatically detect all VMs (`qm list`) and LXCs (`pct list`)
- ✅ Interactive checkbox selection menu (via `questionary`)
- 📦 Backup with `vzdump` (compressed)
- 🚚 File transfer via `scp` to the target host

### Requirements
- Proxmox host with Python 3.6+
- Package installation via setup script
- SSH access to the target host (e.g. via SSH key)

### Setup & Usage
```bash
git clone git@github.com:krisauseu/proxmox-migration-helper.git
cd proxmox-migration-helper
chmod +x setup-pve-migrate.sh
./setup-pve-migrate.sh
```
Then:
```bash
source /root/pve-migrate-venv/bin/activate
./pve-migrate.py
```

### Restore (on target host)
```bash
chmod +x restore-lxc.sh
./restore-lxc.sh
```
This script will:
- Auto-detect LXC and VM backup files
- Restore them into the desired storage (e.g. `local-lvm`)
- Can be extended to include static IP assignment or autostart

---

## 🇩🇪 Deutsch

### Inhalt
- `pve-migrate.py` → Python-Script zur Auswahl, Sicherung und Übertragung von Gästen
- `setup-pve-migrate.sh` → Installer für Python + Virtualenv + Abhängigkeiten
- `restore-lxc.sh` → Bash-Script zur Wiederherstellung von LXC-Containern und VMs

### Funktionen (Python-Script)
- 🔧 Ziel-IP des neuen Hosts abfragen
- 📋 Alle VMs (`qm list`) und LXCs (`pct list`) automatisch erkennen
- ✅ Interaktive Auswahl per Checkbox-Menü (via `questionary`)
- 📦 Backup mit `vzdump` (komprimiert)
- 🚚 Dateiübertragung via `scp` an den Zielhost

### Voraussetzungen
- Proxmox-Host mit Python 3.6+
- Paketinstallation via Script möglich (siehe oben)
- SSH-Zugriff auf Zielhost (z. B. mit SSH-Key)

### Einrichtung & Start
```bash
git clone git@github.com:krisauseu/proxmox-migration-helper.git
cd proxmox-migration-helper
chmod +x setup-pve-migrate.sh
./setup-pve-migrate.sh
```
Dann:
```bash
source /root/pve-migrate-venv/bin/activate
./pve-migrate.py
```

### Wiederherstellung (auf dem Zielhost)
```bash
chmod +x restore-lxc.sh
./restore-lxc.sh
```
Das Script:
- erkennt LXC- und VM-Backups automatisch
- spielt sie in das gewählte Storage ein (z. B. `local-lvm`)
- kann um statische IP-Zuweisung oder Autostart erweitert werden

---

## License / Lizenz
MIT License – Use freely, contribute happily. / Frei verwendbar, Beiträge willkommen 🚀

