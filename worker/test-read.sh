curl -sS -X POST http://localhost:9003/query -d '{
  "namespace": "1week_namespace",
  "query": {
    "regexp": {
      "field": "city",
      "regexp": ".*"
    }
  },
  "rangeStart": 0,
  "rangeEnd": '"$(date "+%s")"'
}' | jq .
