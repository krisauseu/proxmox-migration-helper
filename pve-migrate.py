#!/usr/bin/env python3

import subprocess
import questionary
import os

# IP-Adresse des Zielhosts abfragen
target_ip = questionary.text("🖥️  Gib die IP-Adresse des neuen Proxmox-Hosts ein:").ask()

# Speicherort für Backups
dump_dir = "/var/lib/vz/dump"

# Hole VMs (KVM)
def get_vms():
    result = subprocess.run(["qm", "list"], capture_output=True, text=True)
    lines = result.stdout.strip().splitlines()[1:]
    return [line.split()[0] for line in lines]

# Hole LXCs
def get_lxc():
    result = subprocess.run(["pct", "list"], capture_output=True, text=True)
    lines = result.stdout.strip().splitlines()[1:]
    return [line.split()[0] for line in lines]

# Auswahlmenü
def choose_ids(vm_ids, lxc_ids):
    vm_choices = [f"VM  {vid}" for vid in vm_ids]
    lxc_choices = [f"LXC {cid}" for cid in lxc_ids]
    all_choices = vm_choices + lxc_choices

    selected = questionary.checkbox(
        "✅ Welche VMs und LXCs sollen übertragen werden?",
        choices=all_choices
    ).ask()

    return selected

# Backup und Transfer
def backup_and_transfer(selected_ids):
    for item in selected_ids:
        parts = item.split()
        typ = parts[0]
        vmid = parts[1]

        print(f"\n📦 Starte Backup von {typ} {vmid}...")

        try:
            subprocess.run(["vzdump", vmid, "--compress", "zstd", "--dumpdir", dump_dir], check=True)
        except subprocess.CalledProcessError:
            print(f"❌ Fehler beim Backup von {typ} {vmid}")
            continue

        # Backup-Datei finden (neueste .zst für diese ID)
        try:
            fname = subprocess.check_output(
                f"ls -t {dump_dir}/vzdump-{typ.lower()}-{vmid}-*.tar.zst",
                shell=True, text=True
            ).strip().splitlines()[0]
        except subprocess.CalledProcessError:
            print(f"❌ Keine Backup-Datei für {vmid} gefunden.")
            continue

        print(f"🚚 Übertrage {os.path.basename(fname)} an {target_ip} ...")
        subprocess.run(["scp", fname, f"root@{target_ip}:{dump_dir}"])

# Hauptlogik
def main():
    print(f"\n📡 Zielhost-IP: {target_ip}")

    vms = get_vms()
    lxcs = get_lxc()

    if not vms and not lxcs:
        print("⚠️  Keine VMs oder LXCs gefunden.")
        return

    selected = choose_ids(vms, lxcs)

    if selected:
        backup_and_transfer(selected)
        print("\n✅ Alle gewählten Systeme wurden gesichert und übertragen.")
    else:
        print("❌ Keine Auswahl getroffen. Nichts zu tun.")

if __name__ == "__main__":
    main()
