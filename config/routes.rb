Rails.application.routes.draw do
  post '/save_transaction', to: 'home#save_transaction'
  post '/export_data', to: 'home#export_data'

  root 'home#index'
end
