class UserTracksController < ApplicationController
  before_action :set_user_track, only: %i[ show update destroy ]

  # GET /user_tracks
  def index
    @user_tracks = UserTrack.all

    render json: @user_tracks
  end

  # GET /user_tracks/1
  def show
    render json: @user_track
  end

  # POST /user_tracks/add お気に入り曲の登録
  def add

    # user_id をリクエストから取得
    user_id = user_track_params[:user_id]
    # user_idでユーザーを検索
    user = User.find_by(user_id: user_id)
    # userが存在しなかったときの処理
    if user.nil?
      render json: { error: "User not found" }, status: :unprocessable_entity
      return
    end

    # track_idをリクエストから取得
    track_id = user_track_params[:track_id]
    # track_idでトラックを検索
    track = Track.find_by(id: track_id)
    # トラックが存在しなかったときの処理
    if track.nil?
      render json: { error: "Track not found" }, status: :unprocessable_entity
      return
    end

    @user_track = UserTrack.new(user_id: user.user_id, track_id: user_track_params[:track_id])

    puts user_id
    puts track_id
    puts "aaaaaaaaaaaaaaaaaaaaaa"

    if @user_track.save
      render json: @user_track, status: :created, location: @user_track
    else
      render json: @user_track.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_tracks/1
  def destroy
    @user_track.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_track
      @user_track = UserTrack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_track_params
      params.require(:user_track).permit(:user_id, :track_id)
    end
end
