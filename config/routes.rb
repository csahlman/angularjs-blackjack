Rails.application.routes.draw do
  root to: 'pages#home'

  post '/blackjack/request_money', to: 'blackjack#request_money', defaults: { format: :json }
  put '/blackjack/set_preferences', to: 'blackjack#set_preferences', defaults: { format: :json }
  post '/blackjack/start_round', to: 'blackjack#start_round', defaults: { format: :json }
  resources :users, defaults: { format: :json }, only: [] do 
    put :update_name, on: :collection
  end
end
