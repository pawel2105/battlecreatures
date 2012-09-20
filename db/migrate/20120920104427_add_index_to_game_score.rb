class AddIndexToGameScore < ActiveRecord::Migration
  def change
    add_index :games, :score
    add_index :games, :created_at
  end
end
