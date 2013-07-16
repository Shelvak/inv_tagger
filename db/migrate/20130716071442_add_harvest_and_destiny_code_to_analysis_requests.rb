class AddHarvestAndDestinyCodeToAnalysisRequests < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :harvest, :integer, null: false
    add_column :analysis_requests, :destiny_code, :integer, null: false
  end
end
