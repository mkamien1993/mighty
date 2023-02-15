require 'rails_helper'

RSpec.describe BuyNftResponseStatus::SuccessfulPurchaseStatus do
  let(:service) { BuyNftResponseStatus::SuccessfulPurchaseStatus.new }

  it "should create the correct message" do
    expect(service.message).to eq('The purchase was successful!')
  end
end
