require 'sinatra/base'
require 'pg'
require 'uri'

STDOUT.sync = true

class RendezvousServer < Sinatra::Base
  @@pg = nil

  helpers do
    def peer_pair(env)
      forwarded_for = env["HTTP_X_FORWARDED_FOR"]
      forwarded_port = env["HTTP_X_FORWARDED_PEER_PORT"]
      socket = env["puma.socket"]

      [forwarded_for || socket.peeraddr[3], forwarded_port || socket.peeraddr[1]].join(":")
    end

    def pg
      @@pg ||= PG.connect(ENV['DATABASE_URL'] | "postgres://localhost/rendezvous-server")
    end
  end

  get '/' do
    addr = peer_pair(request.env)
    puts addr.inspect

    # if (peers = redis.smembers("peers")).size > 0
    #   redis.srem("peers", peers)
    #   redis.sadd("peers", addr)
    #   puts "peer1: #{peers.first}"
    #   peers.first
    # else
    #   redis.sadd("peers", addr)
    #   while (peers = redis.smembers("peers").reject{|e| e == addr }).empty?
    #     sleep 0.1
    #   end
    #   redis.srem("peers", peers)
    #   puts "peer2: #{peers.first}"
    #   peers.first
    # end

    ''
  end
end
