module CelluloidIOPGListener
  module Examples
    class ListenerClientByInheritance < CelluloidIOPGListener::Examples::Client

      #
      # When you are:
      #   * sub-classing a class that includes the Client and defines initialize
      #
      # If you
      #   * defining a custom / overridden initialize method in the sub-class
      #
      # The Client may not work.
      #   * the initialize overrides may happen out of normal order,
      #     and may not work as expected.
      #
      # Working Example of overridden initialize follows!
      #
      def initialize(a = nil, b = nil, bus: nil, fat: nil, **args)
        # Unlike in the original class, the prepends have been usurped since this overridden method is now highest precedence.
        super(subclassed_client: true, **args)
        # The initialize overrides will be called by super, and thus you have to be careful how you pass on the arguments to super.
      end

      # callback_method does *not* accept a block parameter
      def foo_bar(channel, payload)
        # <-- within the unlisten_wrapper's block if :foo_bar is the callback_method
        debug "#{self.class}##{__method__} channel: #{channel}"
        debug "#{self.class}##{__method__} payload: #{payload}"
        raise RuntimeError, "This example only works on the users_insert channel, you are notifying #{channel} with #{payload}" unless channel == "users_insert"
      end

    end
  end
end
