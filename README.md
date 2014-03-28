rendezvous-server
=================

Server for [rendezvous-socket](https://github.com/mikehale/rendezvous-socket)

## Heroku Deploy

```term
h create rendezvous-server
h sudo labs:enable keepalive
h sudo labs:enable http-proxy-peer-port
git push heroku master
```

## Usage

Terminal 1:
```term
id=$(uuidgen)
curl 'https://rendezvous-server.herokuapp.com?rendezvous-id=$id'
```

Terminal 2 (using the same id):
```term
curl 'https://rendezvous-server.herokuapp.com?rendezvous-id=$id'
```

## TODO

* force ssl
* sessions
