class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show update destroy ]


  # POST /groups
  def insert
     group_name = group_params[:group_name]

     group = Group.find_by(group_name: group_name)

  if group_name.blank?

    render json: { error: "Group name is null" }, status: :unprocessable_entity

  else

    @group = Group.new(group_params)

    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end
end

# GET /groups
  def index
    @groups = Group.all

    render json: @groups
  end

# GET /groups/1
  def show
    render json: @group
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:group_name)
    end
end
