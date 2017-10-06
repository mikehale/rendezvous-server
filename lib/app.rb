require 'sinatra/base'
require 'sinatra/reloader'
require 'sequel'
require 'uri'
require 'rack/ssl'

STDOUT.sync = true

class RendezvousServer < Sinatra::Base
  configure :production do
    use Rack::SSL
  end

  configure :development do
    register Sinatra::Reloader
    also_reload './rendezvous.rb'
  end

  helpers do
    def peer_pair(env)
      forwarded_for = env["HTTP_X_FORWARDED_FOR"]
      forwarded_port = env["HTTP_X_FORWARDED_PEER_PORT"]
      socket = env["puma.socket"]

      [forwarded_for || socket.peeraddr[3], forwarded_port || socket.peeraddr[1]].join(":")
    end

  end

  get '/' do
    addr = peer_pair(request.env)
    client_id = [addr, params['client']].compact.join('_')
    channel = params['rendezvous-id'] || "post office"
    peer = Rendezvous.await_peer(channel: channel, client_id: client_id)

    # Respond to http request with peer TCP endpoint. This allows the
    # clients to know about each other, and attempt to establish a
    # direct P2P connection.
    peer.split('_')[0]
  end
end
