class Round < ActiveRecord::Base
  def create_deck
    my_deck= Array.new
    52.times do |i|
      card = Card.new(suit: i%4+1, value: i%13+1)
        my_deck.push(card)
      end
      my_deck = my_deck.shuffle
      my_deck.each do |current_card|
        self.cards.create!(value: current_card.value, suit: current_card.suit)
      end  
    end
end
