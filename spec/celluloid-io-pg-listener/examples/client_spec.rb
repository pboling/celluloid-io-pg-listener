RSpec.describe CelluloidIOPGListener::Examples::Client, celluloid: true do

  let(:channel) { "foo" }
  let(:payload) { "bar" }

  it "has ancestry" do
    expect(CelluloidIOPGListener::Examples::Client.ancestors).to include(
                                                                           CelluloidIOPGListener::Initialization::ArgumentExtraction,
                                                                           CelluloidIOPGListener::Initialization::AsyncListener,
                                                                           Celluloid::Internals::Logger,
                                                                           Celluloid::IO,
                                                                           Celluloid,
                                                                           CelluloidIOPGListener::Client
                                                                         )
  end

  describe "#new" do
    context "channel provided" do
      it("raises") do
        expect { CelluloidIOPGListener::Examples::Client.new("marble", fi: :fi) }.to raise_error ArgumentError, /\[CelluloidIOPGListener::Initialization::ClientExtractedSignature\] :channel is required, but got \["marble"\] and {:fi=>:fi}/
      end
    end
    context "channel provided" do
      it("doesn't raise") do
        expect { CelluloidIOPGListener::Examples::Client.new(channel: channel) }.to_not raise_error
      end
      it "works" do
        expect(CelluloidIOPGListener::Examples::Client.new(channel: channel)).to be_a CelluloidIOPGListener::Examples::Client
      end
    end
  end
  describe "callback_method" do
    let(:instance) { CelluloidIOPGListener::Examples::Client.new(dbname: "celluloid_io_pg_listener_test", channel: channel, callback_method: callback_method) }
    before { instance }
    context "default" do
      let(:callback_method) { nil }
      it("is set") do
        expect(instance.respond_to?(:unlisten_wrapper)).to be true
        expect(instance.callback_method).to eq :unlisten_wrapper
      end
    end
    context "custom" do
      let(:callback_method) { :foo_bar }
      it("raises on undefined method") do
        expect(instance.respond_to?(:foo_bar)).to be true
        expect(instance.callback_method).to eq :foo_bar
        expect { instance.foo_bar(channel, payload) }.to raise_error CelluloidIOPGListener::Client::InvalidClient, /CelluloidIOPGListener::Examples::Client does not define a method :foo_bar with arguments \(channel, payload\)/
      end
    end
  end

end
