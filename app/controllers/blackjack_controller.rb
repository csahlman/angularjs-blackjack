class BlackjackController < ApplicationController

  def request_money
    current_user.retrieve_money(params[:request])
  end

  def set_preferences
    
  end

  def start_round
    @round = Round.create
    @round.start_round!(1)
    @dealer_hand = @round.deal_dealer_hand
    @player_hand = @round.deal_player_hand(current_user)
    puts @round.cards.count
  end

end