# README

## Note

🚨 **This was not yet tested!!** 🚨

## Running the Coturn Exporter

```bash
docker build -t coturn_exporter .
docker run -e IP=1.2.3.4 -e PORT=1234 -e SECRET=qwerty -e INTERVAL=600 -p 127.0.0.1:80:9524 coturn_exporter
```

All environment variables except `IP` are optional. `INTERVAL` (how many seconds to wait between checks) defaults to 900. `IP`, `PORT`, and `SECRET` refer to the TURN server to be checked.

Metrics are exported on port 9524 under `/metrics`. A response looks like this:

```
# TYPE is_turnserver_ok gauge
# HELP is_turnserver_ok Whether the TURN server is OK
is_turnserver_ok 1 2279953800.123456
# EOF
```
