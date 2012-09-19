class AddRatingsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :weekly_rating, default: 0
      t.integer :monthly_rating, default: 0
      t.integer :yearly_rating, default: 0
    end
    change_table :users do |t|
      t.index :weekly_rating
      t.index :monthly_rating
      t.index :yearly_rating
    end
  end
end
