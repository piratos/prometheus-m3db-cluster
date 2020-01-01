curl -X POST http://localhost:7201/api/v1/database/create -d '{
  "type": "cluster",
  "namespaceName": "test",
  "retentionTime": "168h",
  "numShards": "64",
  "replicationFactor": "3",
  "hosts": [
        {
            "id": "tcmalloc-storage-1",
            "isolationGroup": "group1",
            "zone": "embedded",
            "weight": 100,
            "address": "10.200.5.117",
            "port": 9000
        },
        {
            "id": "tcmalloc-storage-2",
            "isolationGroup": "group2",
            "zone": "embedded",
            "weight": 100,
            "address": "10.200.5.104",
            "port": 9000
        },
        {
            "id": "tcmalloc-storage-3",
            "isolationGroup": "group3",
            "zone": "embedded",
            "weight": 100,
            "address": "10.200.5.237",
            "port": 9000
        }
    ]
}'
