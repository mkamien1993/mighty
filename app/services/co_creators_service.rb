class CoCreatorsService

  def add_co_creators(nft, co_creators_ids)
    co_creators_ids.each do |id|
      nft.co_creators << id unless nft.co_creators.include?(id)
    end
    nft.save!
  end
end