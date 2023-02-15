Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :nfts , only: [:create, :index]

  put 'nfts/:id/buy', to: 'nfts#buy_nft'
end
