#!/bin/bash

# Verzeichnis, in dem sich die Backup-Dateien befinden
DUMP_DIR="/var/lib/vz/dump"
STORAGE="local-lvm"
BRIDGE="vmbr0"
GATEWAY="172.16.16.1"  # Anpassen, falls notwendig

echo "🚀 Starte Wiederherstellung von LXC-Containern..."

for FILE in "$DUMP_DIR"/vzdump-lxc-*.tar.zst; do
  [[ -e "$FILE" ]] || continue
  CTID=$(basename "$FILE" | cut -d '-' -f 3)

  echo "📦 Restore von LXC $CTID..."
  pct restore "$CTID" "$FILE" \
    --storage "$STORAGE" \
    --net0 name=eth0,bridge=$BRIDGE,ip=dhcp
done

echo ""
echo "🚀 Starte Wiederherstellung von VMs..."

for FILE in "$DUMP_DIR"/vzdump-qemu-*.vma.zst; do
  [[ -e "$FILE" ]] || continue
  VMID=$(basename "$FILE" | cut -d '-' -f 3)

  echo "📦 Restore von VM $VMID..."
  qmrestore "$FILE" "$VMID" --storage "$STORAGE"
done

echo ""
echo "✅ Wiederherstellung abgeschlossen!"
