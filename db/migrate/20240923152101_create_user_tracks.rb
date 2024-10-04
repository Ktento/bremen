# frozen_string_literal: true

class CreateUserTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.timestamps
    end
    add_index :user_tracks, %i[user_id track_id], unique: true
  end
end
