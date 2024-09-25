class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.references :A_user, foreign_key: { to_table: :users }, null: false
      t.references :B_user, foreign_key: { to_table: :users }, null: false


      t.timestamps
    end
  end
end
