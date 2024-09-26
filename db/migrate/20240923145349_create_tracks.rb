class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :track_name
      t.string :track_category
      t.string :track_artist
      t.string :spotify_url
      t.string :youtube_url
      t.string :image_url

      t.timestamps
    end
  end
end
