class AddSourceAnalysisToAnalysisRequest < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :source_analysis, :text
  end
end
