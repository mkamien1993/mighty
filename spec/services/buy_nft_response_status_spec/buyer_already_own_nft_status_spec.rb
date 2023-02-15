require 'rails_helper'

RSpec.describe BuyNftResponseStatus::BuyerAlreadyOwnNftStatus do
  let(:service) { BuyNftResponseStatus::BuyerAlreadyOwnNftStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('The buyer already own the NFT.')
  end
end

