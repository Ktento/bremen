class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy ]
  
  # POST/users/signup
  def signup
    # user_id をリクエストから取得
    user_id = user_params[:user_id]

    # user_idでユーザーを検索
    user = User.find_by(user_id: user_id)

    #未登録であればアカウントを作成する
    if user
      # ユーザーが見つかれば、アカウントを登録は行わない
      render json: { error: "User already exists" }, status: :unauthorized
    else
      # ユーザーが見つからない場合は未登録なので登録処理を行う
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end      
    end

  end

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_id, :user_name, :user_pass)
    end
end
