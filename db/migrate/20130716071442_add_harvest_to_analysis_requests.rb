class AddHarvestToAnalysisRequests < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :harvest, :integer, null: false
  end
end
