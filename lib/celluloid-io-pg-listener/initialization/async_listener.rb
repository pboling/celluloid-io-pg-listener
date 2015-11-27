module CelluloidIOPGListener
  # Prepended to classes including the CelluloidIOPGListener::Client
  module Initialization
    module AsyncListener

      # 2nd initialize override invoked
      # @callback_method  - Name of the method to be called when notifications are heard
      #                     Default: :unlisten_wrapper (just to have a guaranteed method with the correct arity)
      def initialize(*args)
        hash_arg = args.last.is_a?(Hash) ? args.pop : {}
        warn "[#{self.class}] You have not specified a callback_method, so :unlisten_wrapper will be used." unless hash_arg[:callback_method]
        @callback_method = hash_arg[:callback_method] = hash_arg[:callback_method] || :unlisten_wrapper
        # Doesn't appear to be any other way to make it work with subclassing,
        #   due to the way Celluloid Proxies the class, and hijacks the inheritance chains
        subclassed_client = hash_arg[:subclassed_client] = hash_arg[:subclassed_client] || false
        args << hash_arg

        enhance_callback_method unless @callback_method == :unlisten_wrapper

        # When called from a sub-class of a class including Client
        #   and the sub-class overrides initialize,
        #   then the execution order changes,
        #   and this method may no longer have a super.
        # However, due to the nature of the initialize method we can't tell if we have a legitimate super or not.
        super(*args) if !subclassed_client

        debug "Listening for notifications on #{dbname}:#{channel} with callback to #{@callback_method}"
        async.start_listening
        async.listen(channel, @callback_method)
      end

      def callback_method
        @callback_method
      end

      private

      def enhance_callback_method
        # The class including CelluloidIOPGListener::Client must define
        #   the method named by @callback_method
        define_singleton_method(@callback_method) do |channel, payload|
          unlisten_wrapper(channel, payload) do
            if defined?(super)
              super(channel, payload)
            else
              error "LISTENER ERROR: #{payload}"
              if callback_method == :unlisten_wrapper
                raise CelluloidIOPGListener::Client::InvalidClient, "Please specify a callback_method with signature (channel, payload) to be called on an instance of #{self.class}"
              else
                raise CelluloidIOPGListener::Client::InvalidClient, "#{self.class} does not define a method :#{callback_method} with signature (channel, payload)"
              end
            end
          end
        end
      end

    end
  end
end
