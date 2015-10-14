module CelluloidIOPGListener
  module Examples
    class Client

      include CelluloidIOPGListener::Client

      # Defining initialize is optional
      # But if you do define it, use a splat,
      #   hash or array splat should work,
      #   depending on your signature needs,
      #   only pass those to super,
      #   and only handle the other stuff locally.
      #
      # def initialize(optional_arg = nil, *options)
      #   @optional_arg = optional_arg # handle it!
      #   super(*options)
      # end

      def do_something(channel, payload)
        # <-- within the unlisten_wrapper's block if :do_something is the callback_method
        debug "#{self.class} channel is #{channel}"
        debug "#{self.class} payload is #{payload}"
      end

    end
  end
end
