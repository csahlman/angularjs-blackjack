json.player_hand do 
  json.cards @player_hand.cards, :value, :suit 
  json.score @player_hand.score
end

json.dealer_hand do 
  json.cards [@dealer_hand.cards.first], :value, :suit
end