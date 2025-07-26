#!/bin/bash

mem_used_percent=$(awk '
        NR == 1 { mem_total=$2 }
        NR == 3 { mem_avail=$2 }
        END { mem_used = mem_total - mem_avail; print mem_used * 100 / mem_total }
' /proc/meminfo)

read -r cpu_total cpu_idle < <(awk '
        NR == 1 { cpu_total=$2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11 }
        NR == 1 { cpu_idle=$5 }
        END { print cpu_total, cpu_idle }
' /proc/stat)
cpu_total_prev=$cpu_total
cpu_idle_prev=$cpu_idle

sleep 1

read -r cpu_total cpu_idle < <(awk '
        NR == 1 { cpu_total=$2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11 }
        NR == 1 { cpu_idle=$5 }
        END { print cpu_total, cpu_idle }
' /proc/stat)
cpu_total_curr=$cpu_total
cpu_idle_curr=$cpu_idle

cpu_usage_percent=$(awk -v cpu_total_prev=$cpu_total_prev \
                -v cpu_idle_prev=$cpu_idle_prev \
                -v cpu_total_curr=$cpu_total_curr \
                -v cpu_idle_curr=$cpu_idle_curr '
        BEGIN {
                delta_total = cpu_total_curr - cpu_total_prev;
                delta_idle = cpu_idle_curr - cpu_idle_prev;
                if(delta_total == 0) {
                        print 0;
                        exit;
                }
                print 100 - (delta_idle * 100 / delta_total)
        }
')

printf '{ "mem_used_percent": %s, "cpu_usage_percent": %s }\n' "$mem_used_percent" "$cpu_usage_percent"