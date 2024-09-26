class TracksController < ApplicationController

  # GET /tracks/search?track_name=曲名 　検索内容の候補を返す
  def search 
    track_name = params[:track_name].strip # (.strip)空白や改行を取り除く
    # 曲名が正しく入力されているか確認
    if track_name.blank?
      render json: { error: '曲名を入力してください' }, status: :bad_request
      return
    end
  
    begin
      # Spotify APIの認証
      RSpotify.authenticate("c88268e353d2472c8ca1167a66091f88", "4e5aed842f334262b3cc2691f44198cc")
      # 結果を日本語で取得
      ENV['ACCEPT_LANGUAGE'] = "ja"
      # 曲を検索
      tracks = RSpotify::Track.search(track_name)
       
      # 結果があれば返す
      if tracks.any?
        render json: tracks.map { |track| 
          {
            id: track.id, # トラックのIDを追加
            track_name: track.name,

            artists: track.artists.map { |artist| 
              { 
                id: artist.id, # アーティストのIDを追加
                name: artist.name, 
              }
            },

            album: track.album.name,
            image_url: track.album.images.first['url'] # 画像URL
          } 
        }
      else
        render json: { message: "曲が見つかりませんでした。" }, status: :not_found
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # POST /tracks  トラックIDとyoutubeURLから曲を検索し、DBに登録する処理を作成中
  def create
    track_id = params[:track_id]

    if track_id.blank?
      render json: { error: 'トラックIDを指定してください' }, status: :bad_request
      return
    end

    begin
      # Spotify APIの認証
      RSpotify.authenticate("c88268e353d2472c8ca1167a66091f88", "4e5aed842f334262b3cc2691f44198cc")
      ENV['ACCEPT_LANGUAGE'] = "ja"

      # Spotifyからトラック情報を取得
      track = RSpotify::Track.find(track_id)

      # 複数アーティストの名前とIDを取得し、カンマ区切りで保存
      artist_names = track.artists.map(&:name).join(", ")
      artist_ids = track.artists.map(&:id).join(", ")

      # アーティストが持つジャンルを結合
      artist_genres = track.artists.flat_map(&:genres).uniq.join(", ")

      # トラックが存在しない場合の処理
      if track.nil?
        render json: { error: "指定されたトラックが見つかりませんでした。" }, status: :not_found
        return
      end

      # データベースに曲を保存
      @track = Track.new(
        track_name: track.name,
        track_artist: artist.name, # アーティスト名を保存
        track_category: artist_genres, # アーティストのジャンルを保存
        spotify_url: track.external_urls['spotify'],
        youtube_url: params[:youtube_url] || nil, # YouTube URLがあれば使用、なければnull
        image_url: track.album.images.first['url'],
        sp_track_id: track.id, # トラックIDを保存
        sp_artist_id: artist.id # アーティストIDを保存
      )

      if @track.save
        render json: @track, status: :created, location: @track
      else
        render json: @track.errors, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end


  # PATCH/PUT /tracks/1
  def update
    if @track.update(track_params)
      render json: @track
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tracks/1
  def destroy
    @track.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def track_params
      params.require(:track).permit(:track_name, :track_category, :track_artist, :spotify_url, :youtube_url, :image_url)
    end
end
