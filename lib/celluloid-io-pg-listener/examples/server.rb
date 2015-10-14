# Simple example of a server for sending notifications through postgresql that can be listened for.
module CelluloidIOPGListener
  module Examples
    class Server

      include Celluloid
      include Celluloid::IO
      include Celluloid::Internals::Logger
      prepend CelluloidIOPGListener::Initialization::ArgumentExtraction

      def initialize(*args)
        info "Server will send notifications to #{dbname}:#{channel}"
      end

      # Defaults:
      #   1/10th of a second sleep intervals
      #   1 second run intervals
      def start(run_interval: 1, sleep_interval: 0.1)
        @sleep_interval = sleep_interval
        @run_interval = run_interval
        async.run
      end

      def run
        now = Time.now.to_f
        sleep now.ceil - now + @sleep_interval
        # There is no way to pass anything into the block, which is why this server isn't all that useful.
        # The client is intended to listen to notifications coming from other sources,
        #   like a PG TRIGGER than sends a notification on INSERT, for example.
        every(@run_interval) { ping }
      end

      # Helps with testing by making the notify synchronous.
      def ping
        notify(channel, Time.now.to_i)
        info "Notified #{channel}"
      end

      private

      def pg_connection
        @pg_connection ||= PG.connect(conninfo_hash)
      end

      def notify(channel, value)
        pg_connection.exec("NOTIFY #{channel}, '#{value}';")
      end

    end
  end
end
