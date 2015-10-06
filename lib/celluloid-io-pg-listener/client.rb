# Client for listening for notifications sent through postgresql.
module CelluloidIOPGListener
  module Client

    def self.included(base)
      base.send(:include, Celluloid)
      base.send(:include, Celluloid::IO)
      base.send(:include, Celluloid::Internals::Logger)
    end

    def unlisten_wrapper(channel, payload, &block)
      info "Doing Something with Payload: #{payload} on #{channel}"
      instance_eval(&block)
    rescue => e
      info "#{self.class} disconnected from #{channel} via #{e.class} #{e.message}"
      unlisten(channel)
      terminate
    end

    def actions
      @actions ||= {}
    end

    def pg_connection
      @pg_connection ||= PG.connect( dbname: @dbname )
    end

    def notify(channel, value)
      pg_connection.exec("NOTIFY #{channel}, '#{value}';")
    end

    def listen(channel, action)
      actions[channel] = action
      pg_connection.exec("LISTEN #{channel}")
    end

    def start_listening
      info "Starting Listening"

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
      pg_connection.exec("UNLISTEN #{channel}")
    end

  end
end
