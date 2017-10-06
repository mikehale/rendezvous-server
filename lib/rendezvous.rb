class Rendezvous
  class << self
    def database_url
      ENV["DATABASE_URL"] || "postgres://localhost/rendezvous-server"
    end

    def database
      @pg ||= Sequel.connect(database_url)
    end

    def await_peer(channel:, client_id:)
      peer = nil

      notify_channel = proc {|conn|
        puts "#{client_id} notifying #{channel}"
        database.notify(channel, payload: client_id)
      }

      database.listen(channel, after_listen: notify_channel, loop: true) do |c, pid, payload|
        puts "#{client_id} received #{payload} via #{c}"

        if payload != client_id
          puts "#{client_id} saw peer #{payload}, so stopping listen loop"
          peer = payload
          break
        end
      end

      # The second client to connect is not notified of the first
      # client that connected, since it wasn't listening yet.
      notify_channel.call(nil)

      peer
    end
  end
end
