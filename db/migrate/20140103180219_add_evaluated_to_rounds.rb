class AddEvaluatedToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :evaluated, :boolean, default: false
  end
end
