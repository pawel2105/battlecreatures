class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :word
      t.text :choices
      t.belongs_to :user

      t.timestamps
    end
    add_index :games, :user_id
  end
end
