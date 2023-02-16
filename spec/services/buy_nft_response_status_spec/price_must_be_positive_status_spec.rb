require 'rails_helper'

RSpec.describe BuyNftResponseStatus::PriceMustBePositiveStatus do
  let(:service) { BuyNftResponseStatus::PriceMustBePositiveStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('Price must be positive.')
  end
end


