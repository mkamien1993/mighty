require 'rails_helper'

RSpec.describe BuyNftResponseStatus::InvalidBuyerIdStatus do
  let(:service) { BuyNftResponseStatus::InvalidBuyerIdStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('It does not exist a user with the id provided (buyer_id).')
  end
end


