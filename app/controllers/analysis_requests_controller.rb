class AnalysisRequestsController < ApplicationController
  before_action :set_analysis_request, only:  [:show, :edit, :update, :destroy]
  
  # GET /analysis_requests
  def index
    @title = t('view.analysis_requests.index_title')
    @analysis_requests = AnalysisRequest.page(params[:page])
  end

  # GET /analysis_requests/1
  def show
    @title = t('view.analysis_requests.show_title')
  end

  # GET /analysis_requests/new
  def new
    @title = t('view.analysis_requests.new_title')
    @analysis_request = AnalysisRequest.new
  end

  # GET /analysis_requests/1/edit
  def edit
    @title = t('view.analysis_requests.edit_title')
  end

  # POST /analysis_requests
  def create
    @title = t('view.analysis_requests.new_title')
    @analysis_request = AnalysisRequest.new(analysis_request_params)

    respond_to do |format|
      if @analysis_request.save
        format.html { redirect_to @analysis_request, notice: t('view.analysis_requests.correctly_created') }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /analysis_requests/1
  def update
    @title = t('view.analysis_requests.edit_title')

    respond_to do |format|
      if @analysis_request.update(analysis_request_params)
        format.html { redirect_to @analysis_request, notice: t('view.analysis_requests.correctly_updated') }
      else
        format.html { render action: 'edit' }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_analysis_request_url(@analysis_request), alert: t('view.analysis_requests.stale_object_error')
  end

  # DELETE /analysis_requests/1
  def destroy
    @analysis_request.destroy
    redirect_to analysis_requests_url, notice: t('view.analysis_requests.correctly_destroyed')
  end

  private

  def set_analysis_request
    @analysis_request = AnalysisRequest.find(params[:id])
  end

  def analysis_request_params
    params.require(:analysis_request).permit(
      :enrolle, :product, :variety, :generated_at
    )
  end
end
