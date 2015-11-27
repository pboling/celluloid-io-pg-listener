require "rails_helper"
require "support/insert_listener"
require "pry"

RSpec.describe User, type: :model do
  it("is a User") { expect(User.new).to be_a User }
  it("doesn't validate") { expect(User.new.valid?).to be false }
  it("validates") { expect(User.new(name: "Boo Wacka").valid?).to be true }
  context "#save" do
    it("creates") { expect(User.new(name: "Boo Wacka").save).to be true }
    it("inserts") { expect { User.new(name: "Boo Wacka").save }.to change(User, :count).by(1)}

    # TODO: Don't have time to figure out how to mock this out with synchronous behavior.
    context "with listener", celluloid: true do
      let(:database_name) { "celluloid_io_pg_listener_test" }
      let(:insert_channel) { "users_insert" }
      context "not subclassed" do
        let(:callback_method) { :insert_callback }
        it("gets called") do
          listener = InsertListener.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect(listener.wrapped_object).to receive(:insert_callback).and_return(true)
          User.new(name: "InsertListener").save
        end
        it("and gets called") do
          listener = CelluloidIOPGListener::Examples::Client.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect(listener.wrapped_object).to receive(:insert_callback).and_return(true)
          User.new(name: "CelluloidIOPGListener::Examples::Client").save
        end
      end
      context "subclassed" do
        let(:callback_method) { :foo_bar }
        it("gets called") do
          listener = CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect(listener.wrapped_object).to receive(:foo_bar).and_return(true)
          User.new(name: "CelluloidIOPGListener::Examples::ListenerClientByInheritance").save
        end
      end
    end
  end
end
