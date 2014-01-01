class AddMoneyInPlayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :money_in_play, :integer
    add_column :users, :wager_amount, :integer, default: 50
  end
end
