require 'ruby-mpd'
require 'conquer/mpd/version'

module Conquer
  module Mpd
    INSTANCES = Hash.new do |hash, key|
      hash[key] = MPD.new(*key).tap(&:connect)
    end
  end

  module Helpers
    module_function

    def mpd(*args)
      Mpd::INSTANCES[args]
    end

    def mpd_idle(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      host = args.any? ? args.join(':') : nil
      `mpc #{"-h #{host}" if host} idle #{options[:events].join(' ')}`
      yield mpd(*args)
    end
  end
end
