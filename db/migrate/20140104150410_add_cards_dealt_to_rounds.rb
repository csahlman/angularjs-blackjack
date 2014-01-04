class AddCardsDealtToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :cards_dealt, :integer, default: 0
  end
end
