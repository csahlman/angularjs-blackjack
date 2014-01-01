class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest
      t.boolean :guest, default: true
      t.string :name
      t.string :email
      t.string :remember_token
      t.integer :funds, default: 1000
      t.boolean :high_roller

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :remember_token, unique: true
  end
end
