class AddObservationsToAnalysis < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :observations, :text
  end
end
