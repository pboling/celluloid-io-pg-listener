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
      # def initialize(*haha)
      #   # Unlike in the original class, the prepends have been usurped since this overridden method is now highest precedence.
      #   super(*haha)
      #   # The initialize overrides will be called by super, and thus you have to be careful how you pass on the arguments to super.
      # end

      def foo_bar(channel, payload, &block)
        yield if block_given?
      end

    end
  end
end
