# Linux Resource Monitor

A Bash-based system monitoring tool that:
- Logs CPU, memory, and disk usage
- Sends email alerts if thresholds are exceeded
- Uploads logs to AWS S3 for storage
- Runs automatically every 5 minutes via `cron`

Tested on an EC2 instance (Ubuntu). Uses AWS CLI and `mailutils`.
