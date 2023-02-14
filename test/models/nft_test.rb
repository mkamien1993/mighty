require "test_helper"

class NftTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "it is invalid without a description" do
    expect{Nft.create(description: nil , owner_id: 1)}.to raise_error
  end

end
