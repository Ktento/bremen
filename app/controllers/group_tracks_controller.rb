class GroupTracksController < ApplicationController

  def findtrack
    group_track_id = params[:group_track_result]
    @group_track_list = GroupTrack.find_by(group_id: group_track_id)

    if @group_track_list

      render json: @group_track_list, status: :ok

    else 

      render json: { error: "Group_id is null" }, status: :unauthorized

    end
  end

  def count_up_listen_group
    listen_add_group_id = countup_listen_params[:listen_add_group_id]
    listen_add_track_id= countup_listen_params[:listen_add_track_id]

    @group_addlisten = GroupTrack.find_by(group_id: listen_add_group_id, track_id: listen_add_track_id)


    if @group_addlisten

      @group_addlisten.increment!(:listen_count)  # listen_countを1増やす
      render json: { message: "Success", listen_count: @group_addlisten.listen_count }, status: :ok

    else

      render json: { error: "Invaild GroupID or TrackID" }, status: :unauthorized

    end
  end

  def add
    # group_id,track_id をリクエストから取得
    group_id = group_track_params[:group_id].to_i
    track_id = group_track_params[:track_id].to_i


    #無効なIDのチェック
    if group_id<=0||track_id<=0
      render json: { error: 'Invalid group IDs or track IDs' }, status: :unprocessable_entity and return
    end

    #既に存在しないかの確認
    if GroupTrack.exists?(group_id: group_id, track_id: track_id)
      render json: { error: 'This track already exists for the group' }, status: :conflict and return
    end

    @group_track = GroupTrack.new(group_track_params)
    if @group_track.save
      render json: @group_track, status: :created, location: @group_track
    else
      render json: @group_track.errors, status: :unprocessable_entity
    end      

  end


  def listcount_orderby
    @listcount_orderby_result = GroupTrack.order(listen_count: :desc)

    render json: @listcount_orderby_result, status: :ok

  end

  def show
    render json: @user
  end

    def index
      @group_track = GroupTrack.all
  
       render json: @group_track
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_track
      @group_track = GroupTrack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_track_params
      params.require(:group_track).permit(:group_id, :track_id)
    end

    def group_track_find
      params.require(:group_track).permit(:group_track_result)
    end

    def countup_listen_params
      params.require(:group_track).permit(:listen_add_group_id, :listen_add_track_id)
    end

    def listcount_params
      params.require(:group_track).permit(:list_count)
    end
end
