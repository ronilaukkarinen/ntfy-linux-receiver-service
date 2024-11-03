# ntfy.sh Listener Service for Linux

This simple script listens for ntfy notifications and displays them as desktop notifications on Linux. It is intended to be run as a systemd service in the background.

![Screenshot from 2024-11-03 21-55-33](https://github.com/user-attachments/assets/ac9677f4-2b7b-4a5a-ab07-75de730264ec)

## Prequisites

Ensure you have `curl`, `jq`, and `notify-send` installed on your system.

Download the logo from the ntfy documentation to use in the notifications:

```bash
wget -O /path/to/ntfy.png https://docs.ntfy.sh/static/img/ntfy.png
```

Replace /path/to/ntfy.png in the script with the actual path where you saved the logo image.

Save the script and make it as executable.

```bash
sudo chmod +x /usr/local/bin/ntfy-listener.sh
```

## Create the systemd service file

Create a systemd service to automatically start the listener on boot. Create the service file /etc/systemd/system/ntfy-listener.service, remember to replace my user name with your username:

```ini
[Unit]
Description=Ntfy Listener Service
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/ntfy-listener.sh
Restart=on-failure
RestartSec=10
User=rolle
Environment=DISPLAY=:0
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl enable ntfy-listener.service --now
```

The service will now automatically start on boot and display notifications from the configured ntfy channels.

If you need to add more channels, simply update the NTFY_URLS array in the script.
