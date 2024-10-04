# frozen_string_literal: true

require 'test_helper'

class GroupUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_user = group_users(:one)
  end

  test 'should get index' do
    get group_users_url, as: :json
    assert_response :success
  end

  test 'should create group_user' do
    assert_difference('GroupUser.count') do
      post group_users_url,
           params: { group_user: { group_id_id: @group_user.group_id_id, user_id_id: @group_user.user_id_id } }, as: :json
    end

    assert_response :created
  end

  test 'should show group_user' do
    get group_user_url(@group_user), as: :json
    assert_response :success
  end

  test 'should update group_user' do
    patch group_user_url(@group_user),
          params: { group_user: { group_id_id: @group_user.group_id_id, user_id_id: @group_user.user_id_id } }, as: :json
    assert_response :success
  end

  test 'should destroy group_user' do
    assert_difference('GroupUser.count', -1) do
      delete group_user_url(@group_user), as: :json
    end

    assert_response :no_content
  end
end
