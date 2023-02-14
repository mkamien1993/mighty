require 'rails_helper'

RSpec.describe PaginationErrorMessageService do
  let(:nfts_per_page) { 5 }
  let(:nft) { Nft.create!(description: 'Test', owner_id:1) }
  let(:second_nft) { Nft.create!(description: 'Test 2', owner_id:2) }
  let(:pagination_error_message_service) { PaginationErrorMessageService.new }

  before do
    nft.save!
    second_nft.save!
  end

  it "should create the correspondant message" do
    error_message = "The requested page does not exist. With 2 nfts per page, the amount of pages is 1."
    expect(pagination_error_message_service.create_message(2)).to eq(error_message)
  end
end
