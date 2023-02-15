require 'rails_helper'

RSpec.describe BuyNftResponseStatus::NotEnoughMoneyStatus do
  let(:service) { BuyNftResponseStatus::NotEnoughMoneyStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('Buyer does not have enough money to buy the NFT.')
  end
end


