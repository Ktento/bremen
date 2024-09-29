class GroupUsersController < ApplicationController
  before_action :set_group_user, only: %i[ show update destroy ]

  # POST /group_users
  def invite

    user_id = group_user_params[:user_id]
    group_id = group_user_params[:group_id]
    
    @group_id_search = GroupUser.find_by(group_id: group_id)
    @user_id_search = GroupUser.find_by(user_id: user_id)

    if user_id.blank? || group_id.blank?

      render json: { error: "Value is null" }, status: :unauthorized

  
    else

      @group_user = GroupUser.new(group_user_params)

      if @group_user.save
      
        render json: @group_user, status: :created, location: @group_user

      else

        render json: @group_user.errors, status: :unprocessable_entity

      end

    end

  end

  def from_userid_to_groupid
    user_id = params[:user_id]

    @group_id_search = GroupUser.where(user_id: user_id)

    if @group_id_search
      render json: @group_id_search, status: :ok
    else
      render json: { error: "Group not found." }, status: :not_found

    end
  end

  def from_groupid_to_userid
    group_id = params[:group_id]

    @group_id_search = GroupUser.where(group_id: group_id)

    if @group_id_search
      render json: @group_id_search, status: :ok
    else
      render json: { error: "User not found." }, status: :not_found

    end
  end

  # GET /group_users
  def index
    @group_users = GroupUser.all

    render json: @group_users
  end




  # # GET /group_users/1
  # def show
  #   render json: @group_user
  # end


  # PATCH/PUT /group_users/1
  def update
    if @group_user.update(group_user_params)
      render json: @group_user
    else
      render json: @group_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /group_users/1
  def destroy
    @group_user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_user
      @group_user = GroupUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_user_params
      params.require(:group_user).permit(:user_id, :group_id)
    end

    def group_id_params
      params.require(:group_user).permit(:search_group_id)
    end

    def user_id_params
      params.require(:group_user).permit(:search_user_id)
    end
  end
