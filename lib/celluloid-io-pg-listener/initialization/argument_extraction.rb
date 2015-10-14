module CelluloidIOPGListener
  # Prepended to classes including the CelluloidIOPGListener::Client
  # Takes the arguments relevant to the CelluloidIOPGListener::Client module
  #   and extracts it leaving the rest of the arguments to be passed to the
  #   initializer of classes including the CelluloidIOPGListener::Client
  module Initialization
    module ArgumentExtraction

      def initialize(*args)
        puts "IN ArgumentExtraction #{args.inspect}"
        @client_extracted_signature = CelluloidIOPGListener::Initialization::ClientExtractedSignature.new(*args)
        # When called from a sub-class of a class including Client
        #   and the sub-class overrides initialize,
        #   then the execution order changes,
        #   and this method may no longer have a super.
        # However, due to the nature of the initialize method we can't tell if we have a legitimate super or not.
        super(*@client_extracted_signature.super_signature) if defined?(super)
        puts "OUT ArgumentExtraction"
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
