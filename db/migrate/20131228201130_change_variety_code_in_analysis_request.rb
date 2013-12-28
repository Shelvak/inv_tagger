class ChangeVarietyCodeInAnalysisRequest < ActiveRecord::Migration
  def change
    # The integer array cast can't be with change...
    remove_column :analysis_requests, :variety_code
    add_column :analysis_requests, :variety_codes, :integer, array: true, default: []
  end
end
