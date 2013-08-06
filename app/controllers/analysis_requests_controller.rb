class AnalysisRequestsController < ApplicationController
  before_filter :get_analysis_request, only: [:show, :download_cardboard]
  
  # GET /analysis_requests
  def index
    @title = t('view.analysis_requests.index_title')
    @analysis_requests = AnalysisRequest.page(params[:page])
  end

  # GET /analysis_requests/1
  def show
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

  # GET /analysis_requests/1/download_cardboard
  def download_cardboard
    @analysis_request.generate_cardboard

    file = File.open(
      Rails.root.join('tmp', 'to_print', "#{@analysis_request.id}.pdf")
    )
    mime_type = Mime::Type.lookup_by_extension(File.extname(file)[1..-1])
                                                                                
    response.headers['Last-Modified'] = File.mtime(file).httpdate
    response.headers['Cache-Control'] = 'private, no-store'

    send_file file, type: (mime_type || 'application/octet-stream')
  end

  private

  def get_analysis_request
    @analysis_request = AnalysisRequest.find(params[:id])
  end

  def analysis_request_params
    params.require(:analysis_request).permit(
      :related_enrolle, :related_product, :related_variety, :generated_at,
      :quantity, :related_destiny, :harvest, :observations
    )
  end
end
