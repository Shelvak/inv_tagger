class AnalysisRequestsController < ApplicationController
  before_filter :get_analysis_request, except: [:index, :new, :create]
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /analysis_requests
  def index
    @title = t('view.analysis_requests.index_title')
    @analysis_requests = AnalysisRequest.order(id: :desc).page(params[:page])
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

  # GET /analysis_requests/1/edit
  def edit
    @title = t('view.analysis_requests.edit_title')
    if @analysis_request.deleted?
      redirect_to analysis_requests_url, notice: t('view.analysis_requests.can_not_edit')
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
    if @analysis_request.destroy
      redirect_to analysis_requests_url, notice: t('view.analysis_requests.correctly_destroyed')
    else
      redirect_to_index_with_stale_error
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to_index_with_stale_error
  end

  # GET /analysis_requests/1/download_cardboard
  def download_cardboard
    @analysis_request.generate_cardboard

    file = File.open @analysis_request.reload.file_path(:cardboard)

    mime_type = Mime::Type.lookup_by_extension(File.extname(file)[1..-1])

    response.headers['Last-Modified'] = File.mtime(file).httpdate
    response.headers['Cache-Control'] = 'private, no-store'

    send_file file, type: (mime_type || 'application/octet-stream')
  end

  # GET /analysis_requests/1/download_form
  def download_form
    @analysis_request.generate_form

    file = File.open @analysis_request.reload.file_path(:form)

    mime_type = Mime::Type.lookup_by_extension(File.extname(file)[1..-1])

    response.headers['Last-Modified'] = File.mtime(file).httpdate
    response.headers['Cache-Control'] = 'private, no-store'

    send_file file, type: (mime_type || 'application/octet-stream')
  end

  private

  def redirect_to_index_with_stale_error
    redirect_to analysis_requests_url, alert: t('view.analysis_requests.stale_object_error')
  end

  def get_analysis_request
    @analysis_request = AnalysisRequest.find(params[:id])
  end

  def analysis_request_params
    params.require(:analysis_request).permit(
      :related_enrolle, :related_product, :related_varieties, :generated_at,
      :quantity, :related_destiny, :harvest, :observations, :request_type,
      :related_depositary_enrolle, :source_analysis, :special_analysis,
      :tasting, :copies
    )
  end
end
