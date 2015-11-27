# Client for listening for notifications sent through postgresql.
module CelluloidIOPGListener
  module Client

    class InvalidClient < StandardError; end

    def self.included(base)
      base.send(:include, Celluloid::IO)
      base.send(:include, Celluloid::Internals::Logger)
      # order of prepended modules is critical if they are enhancing
      #   the same method(s), and they are.
      base.send(:prepend, CelluloidIOPGListener::Initialization::AsyncListener)
      base.send(:prepend, CelluloidIOPGListener::Initialization::ArgumentExtraction)
    end

    # Defining initialize in a class including this module is optional,
    #   unless you have custom args you need to handle
    #   aside from those used by the CelluloidIOPGListener::Client
    # But if you do define it, use a splat,
    #   hash or array splat should work,
    #   depending on your signature needs.
    # With either splat, only pass the splat params to super,
    #   and handle all your custom params locally.
    #
    def initialize(*args)
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

  end
end
