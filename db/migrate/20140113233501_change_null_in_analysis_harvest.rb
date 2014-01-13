class ChangeNullInAnalysisHarvest < ActiveRecord::Migration
  def change
    change_column :analysis_requests, :harvest, :integer
  end
end
