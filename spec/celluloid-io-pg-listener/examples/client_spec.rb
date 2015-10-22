RSpec.describe CelluloidIOPGListener::Examples::Client, celluloid: true do

  SUPPORTED_CHANNEL_SYNTAX_EXAMPLES = {
      capitals: "FOO",
      dash: "foo-bar",
      beginning_dash: "-foo",
      period: "foo.bar",
      beginning_period: ".foo",
      underscore: "foo_bar",
      beginning_underscore: "_foo",
      digit: "foo9",
      beginning_digit: "9foo",
      dollar: "foo$",
      beginning_dollar: "$foo",
  }
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
    context "channel not provided" do
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
    let(:klass) { CelluloidIOPGListener::Examples::Client }
    let(:instance) { klass.new(dbname: "celluloid_io_pg_listener_test", channel: channel, callback_method: callback_method) }
    let(:server) { CelluloidIOPGListener::Examples::Server.new(dbname: "celluloid_io_pg_listener_test", channel: channel ) }
    before { instance }
    context "default" do
      let(:callback_method) { nil }
      it("is set") do
        expect(instance.respond_to?(:unlisten_wrapper)).to be true
        expect(instance.callback_method).to eq :unlisten_wrapper
      end
      context "when triggered" do
        before { expect_any_instance_of(klass).to receive(:unlisten_wrapper).and_return(true) }
        it("gets called") do
          server.ping
          sleep(1)
        end
      end
    end
    context "custom" do
      let(:callback_method) { :foo_bar }
      context "when not defined" do
        it("raises on undefined method") do
          expect(instance.respond_to?(callback_method)).to be true
          expect(instance.callback_method).to eq callback_method
          expect { instance.foo_bar(channel, payload) }.to raise_error CelluloidIOPGListener::Client::InvalidClient, /CelluloidIOPGListener::Examples::Client does not define a method :#{callback_method} with arguments \(channel, payload\)/
        end
      end
      context "when triggered" do
        class CutWithFooBar < CelluloidIOPGListener::Examples::Client
          def foo_bar(channel, payload); end
        end
        let(:klass) { CutWithFooBar }
        before { expect_any_instance_of(CutWithFooBar).to receive(callback_method).and_return(true) }
        it("gets called") do
          server.ping
          sleep(1)
        end
        SUPPORTED_CHANNEL_SYNTAX_EXAMPLES.each do |syntax, channel|
          context "channel name with #{syntax}" do
            let(:channel) {channel}
            it("#{channel} gets called") do
              server.ping
              sleep(1)
            end
          end
        end
      end
    end
  end

end
