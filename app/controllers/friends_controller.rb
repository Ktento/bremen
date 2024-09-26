class FriendsController < ApplicationController
  # GET /friends
  # def index
  #   @friends = Friend.all

  #   render json: @friends
  # end

  # GET /friends/show
  #フレンドのリストを返す関数
  def show
    # user_id をリクエストから取得
    user_id = params[:search_user_id].to_i
    # 無効なIDのチェック
    if user_id<=0
      render json: { error: 'Invalid user IDs' }, status: :unprocessable_entity and return
    end
    #user_idからfriendのリストを取得
    @friends=Friend.where(A_user_id: user_id).or(Friend.where(B_user_id: user_id))
    # フレンドが一人以上の場合はそのリストを返す
    if @friends.any?
      render json: @friends
    else
      render json: { error: 'No friends found' }, status: :unprocessable_entity
    end
  end

  # POST /friends/add 
  def add
    #bodyからuser_idの取り出し
    user_a = friend_params[:A_user_id].to_i
    user_b = friend_params[:B_user_id].to_i  

    #無効なIDのチェック
    if user_a<=0||user_b<=0||user_a==user_b
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

  # DELETE /friends/del
  def del
    #bodyからuser_idの取り出し
    user_a = friend_params[:A_user_id].to_i
    user_b = friend_params[:B_user_id].to_i  

    #無効なIDのチェック
    if user_a<=0||user_b<=0||user_a==user_b
      render json: { error: 'Invalid user IDs' }, status: :unprocessable_entity and return
    end

    # user_a と user_b のどちらが A_user_id または B_user_id に該当するかを確認
    @friend = Friend.find_by(A_user_id: user_a, B_user_id: user_b) || Friend.find_by(A_user_id: user_b, B_user_id: user_a)
    
    #friendレコードの存在確認、存在してたら該当レコードを削除
    if @friend
      @friend.destroy
      render json: { message: 'Friend relationship deleted' }, status: :ok
    else
      render json: { error: 'Friend relationship not found' }, status: :not_found
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:A_user_id, :B_user_id)
    end
end
