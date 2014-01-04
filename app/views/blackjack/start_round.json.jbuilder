json.player_hand do 
  json.cards @player_hand.cards, :value, :suit 
  json.score @player_hand.score
  json.blackjack @player_hand.blackjack
end

json.dealer_hand do 
  json.cards [@dealer_hand.cards.last], :value, :suit
end

json.bank current_user.funds