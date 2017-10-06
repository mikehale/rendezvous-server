require "spec_helper"
require 'timeout'

describe Rendezvous do
  let(:subject) { Rendezvous }
  let(:channel) { 'post office' }

  context :await_peer do
    it 'blocks until peer is ready' do
      Timeout::timeout(1) do
        t = Thread.new {
          expect(subject.await_peer(channel: channel, client_id: 'foo')).to eq('bar')
        }
        sleep 0.1 # force the listeners to be created at different times
        expect(subject.await_peer(channel: channel, client_id: 'bar')).to eq('foo')
        t.join
      end
    end

  end
end
