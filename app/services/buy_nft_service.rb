class BuyNftService
  OWNER_REVENUE_PERCENTAGE = 0.8
  CO_CREATORS_REVENUE_PERCENTAGE = 0.2

  def initialize(buyer_id, price, nft_id)
    @buyer_id = buyer_id
    @price = price
    @nft_id = nft_id
  end

  def buy_nft
    validations_ok = validate_purchase
    return validations_ok unless validations_ok == true

    subtract_balance_to_buyer
    update_owner_balance
    update_co_creators_balance
    update_nft_owner
    BuyNftResponseStatus::SuccessfulPurchaseStatus.new
  end

  private

  def validate_purchase
    return BuyNftResponseStatus::PriceMustBePositiveStatus.new if @price <= 0

    begin
      @nft = Nft.find(@nft_id)
    rescue ActiveRecord::RecordNotFound
      return BuyNftResponseStatus::InvalidNftIdStatus.new
    end

    return BuyNftResponseStatus::BuyerAlreadyOwnNftStatus.new if @buyer_id == @nft.owner_id

    begin
      @buyer = User.find(@buyer_id)
    rescue ActiveRecord::RecordNotFound
      return BuyNftResponseStatus::InvalidBuyerIdStatus.new
    end

    return BuyNftResponseStatus::NotEnoughMoneyStatus.new unless @buyer.has_enough_balance(@price)
    true
  end

  def subtract_balance_to_buyer
    @buyer.subtract_balance(@price)
  end

  def update_owner_balance
    owner_revenue = OWNER_REVENUE_PERCENTAGE*@price
    owner = User.find(@nft.owner_id)
    owner.add_balance(owner_revenue)
  end

  def update_co_creators_balance
    co_creators = @nft.co_creators
    co_creators_total_revenue = CO_CREATORS_REVENUE_PERCENTAGE*@price
    co_creator_individual_revenue = co_creators_total_revenue/co_creators.size

    co_creators.each do |co_creator|
      User.find(co_creator).add_balance(co_creator_individual_revenue)
    end
  end

  def update_nft_owner
    @nft.update(owner_id: @buyer_id)
  end


end