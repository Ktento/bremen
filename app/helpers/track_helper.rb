# frozen_string_literal: true

module TrackHelper
  def add_track(track_id, youtube_url)
    # 既存のトラックを確認
    existing_track = Track.find_by(sp_track_id: track_id)
    return { success: false, message: 'Track already exists' } if existing_track

    begin
      # Spotify APIの認証
      RSpotify.authenticate('c88268e353d2472c8ca1167a66091f88', '4e5aed842f334262b3cc2691f44198cc')
      ENV['ACCEPT_LANGUAGE'] = 'ja'
      # Spotifyからトラック情報を取得
      track = RSpotify::Track.find(track_id)

      # 複数アーティストの名前とIDを取得し、カンマ区切りで保存
      artist_names = track.artists.map(&:name).join(',')
      artist_ids = track.artists.map(&:id).join(',')

      # アーティストが持つジャンルを結合
      artist_genres = track.artists.flat_map(&:genres).uniq.join(', ')

      # データベースに曲を保存
      @track = Track.new(
        track_name: track.name,
        track_artist: artist_names, # 全アーティスト名を保存
        track_category: artist_genres, # 全アーティストのジャンルを結合して保存
        spotify_url: track.external_urls['spotify'],
        youtube_url: youtube_url, # YouTube URLを保存
        image_url: track.album.images.first['url'],
        sp_track_id: track.id, # トラックIDを保存
        sp_artist_id: artist_ids # 全アーティストのIDをカンマ区切りで保存
      )

      if @track.save
        { success: true, message: 'Track successfully added', track: @track }
      else
        { success: false, message: 'Failed to save track', errors: @track.errors.full_messages }
      end
    rescue RSpotify::NotFound
      { success: false, message: 'Track not found on Spotify' }
    rescue StandardError => e
      { success: false, message: "An error occurred: #{e.message}" }
    end
  end
end
