RSpec.describe CelluloidIOPGListener::Examples::ListenerClientByInheritance do

  let(:channel) { "foo" }
  let(:payload) { "bar" }

  describe "#new" do
    context "alternate signature" do
      xit("doesn't raise") do
        expect { CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(:my, :cheese, bus: :guns, fat: "loofah", channel: "foo", **({a: "b"})) }.to_not raise_error
      end
    end
  end

  describe "callback_method" do
    let(:callback_method) { nil }
    let(:server) { CelluloidIOPGListener::Examples::Server.new(dbname: "celluloid_io_pg_listener_test", channel: channel ) }
    let(:instance) { CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(dbname: "celluloid_io_pg_listener_test", channel: channel, callback_method: callback_method) }
    before { instance }
    context "triggered" do
      # it("enhanced callback_method uses unlisten_wrapper") do
      #   puts "instance uuid: #{instance.object_id}"
      #   expect(instance).to receive(:unlisten_wrapper)
      #   server.ping
      # end
    end
    context "default" do
      let(:callback_method) { nil }
      it("is set") do
        expect(instance.respond_to?(:unlisten_wrapper)).to be true
        expect(instance.callback_method).to eq :unlisten_wrapper
      end
    end
    context "custom" do
      let(:callback_method) { :foo_bar }
      context "defined by the class" do
        it("can be set") do
          expect(instance.respond_to?(:foo_bar)).to be true
          expect(instance.callback_method).to eq :foo_bar
          expect { instance.foo_bar(channel, payload) }.to_not raise_error
        end
        # it("runs the block") do
        #   expect { instance.foo_bar(channel, payload) { raise RuntimeError, "#{channel}:#{payload}" } }.to raise_error RuntimeError, /#{channel}:#{payload}/
        # end
      end
    end
  end

end
