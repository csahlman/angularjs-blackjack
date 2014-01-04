class BlackjackController < ApplicationController

  def request_money
    current_user.retrieve_money(params[:request])
  end

  def set_preferences
    
  end

  def start_round
    @round = Round.create
    @round.start_round!(1)
    session[:round] = @round.id
    @dealer_hand = @round.deal_dealer_hand
    @player_hand = @round.deal_player_hand(current_user, params[:wager])
  end

  def hit_me
    @hand = current_round.current_hand
    current_round.deal_card!(@hand)
  end

  def stand
    current_round.end_hand! 
    @hand = current_round.current_hand
    render json: {}
  end

  def deal_dealer_hand
    @dealer_hand = current_round.run_out_dealer_board!
    current_round.evaluate_round!(@dealer_hand.score, current_user)
    session[:round] = nil
  end

  def split
    @hands = current_round.split_hand!
  end

  def double_down
    @hand = current_round.double_down!
    current_round.end_hand!
  end

  def current_bank
    
  end

end