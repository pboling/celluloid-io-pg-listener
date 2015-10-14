module CelluloidIOPGListener
  module Examples
    class Client

      include CelluloidIOPGListener::Client

      # def initialize(*options)
      #   super
      # end

      def do_something(channel, payload)
        # <-- within the unlisten_wrapper's block
        puts "channel is #{channel}"
        puts "payload is #{payload}"
      end

    end
  end
end
