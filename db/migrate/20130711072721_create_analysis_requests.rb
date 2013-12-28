class CreateAnalysisRequests < ActiveRecord::Migration
  def change
    create_table :analysis_requests do |t|
      t.string :enrolle_code, null: false, limit: 7
      t.integer :product_code, null: false
      t.integer :variety_codes, array: true, default: []
      t.date    :generated_at, null: false
      t.integer :destiny_codes, array: true, default: []

      t.timestamps
    end

    add_index :analysis_requests, :enrolle_code
  end
end
