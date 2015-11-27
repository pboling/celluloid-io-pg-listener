module CelluloidIOPGListener
  module UnlistenWrappers
    module WithTermination

      def self.included(base)
        base.send(:include, CelluloidIOPGListener::Client)
      end

      def unlisten_wrapper(channel, payload, &block)
        if block_given?
          debug "Acting on payload: #{payload} on #{channel}"
          instance_eval(&block)
        else
          info "Not acting on payload: #{payload} on #{channel}"
        end
      rescue => e
        info "#{self.class}##{callback_method} disconnected from #{channel} via #{e.class} #{e.message}"
        unlisten(channel)
        terminate
        raise
      end

      def unlisten(channel)
        stop_listening
        pg_connection.exec(%[UNLISTEN "#{channel}";])
      end

    end
  end
end
