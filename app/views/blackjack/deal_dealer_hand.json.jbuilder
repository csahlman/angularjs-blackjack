if params[:deal]

  json.cards @dealer_hand.cards, :value, :suit
  json.score @dealer_hand.score
else
  json.leave_cards_unaltered  true
end

json.bank current_user.funds