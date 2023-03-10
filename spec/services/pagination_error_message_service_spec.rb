require 'rails_helper'

RSpec.describe PaginationErrorMessageService do
  include FileHelper

  let(:nfts_per_page) { 5 }
  let(:pagination_error_message_service) { PaginationErrorMessageService.new }

  before do
    Nft.destroy_all
    Nft.create!(description: 'Test', owner_id:1, image: upload_file("#{Rails.root}/app/assets/images/nft.jpg"))
    Nft.create!(description: 'Test 2', owner_id:2, image: upload_file("#{Rails.root}/app/assets/images/nft.jpg"))
  end

  it "should create the correspondant message" do
    error_message = "The requested page does not exist. With 2 nfts per page, the current amount of pages is 1."
    expect(pagination_error_message_service.create_message(2)).to eq(error_message)
  end
end
