require "test_helper"

class UserTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_track = user_tracks(:one)
  end

  test "should get index" do
    get user_tracks_url, as: :json
    assert_response :success
  end

  test "should create user_track" do
    assert_difference("UserTrack.count") do
      post user_tracks_url, params: { user_track: { Group_id: @user_track.Group_id, User_id: @user_track.User_id } }, as: :json
    end

    assert_response :created
  end

  test "should show user_track" do
    get user_track_url(@user_track), as: :json
    assert_response :success
  end

  test "should update user_track" do
    patch user_track_url(@user_track), params: { user_track: { Group_id: @user_track.Group_id, User_id: @user_track.User_id } }, as: :json
    assert_response :success
  end

  test "should destroy user_track" do
    assert_difference("UserTrack.count", -1) do
      delete user_track_url(@user_track), as: :json
    end

    assert_response :no_content
  end
end
