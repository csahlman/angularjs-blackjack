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
    hand.update_attribute(:dealer, true)
    cards.map { |card| card.update_attribute(:round_id, nil) } 
    hand
  end

  def deal_player_hand(user)
    cards = self.cards.first(2)
    hand = self.hands.create(card_ids: cards.map(&:id), user_id: user.id)
    hand.update_attribute(:current, true)
    cards.map { |card| card.update_attribute(:round_id, nil) } 
    hand
  end

  def finished?
    current_hand.nil? && dealer_hand.present? && dealer_hand.score > 17
  end

  def deal_card!(hand)
    card = self.cards.first
    hand.cards << card
    card.update_attribute(:round_id, nil)
    card
  end

  def dealer_hand
    self.hands.where(dealer: true).first
  end

  def current_hand
    self.hands.where(current: true).first 
  end

  def end_hand!
    self.current_hand.update_attribute(:current, false) if self.current_hand.present?
  end

  def run_out_dealer_board!
    dealer_hand.update_attribute(:dealt, true)
    score = dealer_hand.score
    while score < 17
      deal_card!(dealer_hand)
      score = dealer_hand.score
    end
    dealer_hand
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
