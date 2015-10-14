module CelluloidIOPGListener
  module Examples
    class Client

      include CelluloidIOPGListener::Client

      # Defining initialize is optional,
      #   unless you have custom args you need to handle
      #   aside from those used by the CelluloidIOPGListener::Client
      # But if you do define it, use a splat,
      #   hash or array splat should work,
      #   depending on your signature needs.
      # With either splat, only pass the splat params to super,
      #   and handle all other params locally.
      #
      # def initialize(optional_arg = nil, *options)
      #   @optional_arg = optional_arg # handle it here, don't pass it on!
      #   super(*options)
      # end

      def insert_callback(channel, payload)
        # <-- within the unlisten_wrapper's block if :insert_callback is the callback_method
        debug "#{self.class} channel is #{channel}"
        debug "#{self.class} payload is #{payload}"
      end

    end
  end
end
