# Client for listening for notifications sent through postgresql.
module CelluloidIOPGListener
  module Client

    class InvalidClient < StandardError; end

    def self.included(base)
      base.send(:include, Celluloid::IO)
      base.send(:include, Celluloid::Internals::Logger)
      # order of prepended modules is critical if they are enhancing
      #   the same method(s), and they are.
      base.prepend CelluloidIOPGListener::Initialization::AsyncListener
      base.prepend CelluloidIOPGListener::Initialization::ArgumentExtraction
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
      # Rescue the error in a daemon-error-reporter to send to Airbrake or other reporting service?
      raise
    end

    def actions
      @actions ||= {}
    end

    def pg_connection
      @pg_connection ||= PG.connect(conninfo_hash)
    end

    # Supported channel names are any delimited (double-quoted) identifier:
    # We supply the double quotes, you supply the contents.
    # If you want unicode character code support submit a pull request to make the quote style `U&"` a config setting.
    #   See: http://www.postgresql.org/docs/9.4/static/sql-syntax-lexical.html
    def listen(channel, action)
      actions[channel] = action
      pg_connection.exec(%[LISTEN "#{channel}";])
    end

    def start_listening
      @listening = true
      wait_for_notify do |channel, pid, payload|
        info "Received notification: #{[channel, pid, payload].inspect}"
        send(actions[channel], channel, payload)
      end
    end

    def stop_listening
      @listening = false
    end

    def wait_for_notify(&block)
      io = pg_connection.socket_io

      while @listening do
        Celluloid::IO.wait_readable(io) # blocks execution, but unblocks this actor
        pg_connection.consume_input # fetch any input on this connection

        while notification = pg_connection.notifies do
          block.call(*[
                         notification[:relname], # channel
                         notification[:be_pid], # pid
                         notification[:extra] # payload
                     ])
        end
      end
    end

    def unlisten(channel)
      # (@listening ||= {})[channel] = false
      stop_listening # Not sure if there is a way to stop listening to a single channel without affecting the others.
      pg_connection.exec(%[UNLISTEN "#{channel}";])
    end

  end
end
