require 'test_helper'

class AnalysisRequestsControllerTest < ActionController::TestCase
  setup do
    @analysis = Fabricate(:analysis_request)
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

  test 'should download cardboard of analysis' do
    get :download_cardboard, id: @analysis
    assert_response :success
    assert_equal(
     File.open(
       @analysis.reload.file_path(:cardboard), encoding: 'ASCII-8BIT'
     ).read, @response.body
    )
  end

  test 'should download form of analysis' do
    get :download_form, id: @analysis
    assert_response :success
    assert_equal(
     File.open(
       @analysis.reload.file_path(:form), encoding: 'ASCII-8BIT'
     ).read, @response.body
    )
  end

  test "should get edit" do
    get :edit, id: @analysis
    assert_response :success
    assert_not_nil assigns(:analysis_request)
    assert_select '#unexpected_error', false
    assert_template "analysis_requests/edit"
  end

  test "should update analysis_request" do
    put :update, id: @analysis, analysis_request: { harvest: 1970 }
    assert_redirected_to analysis_request_url(assigns(:analysis_request))
  end

  test "should destroy analysis_request" do
    assert !@analysis.deleted?

    assert_no_difference 'AnalysisRequest.count' do
      delete :destroy, id: @analysis
    end

    assert @analysis.reload.deleted?
    assert_redirected_to analysis_requests_url
  end

  test "should get index with try edit a deleted" do
    assert @analysis.update(deleted_at: Time.now)

    get :edit, id: @analysis
    assert_redirected_to analysis_requests_url
  end
end
