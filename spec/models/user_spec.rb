require "rails_helper"

RSpec.describe User, type: :model do
  it("is a User") { expect(User.new).to be_a User }
  it("doesn't validate") { expect(User.new.valid?).to be false }
  it("validates") { expect(User.new(name: "Boo Wacka").valid?).to be true }
  it("creates") { expect(User.new(name: "Boo Wacka").save).to be true }
end
