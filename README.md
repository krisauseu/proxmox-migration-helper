# Proxmox Migration Helper

Ein einfaches Python-/Bash-basiertes Tool zur Migration von VMs und LXC-Containern zwischen Proxmox-Hosts – interaktiv, sicher und wiederverwendbar.

## Inhalt
- `pve-migrate.py` → Python-Script zur Auswahl, Sicherung und Übertragung von Gästen
- `setup-pve-migrate.sh` → Installer für Python + Virtualenv + Abhängigkeiten
- `restore-lxc.sh` → Bash-Script zur Wiederherstellung von LXC-Containern mit fester IP

---

## Funktionen (Python-Script)

- 🔧 Ziel-IP des neuen Hosts abfragen
- 📋 Alle VMs (`qm list`) und LXCs (`pct list`) automatisch erkennen
- ✅ Interaktive Auswahl per Checkbox-Menü (via `questionary`)
- 📦 Backup mit `vzdump` (komprimiert)
- 🚚 Dateiübertragung via `scp` an den Zielhost

---

## Voraussetzungen

- **Proxmox-Host mit Python 3.6+**
- Paketinstallation via Script möglich (siehe unten)
- SSH-Zugriff auf Zielhost (z. B. mit SSH-Key)

---

## Einrichtung & Start

### 1. Repository klonen
```bash
git clone git@github.com:krisauseu/proxmox-migration-helper.git
cd proxmox-migration-helper
```

### 2. Setup-Script ausführen
```bash
chmod +x setup-pve-migrate.sh
./setup-pve-migrate.sh
```

Das Script installiert:
- Python 3
- Virtualenv unter `/root/pve-migrate-venv`
- `questionary` im VENV

### 3. Migration starten
```bash
source /root/pve-migrate-venv/bin/activate
./pve-migrate.py
```

---

## Wiederherstellung (Restore)

### 1. Backup-Dateien befinden sich auf dem Ziel-Proxmox unter:
```bash
/var/lib/vz/dump
```

### 2. Restore-Script auf dem Zielhost verwenden (Beispiel: `restore-lxc.sh`)

```bash
chmod +x restore-lxc.sh
./restore-lxc.sh
```

Das Restore-Script:
- erkennt die Backup-Dateien automatisch
- weist festen IPs basierend auf Container-IDs oder Vorgaben zu
- spielt die Container in das gewünschte Storage ein (z. B. `local-lvm`)

> Hinweis: Das Script kann einfach erweitert werden, z. B. für VMs oder Autostart-Konfigurationen.

---

## Zusätzliche Hinweise

- Backup-Dateien landen unter `/var/lib/vz/dump`
- Zielhost muss erreichbar sein (z. B. per IP)
- Restore erfolgt separat, z. B. mit eigenem Script oder per Proxmox-GUI
- Das Projekt befindet sich im Aufbau und wird laufend erweitert

---

## Lizenz
MIT License – Use freely, contribute happily. 🚀

