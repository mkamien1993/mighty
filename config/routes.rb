Rails.application.routes.draw do
  resources :nfts , only: [:create]
end
