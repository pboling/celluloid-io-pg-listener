class SimpleListenClient

  include CelluloidIOPGListener::Client

  def initialize(dbname:, channel:)
    info "Client will for notifications on #{dbname}:#{channel}"
    @dbname = dbname
    async.start_listening
    async.listen(channel, :do_something)
  end

  def do_something(channel, payload)
    unlisten_wrapper(channel, payload) do
      info payload
    end
  end

end
