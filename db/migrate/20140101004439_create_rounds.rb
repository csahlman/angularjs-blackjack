class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.boolean :current, default: true
      t.string :status

      t.timestamps
    end
  end
end
