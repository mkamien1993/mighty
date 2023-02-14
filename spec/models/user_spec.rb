require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create! }

  it "is created with balance = 100" do
    expect(user.balance).to eq(100)
  end
end
