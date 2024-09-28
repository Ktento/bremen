class TracksController < ApplicationController

  # # GET /tracks
  def index
    @track = Track.all

    render json: @track
  end

  # GET /tracks/search?track_name=曲名 　検索内容の候補を返す
  def search 
    track_name = params[:track_name].strip # (.strip)空白や改行を取り除く
    # 曲名が正しく入力されているか確認
    if track_name.blank?
      render json: { error: 'Please enter a track name' }, status: :bad_request
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
        render json: { message: "Tracks not found" }, status: :not_found
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end


  # GET /tracks/show?track_id=トラックID　　track_idから曲の情報を返す関数
  def show
    begin
      track_id = Integer(params[:track_id])
    rescue ArgumentError
      render json: { error: 'Invalid track ID. Please enter a number' }, status: :bad_request
      return
    end

    # トラックIDが空白かどうかを確認
    if track_id.blank?
      render json: { error: 'Please enter a track ID' }, status: :bad_request
      return
    end

    begin
      # データベースからトラックを検索
      @track = Track.find(track_id)

      if @track
        # トラック情報をJSONで返す
        render json: @track
      else
        render json: { message: "Track not found" }, status: :not_found
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No track exists with the specified ID" }, status: :not_found
    rescue StandardError => e
      render json: { error: "An internal server error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  def listencount_orderby_track
    @listencount_orderby_result = Track.order(listen_count: :desc).limit(10)

    render json: @listencount_orderby_result, status: :ok

  end

  # POST /tracks/add
  def add
    
    track_id = add_track_params[:track_id]
    youtube_url = add_track_params[:youtube_url] # 同様にyoutube_urlを取得（もしあれば）


    # 空白でないかチェック
    if track_id.blank?
      render json: { error: "Please specify a track ID" }, status: :bad_request
      return
    end

    # 既存のトラックを確認
    existing_track = Track.find_by(sp_track_id: track_id)
    if existing_track
      render json: { message: "This track is already registered", track: existing_track }, status: :conflict
      return
    end

    begin
      # Spotify APIの認証
      RSpotify.authenticate("c88268e353d2472c8ca1167a66091f88", "4e5aed842f334262b3cc2691f44198cc")
      ENV['ACCEPT_LANGUAGE'] = "ja"
      # Spotifyからトラック情報を取得
      track = RSpotify::Track.find(track_id)

      # 複数アーティストの名前とIDを取得し、カンマ区切りで保存
      artist_names = track.artists.map(&:name).join(",")
      artist_ids = track.artists.map(&:id).join(",")

      # アーティストが持つジャンルを結合
      artist_genres = track.artists.flat_map(&:genres).uniq.join(", ")

      # トラックが存在しない場合の処理
      if track.nil?
        render json: { error: "The specified track was not found" }, status: :not_found
        return
      end

      puts track.name
      puts artist_names
      puts artist_genres
      puts track.external_urls['spotify']
      puts youtube_url
      puts track.album.images.first['url']
      puts track.id
      puts artist_ids


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
        render json: @track, status: :created, location: @track
      else
        render json: @track.errors, status: :unprocessable_entity
      end
    rescue RSpotify::NotFound
      render json: { error: "The specified track was not found" }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def count_up_listen_track

    listen_add_track_id = count_up_listen_params[:listen_add_track_id]

    @track_addlisten = Track.find_by(id: listen_add_track_id)


    if @track_addlisten

      @track_addlisten.increment!(:listen_count)  # listen_countを1増やす
      render json: { message: "Success", listen_count: @track_addlisten.listen_count }, status: :ok

    else

      render json: { error: "Invaild sp_artist_id or sp_track_id " }, status: :unauthorized

    end
  end




  # # PATCH/PUT /tracks/1
  # #def update
  #   if @track.update(track_params)
  #     render json: @track
  #   else
  #     render json: @track.errors, status: :unprocessable_entity
  #   end
  # end

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

    def add_track_params
      params.require(:track).permit(:track_id,:youtube_url)
    end

    def count_up_listen_params
      params.require(:track).permit(:listen_add_track_id)
    end

    def listencount_params
      params.require(:track).permit(:listen_count)
    end
end
