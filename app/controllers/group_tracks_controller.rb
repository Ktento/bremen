class GroupTracksController < ApplicationController
  before_action :set_group_track, only: %i[ show update destroy ]

  # GET /group_tracks
  def index
    @group_tracks = GroupTrack.all

    render json: @group_tracks
  end

  # GET /group_tracks/1
  def show
    render json: @group_track
  end

  # POST /group_tracks
  def create
    @group_track = GroupTrack.new(group_track_params)

    if @group_track.save
      render json: @group_track, status: :created, location: @group_track
    else
      render json: @group_track.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /group_tracks/1
  def update
    if @group_track.update(group_track_params)
      render json: @group_track
    else
      render json: @group_track.errors, status: :unprocessable_entity
    end
  end

  # DELETE /group_tracks/1
  def destroy
    @group_track.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_track
      @group_track = GroupTrack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_track_params
      params.require(:group_track).permit(:Group_id, :Track_id, :listen_count)
    end
end
