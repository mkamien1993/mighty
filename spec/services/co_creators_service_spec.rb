require 'rails_helper'

RSpec.describe CoCreatorsService do
  let(:nft) { Nft.create!(description: 'Prueba', owner_id:1) }
  let(:co_creators_service) { CoCreatorsService.new }

  it "should add co-creators ids" do
    co_creators_ids = [2, 3, 4]
    co_creators_service.add_co_creators(nft, co_creators_ids)
    expect(nft.co_creators.size).to eq(4)
    expect(nft.co_creators.include?(1)).to eq(true)
    expect(nft.co_creators.include?(2)).to eq(true)
    expect(nft.co_creators.include?(3)).to eq(true)
    expect(nft.co_creators.include?(4)).to eq(true)
  end

  it "should not add owner_id twice" do
    co_creators_ids = [1, 3, 4]
    co_creators_service.add_co_creators(nft, co_creators_ids)
    expect(nft.co_creators.size).to eq(3)
    expect(nft.co_creators.include?(1)).to eq(true)
    expect(nft.co_creators.include?(3)).to eq(true)
    expect(nft.co_creators.include?(4)).to eq(true)
  end

  it "should not add same co-creator twice" do
    co_creators_ids = [3, 3, 4]
    co_creators_service.add_co_creators(nft, co_creators_ids)
    expect(nft.co_creators.size).to eq(3)
    expect(nft.co_creators.include?(1)).to eq(true)
    expect(nft.co_creators.include?(3)).to eq(true)
    expect(nft.co_creators.include?(4)).to eq(true)
  end
end