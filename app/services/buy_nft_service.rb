class BuyNftService
  OWNER_REVENUE_PERCENTAGE = 0.8
  CO_CREATORS_REVENUE_PERCENTAGE = 0.2

  def buy_nft(buyer_id, price, nft_id)
    nft = Nft.find(nft_id)
    return BuyNftResponseStatus::BuyerAlreadyOwnNftStatus.new if buyer_id == nft.owner_id

    buyer = User.find(buyer_id)
    return BuyNftResponseStatus::NotEnoughMoneyStatus.new unless buyer.has_enough_balance(price)

    subtract_balance_to_buyer(price, buyer)
    update_owner_balance(price, nft.owner_id)
    update_co_creators_balance(price, nft.co_creators)
    update_nft_owner(nft, buyer_id)
    BuyNftResponseStatus::SuccessfulPurchaseStatus.new
  end

  private

  def subtract_balance_to_buyer(price, buyer)
    buyer.subtract_balance(price)
  end

  def update_owner_balance(price, nft_owner_id)
    owner_revenue = OWNER_REVENUE_PERCENTAGE*price
    owner = User.find(nft_owner_id)
    owner.add_balance(owner_revenue)
  end

  def update_co_creators_balance(price, co_creators)
    co_creators_total_revenue = CO_CREATORS_REVENUE_PERCENTAGE*price
    co_creator_individual_revenue = co_creators_total_revenue/co_creators.size

    co_creators.each do |co_creator|
      User.find(co_creator).add_balance(co_creator_individual_revenue)
    end
  end

  def update_nft_owner(nft, buyer_id)
    nft.update(owner_id: buyer_id)
  end
end