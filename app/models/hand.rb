class Hand < ActiveRecord::Base
  belongs_to :round
  belongs_to :user
  has_many :cards, dependent: :destroy

  def score
    score = 0
    aces = 0
    self.cards.each do |card|
      value = card.get_value
      aces += 1 if value == 11
      score += value
    end
    while score > 21 && aces > 0
      score -= 10
      aces -= 1
    end
    score
  end

  def blackjack?
    cards.length == 2 && score == 21 
  end


end
