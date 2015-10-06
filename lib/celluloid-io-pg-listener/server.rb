# Simple example of a server for sending notifications through postgresql that can be listened for.
class CelluloidIOPGListener::Server

  include Celluloid
  include Celluloid::IO
  include Celluloid::Internals::Logger

  # Defaults:
  #   1/10th of a second sleep intervals
  #   1 second run intervals
  def initialize(dbname:, channel:, run_interval: 1, sleep_interval: 0.1)
    info "Server will send notifications to #{dbname}:#{channel}"
    @dbname = dbname
    @channel = channel
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
    every(@run_interval) { notify(@channel, Time.now.to_i) }
    info "Notified #{@channel}"
  end

  def pg_connection
    @pg_connection ||= PG.connect( dbname: @dbname )
  end

  def notify(channel, value)
    pg_connection.exec("NOTIFY #{channel}, '#{value}';")
  end

end
