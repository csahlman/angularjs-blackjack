class AddStuffToHands < ActiveRecord::Migration
  def change
    add_column :hands, :blackjack, :boolean, default: false
    add_column :hands, :bought_insurance, :boolean, default: false
    add_column :hands, :net_payout, :integer, default: 0
    add_column :hands, :wager, :integer
  end
end
