class UserTracksController < ApplicationController
  before_action :set_user_track, only: %i[ show update destroy ]

  # # GET /user_tracks
  # def index
  #   @user_tracks = UserTrack.all

  #   render json: @user_tracks
  # end

  # GET /user_tracks/1
  def show
    render json: @user_track
  end

  # POST /user_tracks
  def create
    @user_track = UserTrack.new(user_track_params)

    if @user_track.save
      render json: @user_track, status: :created, location: @user_track
    else
      render json: @user_track.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_tracks/1
  def update
    if @user_track.update(user_track_params)
      render json: @user_track
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
      params.require(:user_track).permit(:User_id, :Group_id)
    end
end
