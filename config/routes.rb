Rails.application.routes.draw do
  root to: 'pages#home'

  post '/blackjack/request_money', to: 'blackjack#request_money', defaults: { format: :json }
  put '/blackjack/set_preferences', to: 'blackjack#set_preferences', defaults: { format: :json }
  post '/blackjack/start_round', to: 'blackjack#start_round', defaults: { format: :json }
  post '/blackjack/hit_me', to: 'blackjack#hit_me', defaults: { format: :json }
  post '/blackjack/stand', to: 'blackjack#stand', defaults: { format: :json }
  post '/blackjack/deal_dealer_hand', to: 'blackjack#deal_dealer_hand', defaults: { format: :json }
  post '/blackjack/split', to: 'blackjack#split', defaults: { format: :json }
  post '/blackjack/double_down', to: 'blackjack#double_down', defaults: { format: :json }
  get '/blackjack/current_bank', to: 'blackjack#current_bank', defaults: { format: :json }

  resources :users, defaults: { format: :json }, only: [] do 
    put :update_name, on: :collection
  end
end
