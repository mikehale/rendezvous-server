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

## TODO

* force ssl
* sessions
* run as heroku app (requires https://github.com/heroku/mochiweb/pull/6/files)
