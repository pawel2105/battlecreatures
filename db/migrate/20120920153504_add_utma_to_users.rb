class AddUtmaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :utma, :string
  end
end
