class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :uid
      t.string  :utma
      t.string  :provider
      t.integer :daily_score, default: 0
      t.integer :weekly_score, default: 0

      t.timestamps
    end
    add_index :users, [:uid, :provider]
  end
end
