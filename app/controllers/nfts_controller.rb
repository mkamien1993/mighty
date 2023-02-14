class NftsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  EMPTY_ATTRIBUTES_ERROR_MESSAGE = "Description and owner id are mandatory attributes to create an nft"
  CO_CREATORS_IDS_SEPARATOR = ','

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: e, status: :bad_request
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: EMPTY_ATTRIBUTES_ERROR_MESSAGE, status: :bad_request
  end

  def create
    @nft = Nft.create!(nft_params)
    CoCreatorsService.new.add_co_creators(
      @nft,
      params[:nft][:creators_ids].split(CO_CREATORS_IDS_SEPARATOR).map(&:to_i)
    )
    render json: @nft, status: :created
  end

  private

  def nft_params
    params.require(:nft).permit(:description, :owner_id, :image)
  end
end