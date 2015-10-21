module CelluloidIOPGListener
  # Prepended to classes including the CelluloidIOPGListener::Client
  # Extracts the arguments relevant to the CelluloidIOPGListener::Client module
  # Leaves the rest of the arguments to be passed to the
  #   initializer of classes including the CelluloidIOPGListener::Client
  module Initialization
    module ArgumentExtraction

      # 1st initialize override invoked
      def initialize(*args)
        @client_extracted_signature = CelluloidIOPGListener::Initialization::ClientExtractedSignature.new(*args)
        super(*@client_extracted_signature.super_signature)
      end

      def dbname
        conninfo_hash[:dbname]
      end

      def channel
        @client_extracted_signature.channel
      end

      def conninfo_hash
        @client_extracted_signature.conninfo_hash
      end

    end
  end
end
