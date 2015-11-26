require "celluloid-io-pg-listener/version"
require "celluloid/current" # See https://github.com/celluloid/celluloid/wiki/DEPRECATION-WARNING
require "celluloid/io"
require "pg"

# Define the namespace this gem uses
module CelluloidIOPGListener

  # Redefining this constant would allow you to set whatever unlisten wrapper you want
  UNLISTEN_WRAPPER_TYPE = {
      unlisten_wrapper_with_termination: "CelluloidIOPGListener::UnlistenWrappers::WithTermination",
      unlisten_wrapper_without_termination: "CelluloidIOPGListener::UnlistenWrappers::WithoutTermination"
  }

  # Returns a module
  # Usage:
  #
  #   class MyClient
  #     include CelluloidIOPGListener.client(:unlisten_wrapper_with_termination) # with no argument this is default
  #   end
  #
  # For a Client that will be used inside a SupervisorContainer you want to let the Supervisor handle termination.
  #   At least that's my operating hypothesis, if anyone knows better please let me know.
  #
  #   class MyClient
  #     include CelluloidIOPGListener.client(:unlisten_wrapper_without_termination)
  #   end
  #
  def self.client(unlisten_wrapper_type = :unlisten_wrapper_with_termination)
    wrapper = UNLISTEN_WRAPPER_TYPE[unlisten_wrapper_type]
    puts "unlisten wrapper: #{wrapper},\nunlisten_wrapper_type: #{unlisten_wrapper_type},\ncaller: #{caller.first}"
    Kernel.const_get(wrapper)
  end

end

require "celluloid-io-pg-listener/initialization/client_extracted_signature"
require "celluloid-io-pg-listener/initialization/argument_extraction"
require "celluloid-io-pg-listener/initialization/async_listener"
require "celluloid-io-pg-listener/client"
require "celluloid-io-pg-listener/unlisten_wrappers/with_termination"
require "celluloid-io-pg-listener/unlisten_wrappers/without_termination"

# Require in your executable script that runs your supervisor.  See bin/supervisor as an example.
# require "celluloid-io-pg-listener/supervision_configuration_signature"

# Require manually, as in bin/console, if you want to try them out.
# require "celluloid-io-pg-listener/examples/client"
# require "celluloid-io-pg-listener/examples/double_super_example"
# require "celluloid-io-pg-listener/examples/server"
# require "celluloid-io-pg-listener/examples/listener_client_by_inheritance"
# require "celluloid-io-pg-listener/examples/notify_server_by_inheritance"
