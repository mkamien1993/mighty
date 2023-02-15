require 'rails_helper'

RSpec.describe Nft, type: :model do
  let(:nft) { Nft.create!(
    description: "Monkey",
    owner_id: 1,
    image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg")
  ) }

  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:owner_id) }
    it { should validate_presence_of(:image) }
  end

  it 'is valid with description, owner id and image attributes' do
    expect(nft).to be_valid
  end

  it 'is not valid without a description' do
    nft.description = nil
    expect(nft).to_not be_valid
  end

  it 'is not valid without owner id' do
    nft.owner_id = nil
    expect(nft).to_not be_valid
  end

  it 'is not valid without an image' do
    nft.image = nil
    expect(nft).to_not be_valid
  end

  it 'can attach an image' do
    nft.image.attach(
      io: File.open("#{Rails.root}/app/assets/images/nft.jpg"),
      filename: 'nft.jpg',
      content_type: 'image/jpg'
    )
    expect(nft.image).to be_attached
  end

  context 'when created without co-creators' do
    it 'adds owner id as a co-creator' do
      expect(nft.co_creators.size).to eq(1)
      expect(nft.co_creators.first).to eq(1)
    end
  end

  it 'can be created with co-creators' do
    nft = Nft.create!(
      description: 'Classic NFT',
      owner_id: 1,
      creators_ids: [2, 3, 4],
      image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg")
    )
    expect(nft.co_creators.size).to eq(4)
    expect(nft.co_creators.include?(1)).to eq(true)
    expect(nft.co_creators.include?(2)).to eq(true)
    expect(nft.co_creators.include?(3)).to eq(true)
    expect(nft.co_creators.include?(4)).to eq(true)
  end

  it 'should not add owner id twice if it is passed as a co creator' do
    nft = Nft.create!(
      description: 'Classic NFT',
      owner_id: 1,
      creators_ids: [1, 3, 4],
      image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg")
    )
    expect(nft.co_creators.size).to eq(3)
    expect(nft.co_creators.include?(1)).to eq(true)
    expect(nft.co_creators.include?(3)).to eq(true)
    expect(nft.co_creators.include?(4)).to eq(true)
  end
end
