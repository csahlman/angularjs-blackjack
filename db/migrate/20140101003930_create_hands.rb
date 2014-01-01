class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.belongs_to :round, index: true
      t.belongs_to :user, index: true
      t.boolean :dealer
      t.boolean :current, default: true
      t.integer :score
      t.boolean :played

      t.timestamps
    end
  end
end
