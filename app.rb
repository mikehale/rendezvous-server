require 'sinatra'

set :peers, []

helpers do
  def peer_pair(socket)
    [socket.peeraddr[3], socket.peeraddr[1]].join(":")
  end
end

get '/' do
  # socket = request.env["puma.socket"]
  # puts peer_pair(socket)
  # peer_pair(socket)
  headers["X-Forwarded-Proto"]
end
