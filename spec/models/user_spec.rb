require "rails_helper"

RSpec.describe User, type: :model do
  it 'has a version number' do
    expect(User.new).to be_a User
  end
end
