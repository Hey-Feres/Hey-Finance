Rails.application.routes.draw do
  post '/save_transaction', to: 'home#save_transaction'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
