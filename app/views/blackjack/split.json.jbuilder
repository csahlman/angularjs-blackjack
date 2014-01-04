json.array! @hands do |hand|
  json.cards hand.cards, :value, :suit
  json.blackjack hand.blackjack?
  json.score hand.score
end