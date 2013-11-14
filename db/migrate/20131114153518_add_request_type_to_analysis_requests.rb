class AddRequestTypeToAnalysisRequests < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :request_type, :string, limit: 1,
      default: AnalysisRequest::REQUEST_TYPES.invert['preferential']
  end
end
