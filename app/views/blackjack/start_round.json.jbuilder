json.player_hand do 
  json.cards @player_hand.cards, :value, :suit 
end

json.dealer_hand do 
  json.cards @dealer_hand.cards.first, :value, :suit
end