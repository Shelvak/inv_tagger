class AddFieldsToAnalysisRequest < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :special_analysis, :boolean, default: false
    add_column :analysis_requests, :tasting, :boolean, default: false
    add_column :analysis_requests, :copies, :integer, default: 1
  end
end
