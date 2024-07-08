# Coturn Exporter

Tests whether TURN servers are working and exports the result as a Prometheus metric

## How to Run It

```bash
docker build -t coturn_exporter .
echo 'ip: 1.2.3.4' > config  # Replace with your TURN server's IP; see below for port, secret, and more
docker run \
  --mount type=bind,src="$(pwd)"/config,dst=/coturn_exporter_files/config,readonly \
  -p 127.0.0.1:80:9524 coturn_exporter
```

## The Configuration File

You must mount a configuration file into the container at `/coturn_exporter_files/config` to specify the TURN server(s) to be checked and optionally other settings. Its format is YAML.

### `ip`, `port`, and `secret`

If you have only one TURN server to check, you can specify its IP and optionally its port and/or secret at the root level of the config file.

```yaml
ip: 1.2.3.4
port: 1234
secret: qwerty
```

If no port is specified, 3478 is assumed.

### `turn_servers`

It is possible to specify more than one TURN server with the `turn_servers` key.

```yaml
turn_servers:
  - ip: 1.2.3.4
    port: 1234
    secret: qwerty
  - ip: 9.8.7.6
    port: 9876
    secret: asdf
```

You must use exactly one of `turn_servers` and `ip` \[+ `port`] \[+ `secret`] at the root level.

### `interval`

The optional key `interval` specifies the wait time between checks of each TURN server in seconds. It defaults to 900.

```yaml
interval: 333.33
```

### `loglevel`

The optional key `loglevel` specifies the verbosity of the Coturn Exporter. It can be one of `DEBUG`, `INFO`, `WARNING`, `ERROR`, or `CRITICAL` and defaults to `WARNING`.

```yaml
loglevel: INFO
```

### A Complete Example

```yaml
---
loglevel: INFO
interval: 333.33
turn_servers:
  - ip: 1.2.3.4
    port: 1234
    secret: qwerty
  - ip: 9.8.7.6
    port: 9876
    secret: asdf
...
```

## Output

Metrics are exported on port 9524. They will look like the following (plus some metrics added by the [Prometheus Python client](https://github.com/prometheus/client_python)):

```
# HELP turnserver_state the state of the TURN server
# TYPE turnserver_state gauge
turnserver_state{host="1.2.3.4:1234",turnserver_state="ok"} 1.0
turnserver_state{host="1.2.3.4:1234",turnserver_state="not_ok"} 0.0
turnserver_state{host="1.2.3.4:1234",turnserver_state="unknown"} 0.0
turnserver_state{host="9.8.7.6:9876",turnserver_state="ok"} 0.0
turnserver_state{host="9.8.7.6:9876",turnserver_state="not_ok"} 1.0
turnserver_state{host="9.8.7.6:9876",turnserver_state="unknown"} 0.0
```
