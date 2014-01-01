class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.belongs_to :hand, index: true
      t.belongs_to :round, index: true
      t.integer :value
      t.integer :suit
      t.boolean :dealt

      t.timestamps
    end
  end
end
