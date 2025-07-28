#!/bin/bash
# Run monitor.sh every 5 minutes
(crontab -l 2>/dev/null; echo "*/5 * * * * $HOME/linux-resource-monitor/monitor.sh") | crontab -
