# Coturn Exporter

Tests whether a given TURN server is working and exports the result as a Prometheus metric

## How to Run It

```bash
docker build -t coturn_exporter .
docker run -e IP=1.2.3.4 -e PORT=1234 -e SECRET=qwerty -e INTERVAL=600 -p 127.0.0.1:80:9524 coturn_exporter
```

All environment variables except `IP` are optional. `INTERVAL` (how many seconds to wait between checks) defaults to 900. `IP`, `PORT`, and `SECRET` refer to the TURN server to be checked.

## Output

Metrics are exported on port 9524. They will include something like the following (plus some metrics added by the [Prometheus Python client](https://github.com/prometheus/client_python)):

```
# HELP turn_server_state the state of the TURN server
# TYPE turn_server_state gauge
turn_server_state{turn_server_state="ok"} 1.0
turn_server_state{turn_server_state="unreachable"} 0.0
turn_server_state{turn_server_state="unknown"} 0.0
```
