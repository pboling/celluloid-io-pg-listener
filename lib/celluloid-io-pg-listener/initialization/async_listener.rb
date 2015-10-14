module CelluloidIOPGListener
  # Prepended to classes including the CelluloidIOPGListener::Client
  module Initialization
    module AsyncListener

      # @callback_method  - Name of the method to be called when notifications are heard
      #                     Default: :unlisten_wrapper (just to have a guaranteed method with the correct arity)
      def initialize(*args)
        puts "IN AsyncListener #{args.inspect}"
        hash_arg = args.last.is_a?(Hash) ? args.pop : {}
        warn "[#{self.class}] You have not specified a callback_method, so :unlisten_wrapper will be used." unless hash_arg[:callback_method]
        @callback_method = hash_arg.delete(:callback_method) || :unlisten_wrapper
        args << hash_arg unless hash_arg.empty?

        info "Listening for notifications on #{dbname}:#{channel} with callback to #{@callback_method}"
        async.start_listening
        enhance_callback_method unless @callback_method == :unlisten_wrapper
        async.listen(channel, @callback_method)
        # When called from a sub-class of a class including Client
        #   and the sub-class overrides initialize,
        #   then the execution order changes,
        #   and this method may no longer have a super.
        # However, due to the nature of the initialize method we can't tell if we have a legitimate super or not.
        super(*args) if defined?(super)
        puts "OUT AsyncListener"
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
              super(channel, payload, &block)
            else
              error "LISTENER ERROR: #{payload}"
              raise CelluloidIOPGListener::Client::InvalidClient, "#{self.class} does not define a method :#{@callback_method} with arguments (channel, payload)"
            end
          end
        end
      end

    end
  end
end
