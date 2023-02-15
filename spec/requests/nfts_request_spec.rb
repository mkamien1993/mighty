require 'rails_helper'

RSpec.describe "NftsRequests", type: :request do
  let(:user) { User.create! }
  let(:second_user) { User.create! }
  let(:third_user) { User.create! }
  let(:nft) { Nft.create!(description: 'Classic NFT', owner_id: user.id, creators_ids: [second_user.id]) }

  describe '#buy_nft' do
    it 'can not buy the nft if it is already the owner' do
      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: user.id, price: 100 }
      expect(response.body).to eq('The buyer already own the NFT.')
      expect(response).to have_http_status(:ok)
    end

    it 'can not buy the nft if it does not have enough money' do
      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: third_user.id, price: 150 }
      expect(response.body).to eq('Buyer does not have enough money to buy the NFT.')
      expect(response).to have_http_status(:ok)
    end

    it 'can buy the nft, balances and owner are updated' do
      expect(third_user.balance).to eq(100)

      put "/nfts/#{nft.id}/buy", params: { id: nft.id, buyer_id: third_user.id, price: 100 }
      new_owner_id = third_user.id
      expect(nft.reload.owner_id).to eq(new_owner_id)

      expect(third_user.reload.balance).to eq(0)

      expect(user.reload.balance).to eq(190)
      expect(second_user.reload.balance).to eq(110)
      expect(response).to have_http_status(:ok)
    end

    it 'can buy the nft twice, balances and owner are updated' do
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
