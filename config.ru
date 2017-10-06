Bundler.require(:default, ENV['RACK_ENV'])
require_relative './app'

run RendezvousServer
