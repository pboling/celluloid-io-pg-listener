module CelluloidIOPGListener
  module Initialization
    #
    # Null Object Pattern, just in case there are no options passed to initialize
    #
    # @conninfo_hash    - Extracted (actually removed!) PG database connection options, such as would be sent to:
    #                       PG.connect( *args ) # PG::Connection.new( *args )
    #                     Options must be the same named parameters that PG.connect() expects in its argument hash
    #                     The other parameter formats are accepted by PG::Connection.new are not supported here.
    #                     Named after, and structurally identical to, PG::Connection#conninfo_hash
    # @super_signature  - Arguments passed on to super, supports any type of argument signature / arity supported by Ruby itself.
    # @channel          - The channel to listen to notifications on
    #                     Default: None, raises an error if not provided.
    #
    class ClientExtractedSignature

      # see http://deveiate.org/code/pg/PG/Connection.html for key meanings
      KEYS = [:host, :hostaddr, :port, :dbname, :user, :password, :connect_timeout, :options, :tty, :sslmode, :krbsrvname, :gsslib, :service]

      attr_reader :super_signature
      attr_reader :conninfo_hash
      attr_reader :channel

      # args - an array
      def initialize(*args)
        hash_arg = args.last.is_a?(Hash) ? args.pop : {}
        # Extract the channel first, as it is required
        @channel = hash_arg.delete(:channel) || raise(ArgumentError, "[#{self.class}] :channel is required, but got #{args} and #{hash_arg}")
        # Extract the args for PG.connect
        @conninfo_hash = (hash_arg.keys & KEYS).
          each_with_object({}) { |k,h| h.update(k => hash_arg.delete(k)) }.
          # Future proof. Provide a way to send in any PG.connect() options not explicitly defined in KEYS
          merge(hash_arg.delete(:conninfo_hash) || {})
        # Add any other named parameters back to the args for super
        args << hash_arg unless hash_arg.empty?
        @super_signature = args
      end

    end
  end
end
