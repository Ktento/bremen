class CreateUserTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tracks, null: false, foreign_key: true

      t.timestamps
    end
  end
end
