class AddFieldsToHands < ActiveRecord::Migration
  def change
    add_column :hands, :dealt, :boolean, default: false
    change_column :hands, :current, :boolean, default: false
  end
end
