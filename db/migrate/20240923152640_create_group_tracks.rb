# frozen_string_literal: true

class CreateGroupTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :group_tracks do |t|
      t.references :group, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :listen_count, default: 0
      t.timestamps
    end
    add_index :group_tracks, %i[group_id track_id], unique: true
  end
end
