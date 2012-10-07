class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.string 			:opponent
      t.text 				:choices
      t.integer 		:score
      t.belongs_to	:user

      t.timestamps
    end
    add_index :battles, :user_id
    add_index :battles, :score
    add_index :battles, :created_at
  end
end
