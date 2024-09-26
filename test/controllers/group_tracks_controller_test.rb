require "test_helper"

class GroupTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_track = group_tracks(:one)
  end

  test "should get index" do
    get group_tracks_url, as: :json
    assert_response :success
  end

  test "should create group_track" do
    assert_difference("GroupTrack.count") do
      post group_tracks_url, params: { group_track: { Group_id: @group_track.Group_id, Track_id: @group_track.Track_id, listen_count: @group_track.listen_count } }, as: :json
    end

    assert_response :created
  end

  test "should show group_track" do
    get group_track_url(@group_track), as: :json
    assert_response :success
  end

  test "should update group_track" do
    patch group_track_url(@group_track), params: { group_track: { Group_id: @group_track.Group_id, Track_id: @group_track.Track_id, listen_count: @group_track.listen_count } }, as: :json
    assert_response :success
  end

  test "should destroy group_track" do
    assert_difference("GroupTrack.count", -1) do
      delete group_track_url(@group_track), as: :json
    end

    assert_response :no_content
  end
end
