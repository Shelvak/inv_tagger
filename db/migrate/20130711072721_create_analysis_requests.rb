class CreateAnalysisRequests < ActiveRecord::Migration
  def change
    create_table :analysis_requests do |t|
      t.string :enrolle_code, null: false, limit: 7
      t.integer :product_code, null: false
      t.integer :variety_code, null: false
      t.date    :generated_at, null: false

      t.timestamps
    end
  end
end
