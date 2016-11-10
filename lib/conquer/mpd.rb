require 'ruby-mpd'
require 'celluloid/current'
require 'celluloid/notifications'
require 'conquer/mpd/version'

module Conquer
  module Mpd
    INSTANCES = Hash.new do |hash, key|
      hash[key] = MPD.new(*key).tap(&:connect)
    end

    class Listener
      include Celluloid
      include Celluloid::Notifications

      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        @host = args.any? ? args.join(':') : nil
        @mpd = INSTANCES[args]
        @events = options[:events]
        async.run
      end

      def run
        publish(:mpd, @mpd)
        loop do
          `mpc #{"-h #{@host}" if @host} idle #{@events.join(' ')}`
          publish(:mpd, @mpd)
        end
      end
    end
  end

  module Helpers
    module_function

    def mpd(*args)
      Mpd::INSTANCES[args]
    end
  end
end
