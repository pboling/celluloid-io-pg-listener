RSpec.describe CelluloidIOPGListener::Examples::ListenerClientByInheritance, celluloid: true do

  let(:channel) { "foo" }
  let(:payload) { "bar" }

  describe "#new" do
    context "alternate signature" do
      it("doesn't raise") do
        expect { CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(:my, :cheese, bus: :guns, fat: "loofah", channel: "foo") }.to_not raise_error
      end
    end
  end

  describe "callback_method" do
    let(:callback_method) { nil }
    let(:server) { CelluloidIOPGListener::Examples::Server.new(dbname: "celluloid_io_pg_listener_test", channel: channel ) }
    let(:instance) { CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(dbname: "celluloid_io_pg_listener_test", channel: channel, callback_method: callback_method) }
    before { instance }
    context "default" do
      let(:callback_method) { nil }
      it("is set") do
        expect(instance.respond_to?(:unlisten_wrapper)).to be true
        expect(instance.callback_method).to eq :unlisten_wrapper
      end
      context "when triggered" do
        before { expect_any_instance_of(CelluloidIOPGListener::Examples::ListenerClientByInheritance).to receive(:unlisten_wrapper).and_return(true) }
        it("gets called") do
          server.ping
          sleep(1)
        end
      end
    end
    context "custom" do
      let(:callback_method) { :foo_bar }
      context "defined by the class" do
        it("can be set") do
          expect(instance.respond_to?(callback_method)).to be true
          expect(instance.callback_method).to eq callback_method
        end
        it("can have logic") do
          expect { instance.foo_bar("users_insert", payload) }.to_not raise_error
        end
        it("can raise an error") do
          expect { instance.foo_bar(channel, payload) }.to raise_error RuntimeError, /This example only works on the users_insert channel, you are notifying #{channel} with #{payload}/
        end
      end
      context "when triggered" do
        before { expect_any_instance_of(CelluloidIOPGListener::Examples::ListenerClientByInheritance).to receive(callback_method).and_return(true) }
        it("gets called") do
          server.ping
          sleep(1)
        end
      end
    end
  end

end
