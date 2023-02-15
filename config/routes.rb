Rails.application.routes.draw do
  resources :nfts , only: [:create, :index]

  put 'nfts/:id/buy', to: 'nfts#buy_nft'
end
