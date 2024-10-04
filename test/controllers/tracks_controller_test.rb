# frozen_string_literal: true

require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one)
  end

  test 'should get index' do
    get tracks_url, as: :json
    assert_response :success
  end

  test 'should create track' do
    assert_difference('Track.count') do
      post tracks_url,
           params: { track: { image_url: @track.image_url, spotify_url: @track.spotify_url, track_artist: @track.track_artist, track_category: @track.track_category, track_name: @track.track_name, youtube_url: @track.youtube_url } }, as: :json
    end

    assert_response :created
  end

  test 'should show track' do
    get track_url(@track), as: :json
    assert_response :success
  end

  test 'should update track' do
    patch track_url(@track),
          params: { track: { image_url: @track.image_url, spotify_url: @track.spotify_url, track_artist: @track.track_artist, track_category: @track.track_category, track_name: @track.track_name, youtube_url: @track.youtube_url } }, as: :json
    assert_response :success
  end

  test 'should destroy track' do
    assert_difference('Track.count', -1) do
      delete track_url(@track), as: :json
    end

    assert_response :no_content
  end
end
