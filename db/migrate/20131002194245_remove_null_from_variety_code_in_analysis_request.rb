class RemoveNullFromVarietyCodeInAnalysisRequest < ActiveRecord::Migration
  def change
    change_column :analysis_requests, :variety_code, :integer, null: true
  end
end
