require 'swagger_helper'

RSpec.describe 'nfts', type: :request do

  path '/nfts' do
    get('List all nfts') do
      tags 'nfts'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :page, in: :query, type: :string
      parameter name: :nfts_per_page, in: :query, type: :string

      response '200', 'List of all NFTs minted' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            description: { type: :string, nullable: false },
            owner_id: { type: :integer, nullable: false },
            image_url: { type: :string, nullable: false },
            creators_ids: { type: :array, items: { type: :integer }},
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: %w[id description owner_id creators_ids creators_ids created_at updated_at]
        }

        let(:page) { "1" }
        let(:nfts_per_page) { "1" }
        let(:owner) { User.create! }
        let(:nft) { Nft.create!(
          description: "Monkey",
          owner_id: owner.id,
          image: Rack::Test::UploadedFile.new("app/assets/images/nft.jpg", "image/jpg")
        )}

        run_test!
      end
    end

    post('Mint nft') do
      tags 'nfts'
      consumes "multipart/form-data"
      produces "application/json"

      parameter name: :nft, in: :formData, required: true, schema: {
        type: :object,
        properties: {
          description: { type: :string, nullable: false },
          owner_id: { type: :integer, nullable: false },
          image: { type: :file, nullable: false },
          creators_ids: { type: :array, items: { type: :integer }}
        },
        required: %w[description owner_id image]
      }

      response '201', 'Nft minted' do
        let(:nft) { { description: 'foo', owner_id: 1,
                      image: Rack::Test::UploadedFile.new("app/assets/images/nft.jpg", "image/jpg") } }
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 description: { type: :string, nullable: false },
                 owner_id: { type: :integer, nullable: false },
                 image_url: { type: :string, nullable: false },
                 creators_ids: { type: :array, items: { type: :integer }},
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[id description owner_id creators_ids image_url creators_ids created_at updated_at]
        run_test!
      end
    end
  end

  path '/nfts/{id}/buy' do
    put('Buy nft') do
      tags 'nfts'
      consumes "multipart/form-data"
      produces "application/json"

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :buyer_id, in: :formData, type: :integer, required: true
      parameter name: :price, in: :formData, type: :float, required: true

      response(200, 'successful') do
        schema type: :string
        let(:owner) { User.create! }
        let(:nft) { Nft.create!(
          description: "Monkey",
          owner_id: owner.id,
          image: Rack::Test::UploadedFile.new("app/assets/images/nft.jpg", "image/jpg")
        )}
        let(:buyer) { User.create! }
        let(:id) { nft.id.to_s }
        let(:buyer_id) { buyer.id.to_s }
        let(:price) { 50.to_f }

        run_test!
      end
    end
  end
end
