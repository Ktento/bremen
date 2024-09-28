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

  #GET /users/login
  def login
    user_id=params[:user_id]
    password=params[:password]

    user=User.find_by(user_id: user_id)
    
    if user && user.authenticate(password)
      render json: { message: "Login successful", user: user }, status: :ok
    else
      render json: { error: "Invalid user ID or password" }, status: :unauthorized
    end

  end

  def search
    # user_id をリクエストから取得
    user_id = params[:search_user_id].to_i
    # 無効なIDのチェック
    if user_id<=0
      render json: { error: 'Invalid user IDs' }, status: :unprocessable_entity and return
    end
    #user_idからuserのリストを取得
    @users=User.where(user_id: user_id).select(:user_id, :user_name)
    # フレンドが一人以上の場合はそのリストを返す
    if @users.any?
      render json: @users
    else
      render json: { error: 'No users found' }, status: :unprocessable_entity
    end
  end

  # # GET /users
  # def index
  #   @users = User.all

  #   render json: @users
  # end

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
      params.require(:user).permit(:user_id, :user_name, :password, :password_confirmation)
    end
end
