require 'test_helper'

class AnalysisRequestsControllerTest < ActionController::TestCase
  setup do
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
    get :show, id: Fabricate(:analysis_request).id
    assert_response :success
    assert_not_nil assigns(:analysis_request)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/show"
  end
end
