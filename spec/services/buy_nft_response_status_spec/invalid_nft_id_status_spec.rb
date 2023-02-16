require 'rails_helper'

RSpec.describe BuyNftResponseStatus::InvalidNftIdStatus do
  let(:service) { BuyNftResponseStatus::InvalidNftIdStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('It does not exist an NFT with the id provided.')
  end
end


