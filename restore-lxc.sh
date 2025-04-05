#!/bin/bash

# Speicherort der Backups auf dem neuen Server
DUMP_DIR="/var/lib/vz/dump"
STORAGE="local-lvm"
BRIDGE="vmbr0"
GATEWAY="172.16.16.1"

# Container-Infos: ID → IP
declare -A CONTAINERS=(
  [100]="172.16.16.155"
  [103]="172.16.16.146"
  [104]="172.16.16.80"
  [113]="172.16.16.29"
)

echo "🚀 Starte Restore der Container mit statischer IP..."

for ID in "${!CONTAINERS[@]}"; do
  IP="${CONTAINERS[$ID]}"
  BACKUP_FILE=$(ls -t "$DUMP_DIR"/vzdump-lxc-"$ID"-*.tar.zst 2>/dev/null | head -n1)

  if [[ -f "$BACKUP_FILE" ]]; then
    echo "📦 Restoring Container $ID mit IP $IP..."
    pct restore "$ID" "$BACKUP_FILE" \
      --storage "$STORAGE" \
      --net0 name=eth0,bridge=$BRIDGE,ip=${IP}/24,gw=$GATEWAY
  else
    echo "⚠️  Kein Backup für Container $ID gefunden!"
  fi
done

echo "✅ Restore abgeschlossen!"
