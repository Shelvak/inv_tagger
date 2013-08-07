class AddDeletedAtToAnalysis < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :deleted_at, :datetime
  end
end
