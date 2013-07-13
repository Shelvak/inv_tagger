class CreateAnalysisRequests < ActiveRecord::Migration
  def change
    create_table :analysis_requests do |t|
      t.string :enrolle, null: false, limit: 7
      t.integer :product, null: false
      t.integer :variety, null: false
      t.date    :generated_at, null: false

      t.timestamps
    end
  end
end
