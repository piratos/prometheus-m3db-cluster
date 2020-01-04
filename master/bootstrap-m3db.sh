curl -X POST http://localhost:7201/api/v1/database/create -d '{
  "type": "cluster",
  "namespaceName": "test",
  "retentionTime": "168h",
  "numShards": "64",
  "replicationFactor": "3",
  "hosts": [
        {
            "id": "worker1",
            "isolationGroup": "group1",
            "zone": "embedded",
            "weight": 100,
            "address": "10.10.5.10",
            "port": 9000
        },
        {
            "id": "worker2",
            "isolationGroup": "group2",
            "zone": "embedded",
            "weight": 100,
            "address": "10.10.5.11",
            "port": 9000
        },
        {
            "id": "worker3",
            "isolationGroup": "group3",
            "zone": "embedded",
            "weight": 100,
            "address": "10.10.5.13",
            "port": 9000
        }
    ]
}'
