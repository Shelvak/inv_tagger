class CreateAnalysisRequests < ActiveRecord::Migration
  def change
    create_table :analysis_requests do |t|
      t.integer :enrolle_id, null: false
      t.integer :product_id, null: false
      t.integer :variety_id, null: false
      t.date    :generated_at, null: false

      t.timestamps
    end
  end
end
