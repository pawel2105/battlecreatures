class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :value
      t.timestamps
    end
    add_index :words, :value, :unique => true
  end
end
