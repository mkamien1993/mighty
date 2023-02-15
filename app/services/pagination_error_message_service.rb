class PaginationErrorMessageService
  def create_message(nfts_per_page)
    "The requested page does not exist. With #{nfts_per_page} nfts per page, the current amount of pages is #{(Nft.all.size.to_f/nfts_per_page).ceil}."
  end
end
