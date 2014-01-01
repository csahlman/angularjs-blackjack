class Round < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :hands, dependent: :destroy

  def start_round!(num_decks)
    self.create_decks(num_decks)
    self.cards.shuffle
  end

  def deal_dealer_hand
    cards = self.cards.last(2)
    hand = self.hands.create(card_ids: cards.map(&:id), user_id: nil)
    cards.map { |card| card.update_attribute(:round_id, nil) } 
    hand
  end

  def deal_player_hand(user)
    cards = self.cards.first(2)
    hand = self.hands.create(card_ids: cards.map(&:id), user_id: user.id)
    cards.map { |card| card.update_attribute(:round_id, nil) } 
    hand
  end

  def create_decks(num_decks = 1)
    num_decks.times do
      my_deck = Array.new
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
end
