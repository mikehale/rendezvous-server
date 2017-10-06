Bundler.require(:default, ENV['RACK_ENV'])
#$:.unshift File.expand_path(".")

# atomic puts
def puts(string)
  print "#{string}\n"
end

require_relative './rendezvous'
require_relative './app'
