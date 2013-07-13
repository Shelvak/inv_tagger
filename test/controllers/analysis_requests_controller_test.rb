require 'test_helper'

class AnalysisRequestsControllerTest < ActionController::TestCase

  setup do
    @analysis_request = Fabricate(:analysis_request)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:analysis_requests)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:analysis_request)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/new"
  end

  test "should create analysis_request" do
    assert_difference('AnalysisRequest.count') do
      post :create, analysis_request: Fabricate.attributes_for(:analysis_request)
    end

    assert_redirected_to analysis_request_url(assigns(:analysis_request))
  end

  test "should show analysis_request" do
    get :show, id: @analysis_request
    assert_response :success
    assert_not_nil assigns(:analysis_request)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/show"
  end

  test "should get edit" do
    get :edit, id: @analysis_request
    assert_response :success
    assert_not_nil assigns(:analysis_request)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/edit"
  end

  test "should update analysis_request" do
    put :update, id: @analysis_request, 
      analysis_request: { generated_at: 1.day.from_now }
    assert_redirected_to analysis_request_url(assigns(:analysis_request))
  end

  test "should destroy analysis_request" do
    assert_difference('AnalysisRequest.count', -1) do
      delete :destroy, id: @analysis_request
    end

    assert_redirected_to analysis_requests_url
  end
end
