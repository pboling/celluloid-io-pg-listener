require "celluloid-io-pg-listener/version"
require "celluloid/current" # See https://github.com/celluloid/celluloid/wiki/DEPRECATION-WARNING
require "celluloid/io"
require "pg"

# Define the namespace this gem uses
module CelluloidIOPGListener; end

require "celluloid-io-pg-listener/client"
require "celluloid-io-pg-listener/server"
require "celluloid-io-pg-listener/listener"
