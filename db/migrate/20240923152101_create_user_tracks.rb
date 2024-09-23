class CreateUserTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tracks do |t|
      t.references :User, null: false, foreign_key: true
      t.references :Group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
