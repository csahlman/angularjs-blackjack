class Round < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :hands, dependent: :destroy

  def start_round!(num_decks)
    self.create_decks(num_decks)
    self.cards.shuffle
  end

  def deal_dealer_hand
    hand = self.hands.create
    2.times { deal_card!(hand) }
    hand.update_attribute(:dealer, true)
    hand.update_attribute(:current, false)
    hand.update_attribute(:blackjack, true) if hand.score == 21
    hand
  end

  def deal_player_hand(user, wager)
    hand = self.hands.create(user_id: user.id, wager: wager)
    2.times { deal_card!(hand) }
    hand.update_attribute(:current, true)
    hand.update_attribute(:blackjack, true) if hand.score == 21
    hand
  end

  def finished?
    self.current_hand.nil? && dealer_hand.present? && dealer_hand.score > 17
  end

  def deal_card!(hand)
    card = self.cards[self.cards_dealt]
    hand.cards << card
    card.update_attribute(:round_id, nil)
    self.update_attribute(:cards_dealt, self.cards_dealt + 1)
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
    self.current_hand.update_attribute(:dealt, true) if self.current_hand.present?
  end

  def evaluate_round!(dealer_score, user)
    net_difference = 0
    self.hands.where(dealer: nil).each do |hand|
      if hand.score > 21
        net_difference -= hand.wager
      elsif dealer_score > 21 || dealer_score < hand.score
        if hand.blackjack
          net_difference += (hand.wager * 1.5)
        else
          net_difference += hand.wager
        end
      elsif dealer_score > hand.score
        net_difference -= hand.wager
      end
    end
    user.update_attribute(:funds, user.funds + net_difference)
  end

  def destroy_extra_cards!
    self.cards.destroy_all 
  end

  def split_hand!
    last_card = self.current_hand.cards.last
    last_hand = self.hands.create(user_id: current_hand.user_id, wager: current_hand.wager)
    last_card.update_attribute(:hand_id, last_hand.id)
    deal_card!(last_hand)
    deal_card!(current_hand)
    last_hand.update_attribute(:blackjack, true) if last_hand.score == 21
    current_hand.update_attribute(:blackjack, true) if current_hand.score == 21
    [current_hand, last_hand]
  end

  def run_out_dealer_board!
    score = dealer_hand.score
    while score < 17
      deal_card!(dealer_hand)
      score = dealer_hand.score
    end
    dealer_hand
  end


  def double_down!
    current_hand.update_attribute(:wager, current_hand.wager * 2)
    deal_card!(current_hand)
    current_hand
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
