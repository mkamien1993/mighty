class NftsController < ApplicationController
  include Pagy::Backend
  skip_before_action :verify_authenticity_token, only: [:create]

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
    )
    render json: @nft, status: :created
  end

  def index
    nfts = pagy(Nft.order(created_at: :desc), page: params[:page], items: params[:nfts_per_page])
    render json: nfts, status: :ok
  end

  private

  def nft_params
    params.require(:nft).permit(:description, :owner_id, :image)
  end
end