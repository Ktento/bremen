class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.string :A_user_id
      t.string :B_user_id

      t.timestamps
    end
  end
end
