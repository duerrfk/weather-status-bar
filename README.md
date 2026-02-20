Weather information for i3status bar using the Open Meteo weather service.

# Script

The script queries periodically (triggered by a cron job) and at boot time (triggered by systemd) the Open Meteo service for the current temperature and weather code.

The weather code is translated to a descriptive text.

Unicode icons are added, e.g., available through Nerd Fonts.

The output is written as a single line to the file `/tmp/weather_status_bar` and read from there periodically by the i3status bar. 

See script for further details.

# Invoke script as cron job

Add cron job:

```
$ crontab -e
```

To invoke the script every 15 minutes, add the following line:

```
0,15,30,45 * * * * /home/username/local/bin/weather-bar.sh > /dev/null 2>&1
```

To invoke the script at boot time (after the network is available) using systemd:

```ini
[Unit]
Description=Create weather status bar line, suitable for i3status.
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/home/username/local/bin/weather-bar.sh
User=username
Group=usergroup
WorkingDirectory=/tmp                

[Install]
WantedBy=multi-user.target

```

# Configuration of i3status bar

Add the following lines to the config file (e.g., `.config/i3status/config`):

```
order += "read_file weather"

read_file weather {
	path = "/tmp/weather_status_bar"
}
```

This file will be visited periodically, as defined by the `interval` parameter of i3status (e.g., every second; note that the weather is queried from the web service at much lower rate).
