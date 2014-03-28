require 'sinatra/base'
require 'sinatra/reloader'
require 'sequel'
require 'uri'

STDOUT.sync = true

class RendezvousServer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  @@pg = nil

  helpers do
    def peer_pair(env)
      forwarded_for = env["HTTP_X_FORWARDED_FOR"]
      forwarded_port = env["HTTP_X_FORWARDED_PEER_PORT"]
      socket = env["puma.socket"]

      [forwarded_for || socket.peeraddr[3], forwarded_port || socket.peeraddr[1]].join(":")
    end

    def database_url
      ENV["DATABASE_URL"] || "postgres://localhost/rendezvous-server"
    end

    def pg
      @@pg ||= Sequel.connect(database_url)
    end
  end

  get '/' do
    addr = peer_pair(request.env)
    client_id = [addr, params['client']].compact.join('_')
    channel = params['rendezvous-id'] || "post office"
    peer = nil

    notify_handler = proc {|conn|
      puts "#{client_id} notifying #{channel}"
      pg.notify channel, payload: client_id
    }

    pg.listen(channel, after_listen: notify_handler, loop: true) do |channel, pid, payload|
      puts "#{client_id} received #{payload} via #{channel}"

      if payload != client_id
        puts "#{client_id} saw peer #{payload}, so stopping listen loop"
        peer = payload
        break
      end
    end

    # TODO: how can we detect and not send the final extra notify from the second client?
    notify_handler.call(nil)

    peer.split('_')[0]
  end
end
