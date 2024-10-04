# frozen_string_literal: true

class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.references :A_user, foreign_key: { to_table: :users }, null: false
      t.references :B_user, foreign_key: { to_table: :users }, null: false


      t.timestamps
    end
    # A_user_id と B_user_id の組み合わせが一意であることを保証
    add_index :friends, %i[A_user_id B_user_id], unique: true
  end
end
