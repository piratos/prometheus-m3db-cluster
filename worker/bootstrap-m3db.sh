curl -X POST http://localhost:7201/api/v1/database/create -d '{
  "type": "cluster",
  "namespaceName": "1week_namespace",
  "retentionTime": "168h",
  "numShards": "1024",
  "replicationFactor": "3",
  "hosts": [
        {
            "id": "worker1",
            "isolationGroup": "zone1",
            "zone": "embedded",
            "weight": 100,
            "address": "10.0.0.11",
            "port": 9000
        },
        {
            "id": "worker2",
            "isolationGroup": "zone2",
            "zone": "embedded",
            "weight": 100,
            "address": "10.0.0.12",
            "port": 9000
        },
        {
            "id": "worker3",
            "isolationGroup": "zone3",
            "zone": "embedded",
            "weight": 100,
            "address": "10.0.0.13",
            "port": 9000
        }
    ]
}'
