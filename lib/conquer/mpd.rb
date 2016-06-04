require 'ruby-mpd'
require 'conquer/mpd/version'

module Conquer
  module Helpers
    module_function

    def mpd(*args)
      @mpd_instances ||= {}
      @mpd_instances.fetch(args, MPD.new(*args).tap(&:connect))
    end

    def mpd_idle(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      `mpc #{"-h #{args.join(':')}" if args.any?} #{options[:events].join(' ')}`
      yield mpd(*args)
    end
  end
end
