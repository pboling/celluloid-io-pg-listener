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

    # With the `sleep(1)` the following specs usually pass when run individually.
    # Asynchronous tests are a bitch.
    # TODO: Don't have time to figure out how to mock this out with synchronous behavior.
    context "with listener", celluloid: true do
      let(:database_name) { "celluloid_io_pg_listener_test" }
      let(:insert_channel) { "users_insert" }
      context "not subclassed" do
        let(:callback_method) { :insert_callback }
        xit("gets called") do
          InsertListener.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect_any_instance_of(InsertListener).to receive(callback_method).and_return(true)
          User.new(name: "InsertListener").save
          # sleep(1)
        end
        xit("and gets called") do
          CelluloidIOPGListener::Examples::Client.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect_any_instance_of(CelluloidIOPGListener::Examples::Client).to receive(callback_method).and_return(true)
          User.new(name: "CelluloidIOPGListener::Examples::Client").save
          # sleep(1)
        end
      end
      context "subclassed" do
        let(:callback_method) { :foo_bar }
        xit("gets called") do
          CelluloidIOPGListener::Examples::ListenerClientByInheritance.new(dbname: database_name, channel: insert_channel, callback_method: callback_method)
          expect_any_instance_of(CelluloidIOPGListener::Examples::ListenerClientByInheritance).to receive(callback_method).and_return(true)
          User.new(name: "CelluloidIOPGListener::Examples::ListenerClientByInheritance").save
          sleep(1)
        end
      end
    end
  end
end
