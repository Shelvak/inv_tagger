class AnalysisRequestsController < ApplicationController
  
  # GET /analysis_requests
  def index
    @title = t('view.analysis_requests.index_title')
    @analysis_requests = AnalysisRequest.page(params[:page])
  end

  # GET /analysis_requests/1
  def show
    @analysis_request = AnalysisRequest.find(params[:id])
    @title = t('view.analysis_requests.show_title', owner: @analysis_request.to_s)
  end

  # GET /analysis_requests/new
  def new
    @title = t('view.analysis_requests.new_title')
    @analysis_request = AnalysisRequest.new
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

  private

  def analysis_request_params
    params.require(:analysis_request).permit(
      :related_enrolle, :related_product, :related_variety, :generated_at
    )
  end
end
