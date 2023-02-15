class NftsController < ApplicationController
  include Pagy::Backend
  skip_before_action :verify_authenticity_token, only: [:create, :buy_nft]

  EMPTY_ATTRIBUTES_ERROR_MESSAGE = "Description and owner id are mandatory attributes to create an nft."
  CO_CREATORS_IDS_SEPARATOR = ','

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: e, status: :bad_request
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: EMPTY_ATTRIBUTES_ERROR_MESSAGE, status: :bad_request
  end

  rescue_from Pagy::OverflowError do |e|
    render json: PaginationErrorMessageService.new.create_message(params[:nfts_per_page].to_i), status: :bad_request
  end

  def create
    @nft = Nft.create!(nft_params)
    CoCreatorsService.new.add_co_creators(
      @nft,
      params[:nft][:creators_ids].split(CO_CREATORS_IDS_SEPARATOR).map(&:to_i)
    ) unless params[:nft][:creators_ids].nil?
    @nft = add_image_to_nft_json(@nft)
    render json: @nft, status: :created
  end

  def index
    nfts = pagy(Nft.order(created_at: :desc).with_attached_image, page: params[:page], items: params[:nfts_per_page])

    nfts[1] = nfts[1].map do |nft|
      add_image_to_nft_json(nft)
    end

    render json: nfts[1], status: :ok
  end

  def buy_nft
    purchase_result = BuyNftService.new.buy_nft(
      params[:buyer_id].to_i,
      params[:price].to_f,
      params[:id].to_i
    )

    render json: purchase_result.message, status: :ok
  end

  private

  def nft_params
    params.require(:nft).permit(:description, :owner_id, :image)
  end

  def add_image_to_nft_json(nft)
    nft.image.attached? ? nft.as_json.merge({ image_url: url_for(nft.image) }) : nft
  end
end