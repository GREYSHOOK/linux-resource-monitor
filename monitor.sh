#!/bin/bash

# Thresholds
CPU_THRESHOLD=75
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# Email address for alerts
EMAIL="your_email@example.com"

# Timestamp
TIMESTAMP=$(date)

# System usage data
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Log output
LOG_LINE="$TIMESTAMP CPU: $CPU_USAGE% MEM: $MEM_USAGE% DISK: $DISK_USAGE%"
echo "$LOG_LINE" >> $HOME/linux-resource-monitor/report.log

# Alert message
ALERT_MSG=""
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
  ALERT_MSG+="High CPU usage: $CPU_USAGE%\n"
fi
if (( MEM_USAGE > MEM_THRESHOLD )); then
  ALERT_MSG+="High Memory usage: $MEM_USAGE%\n"
fi
if (( DISK_USAGE > DISK_THRESHOLD )); then
  ALERT_MSG+="High Disk usage: $DISK_USAGE%\n"
fi

# Send email if needed
if [[ $ALERT_MSG != "" ]]; then
  echo -e "$ALERT_MSG\n\nTimestamp: $TIMESTAMP" | mail -s "⚠️ Linux Resource Alert" $EMAIL
fi

# Upload log to S3 (with timestamped filename)
aws s3 cp "$HOME/linux-resource-monitor/report.log" \
  s3://linux-monitoring-logs-kyle/report-$(date +%Y-%m-%d_%H%M).log \
  --region us-east-1
