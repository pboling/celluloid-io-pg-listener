require "celluloid-io-pg-listener/version"
require "celluloid/current" # See https://github.com/celluloid/celluloid/wiki/DEPRECATION-WARNING
require "celluloid/io"
require "pg"

# Define the namespace this gem uses
module CelluloidIOPGListener; end

require "celluloid-io-pg-listener/initialization/client_extracted_signature"
require "celluloid-io-pg-listener/initialization/argument_extraction"
require "celluloid-io-pg-listener/initialization/async_listener"
require "celluloid-io-pg-listener/client"
# Require manually, as in bin/console, if you want to try them out.
# require "celluloid-io-pg-listener/examples/client"
# require "celluloid-io-pg-listener/examples/server"
# require "celluloid-io-pg-listener/examples/listener_client_by_inheritance"
# require "celluloid-io-pg-listener/examples/notify_server_by_inheritance"
