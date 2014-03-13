require 'sinatra/base'
require 'redis'
require 'uri'

class RendezvousServer < Sinatra::Base
  @@redis = nil

  helpers do
    def peer_pair(env)
      forwarded_for = env["HTTP_X_FORWARDED_FOR"]
      forwarded_port = env["HTTP_X_FORWARDED_PORT"]
      socket = env["puma.socket"]

      [forwarded_for || socket.peeraddr[3], forwarded_port || socket.peeraddr[1]].join(":")
    end

    def redis
      unless @@redis
        uri = URI.parse(ENV['REDIS_URL'] || "localhost:6379")
        @@redis = Redis.new(:host => uri.host, :port => uri.port)
      end

      @@redis
    end
  end

  get '/' do
    addr = peer_pair(request.env)

    if (peers = redis.smembers("peers")).size > 0
      redis.srem("peers", peers)
      redis.sadd("peers", addr)
      puts "peer1: #{peers.first}"
      peers.first
    else
      redis.sadd("peers", addr)
      while (peers = redis.smembers("peers").reject{|e| e == addr }).empty?
        sleep 0.1
      end
      redis.srem("peers", peers)
      puts "peer2: #{peers.first}"
      peers.first
    end
  end
end
