# Download m3db binaries
cd /usr/local/src
sudo wget "https://github.com/m3db/m3/releases/download/v0.14.2/m3_0.14.2_linux_amd64.tar.gz"
sudo tar -xvf m3_0.14.2_linux_amd64.tar.gz
sudo mv m3_0.14.2_linux_amd64/m3dbnode /usr/local/bin

# Prepare directories and users
sudo mkdir /etc/m3db /var/lib/m3db /var/lib/m3kv
sudo groupadd -f -g 1502 m3db
sudo useradd -c "m3db user" -d /var/lib/m3db -s /bin/false -g m3db -u 1502 m3db
sudo chown -R m3db:m3db /var/lib/m3db /var/lib/m3kv
cp m3db-config.yaml /etc/m3db/m3db-config.yaml

# Tune kernel
sudo sysctl -w fs.file-max=3000000
sudo sysctl -w fs.nr_open=3000000
sudo sysctl vm.max_map_count=3000000

# Create a configured systemd service
sudo bash -c "cat << EOF > /usr/lib/systemd/system/m3dbnode.service
[Unit]
After=network.target
Description=M3DB Timeseries Database
Documentation=http://m3db.github.io/m3/

[Service]
User=m3db
Type=simple
ExecStart=/usr/local/bin/m3dbnode -f /etc/m3db/m3db-config.yaml
Restart=on-failure
RestartSec=10
SuccessExitStatus=0
LimitNOFILE=3000000

[Install]
WantedBy=multi-user.target
EOF"

# Apply services
sudo systemctl daemon-reload
sudo systemctl enable m3db
