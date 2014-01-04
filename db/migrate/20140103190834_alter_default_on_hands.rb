class AlterDefaultOnHands < ActiveRecord::Migration
  def change
    change_column :hands, :current, :boolean, default: true
  end
end
