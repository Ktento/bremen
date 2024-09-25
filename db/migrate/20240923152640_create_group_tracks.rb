class CreateGroupTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :group_tracks do |t|
      t.references :group, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :listen_count

      t.timestamps
    end
  end
end