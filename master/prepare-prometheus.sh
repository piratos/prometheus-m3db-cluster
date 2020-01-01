# Download prom binaries
cd /usr/local/src
wget https://github.com/prometheus/prometheus/releases/download/v2.15.1/prometheus-2.15.1.linux-amd64.tar.gz
sudo tar -xvf prometheus-2.15.1.linux-amd64.tar.gz
sudo mv prometheus-2.15.1.linux-amd64/{prometheus,promtool,tsdb} /usr/local/bin

# Prepare directories and users
sudo mkdir /etc/prometheus /var/lib/prometheus
sudo groupadd -f -g 1504 prom
sudo useradd -c "prom user" -d /var/lib/prometheus -s /bin/false -g prom -u 1504 prom
sudo chown -R prom:prom /var/lib/prometheus
cp /root/prometheus-m3db-cluster/master/prometheus-config.yaml /etc/prometheus/prometheus-config.yaml

# Tune kernel
sudo sysctl -w fs.file-max=3000000
sudo sysctl -w fs.nr_open=3000000
sudo sysctl vm.max_map_count=3000000

# Create a configured systemd service
sudo bash -c "cat << EOF > /usr/lib/systemd/system/prometheus.service
[Unit]
After=network.target
Description=prometheus server
Documentation=http://prometheus.io

[Service]
User=prom
Type=simple
ExecStart=/usr/local/bin/prometheus \\
          --config.file /etc/prometheus/prometheus-config.yaml \\
          --web.listen-address=0.0.0.0:9090 \\
          --storage.tsdb.path=/var/lib/prometheus
Restart=on-failure
RestartSec=10
SuccessExitStatus=0
LimitNOFILE=3000000

[Install]
WantedBy=multi-user.target
EOF"

# Apply services
sudo systemctl daemon-reload
sudo systemctl enable prometheus
