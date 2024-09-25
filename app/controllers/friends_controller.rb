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
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # POST /friends
  def create
    @friend = Friend.new(friend_params)

    if @friend.save
      render json: @friend, status: :created, location: @friend
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friends/1
  def update
    if @friend.update(friend_params)
      render json: @friend
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
