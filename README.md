rendezvous-server
=================

Server for [rendezvous-socket](https://github.com/mikehale/rendezvous-socket)

## Heroku Deploy

```term
h create rendezvous-server
h labs:enable keepalive
h labs:enable http-proxy-peer-port
h addons:add heroku-postgresql:crane
git push heroku master
h run bin/migrate
```

## TODO

* force ssl
* sessions
* run as heroku app (requires https://github.com/heroku/mochiweb/pull/6/files)
