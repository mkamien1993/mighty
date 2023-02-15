require 'rails_helper'

RSpec.describe "NftsRequests", type: :request do
  let(:user) { User.create! }
  let(:second_user) { User.create! }
  let(:third_user) { User.create! }
  let(:nft) { Nft.create!(
    description: 'Classic NFT',
    owner_id: user.id,
    creators_ids: [second_user.id],
    image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg")
  ) }

  describe '#create' do
    let(:image) { fixture_file_upload('app/assets/images/nft.jpg') }

    it 'should create an NFT' do
      amount_of_nfts_before_request = Nft.all.size
      post '/nfts',
           params: { nft: { description: 'Bla', owner_id: user.id, image: image, creators_ids: "#{second_user.id}"} }

      expect(Nft.all.size).to eq(amount_of_nfts_before_request + 1)
      new_nft = Nft.last
      expect(new_nft.description).to eq('Bla')
      expect(new_nft.owner_id).to eq(user.id)
      expect(new_nft.image).to be_an_instance_of(ActiveStorage::Attached::One)
      expect(new_nft.creators_ids).to eq([user.id, second_user.id])
      expect(response).to have_http_status(:created)
    end
  end

  describe '#index' do
    before do
      Nft.destroy_all
      Nft.create!(description: 'First NFT', owner_id: user.id, creators_ids: [second_user.id],
                  image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg"))
      Nft.create!(description: 'Second NFT', owner_id: user.id, creators_ids: [second_user.id],
                  image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg"))
      Nft.create!(description: 'Third NFT', owner_id: user.id, creators_ids: [second_user.id],
                  image: fixture_file_upload("#{Rails.root}/app/assets/images/nft.jpg"))
    end

    it 'should return all the minted NFTs ordered chronologically from newest to oldest' do
      get '/nfts'

      json_response = JSON.parse(response.body)
      expect(json_response[1].size).to eq(3)
      expect(json_response[1][0]["description"]).to eq('Third NFT')
      expect(json_response[1][1]["description"]).to eq('Second NFT')
      expect(json_response[1][2]["description"]).to eq('First NFT')
    end
  end

  describe '#buy_nft' do
    it 'should not buy the nft if it is already the owner' do
      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: user.id, price: 100 }
      expect(response.body).to eq('The buyer already own the NFT.')
      expect(response).to have_http_status(:ok)
    end

    it 'should not buy the nft if it does not have enough money' do
      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: third_user.id, price: 150 }
      expect(response.body).to eq('Buyer does not have enough money to buy the NFT.')
      expect(response).to have_http_status(:ok)
    end

    it 'should buy the nft and update balances and owner' do
      expect(third_user.balance).to eq(100)

      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: third_user.id, price: 100 }
      new_owner_id = third_user.id
      expect(nft.reload.owner_id).to eq(new_owner_id)

      expect(third_user.reload.balance).to eq(0)

      expect(user.reload.balance).to eq(190)
      expect(second_user.reload.balance).to eq(110)
      expect(response).to have_http_status(:ok)
    end

    it 'should buy the nft twice and update balances and owner' do
      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: second_user.id, price: 50 }
      new_owner_id = second_user.id
      expect(nft.reload.owner_id).to eq(new_owner_id)

      expect(user.reload.balance).to eq(145)
      expect(second_user.reload.balance).to eq(55)

      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: third_user.id, price: 50 }
      new_owner_id = third_user.id
      expect(nft.reload.owner_id).to eq(new_owner_id)

      expect(user.reload.balance).to eq(150)
      expect(second_user.reload.balance).to eq(100)
      expect(third_user.reload.balance).to eq(50)
      expect(response).to have_http_status(:ok)
    end
  end
end
