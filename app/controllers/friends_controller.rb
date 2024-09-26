class FriendsController < ApplicationController
  before_action :set_friend, only: %i[ update destroy ]

  # GET /friends
  def index
    @friends = Friend.all

    render json: @friends
  end

  # GET /friends/show
  #フレンドのリストを返す関数
  def show
    # user_id をリクエストから取得
    user_id = friend_show_params[:serach_user_id]
    #user_idからfriendのリストを取得
    if @friend=Friend.where(A_user_id: user_id).or(Friend.where(B_user_id: user_id))
      render json: @friend
    else
      render json: { error: 'No friends found' }, status: :unprocessable_entity
    end
  end

  def add
    #bodyからuser_idの取り出し
    user_a = friend_params[:A_user_id].to_i
    user_b = friend_params[:B_user_id].to_i  

    #指定されたidが等しいまたは0より小さい場合挿入できない
    if user_a==user_b||user_a<0||user_b<0
      render json: { error: 'Invalid user IDs' }, status: :unprocessable_entity and return
    end
    #それぞれのuser_idから小さい方をA_user_idに設定(UNIQ制約をAとBに持たせているが順不同ははじけないため)
    # 例 A_user_id:1 B_user_id:2のレコードがある場合
    # 例 A_user_id:1 B_user_id:2は制約で弾けるがA_user_id:2 B_user_id:1は弾けない
    if user_a<user_b
      @friend = Friend.new(A_user_id:user_a,B_user_id:user_b)
    else
      @friend = Friend.new(A_user_id:user_b,B_user_id:user_a)
    end

    if @friend.save
      render json: @friend, status: :created, location: @friend
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end
  # DELETE /friends/1
  def destroy
    @friend.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:A_user_id, :B_user_id)
    end

    def friend_show_params
      params.require(:friend).permit(:serach_user_id)
    end
end
