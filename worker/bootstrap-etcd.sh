# Install needed packages
yum install -y wget vim curl
# Download etcd binaries
cd /usr/local/src
sudo wget "https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz"
sudo tar -xvf etcd-v3.3.9-linux-amd64.tar.gz
sudo mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/
# Prepare directories and users
sudo mkdir -p /etc/etcd /var/lib/etcd
sudo groupadd -f -g 1501 etcd
sudo useradd -c "etcd user" -d /var/lib/etcd -s /bin/false -g etcd -u 1501 etcd
sudo chown -R etcd:etcd /var/lib/etcd
# Prepare ip and hostname
ETCD_HOST_IP=$(sudo ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
ETCD_NAME=$(hostname -s)

# Create a configured systemd service
sudo bash -c "cat << EOF > /usr/lib/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/coreos/etcd

[Service]
User=etcd
Type=notify
ExecStart=/usr/local/bin/etcd \\
 --name ${ETCD_NAME} \\
 --data-dir /var/lib/etcd \\
 --initial-advertise-peer-urls http://${ETCD_HOST_IP}:2380 \\
 --listen-peer-urls http://${ETCD_HOST_IP}:2380 \\
 --listen-client-urls http://${ETCD_HOST_IP}:2379,http://127.0.0.1:2379 \\
 --advertise-client-urls http://${ETCD_HOST_IP}:2379 \\
 --initial-cluster-token etcd-cluster-1 \\
 --initial-cluster tcmalloc-storage-1=http://10.200.5.117:2380,tcmalloc-storage-2=http://10.200.5.104:2380,tcmalloc-storage-3=http://10.200.3.237:2380 \\
 --initial-cluster-state new \\
 --heartbeat-interval 1000 \\
 --election-timeout 5000
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"

# Bootstrap the cluster
systemctl daemon-reload
systemctl enable etcd
#systemctl start etcd.service
