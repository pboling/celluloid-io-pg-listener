class SimpleNotifyServerByInheritance

  def initialize(channel, run_interval: 1, sleep_interval: 0.1, payload:)
    Celluloid::IO::PG::Listener::Server.new(channel, run_interval: run_interval, sleep_interval: sleep_interval, payload: payload)
  end

end
