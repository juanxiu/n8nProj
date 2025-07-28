#!/bin/bash

export LANG=C
OUT_PATH="$HOME/myscripts.json"
DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(top -bn1 | awk -F',' '/Cpu\(s\)/ {gsub(" ", "", $4); split($4, a, "id"); print 100 - a[1]}')
MEM_USAGE=$(free | awk '/Mem:/ {print ($3/$2)*100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

cat <<EOF > "$OUT_PATH"
{
    "datetime": "$DATETIME",
    "cpu_usage": $CPU_USAGE,
    "mem_usage": $MEM_USAGE,
    "disk_usage": $DISK_USAGE
}
EOF

echo "Metrics written to $OUT_PATH"
