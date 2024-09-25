class TracksController < ApplicationController
  before_action :set_track, only: %i[ show update destroy ]

  # GET /tracks
  def index
    @tracks = Track.all

    render json: @tracks
  end

  # GET /tracks/1
  def show
    render json: @track
  end

  # GET /tracks/search?track_name=曲名
  def search
    track_name = params[:track_name]

    # Spotify API の認証
    RSpotify.authenticate("c88268e353d2472c8ca1167a66091f88", "4e5aed842f334262b3cc2691f44198cc")
    
    # 曲名を含むトラックを検索
    tracks = RSpotify::Track.search(track_name)

    # 結果を日本語で取得
    ENV['ACCEPT_LANGUAGE'] = "ja"

    render json: tracks
  end

  # POST /tracks
  def create
    @track = Track.new(track_params)

    if @track.save
      render json: @track, status: :created, location: @track
    else
      render json: @track.errors, status: :unprocessable_entity
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
