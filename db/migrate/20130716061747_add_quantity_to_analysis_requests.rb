class AddQuantityToAnalysisRequests < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :quantity, :integer, null: false
  end
end
