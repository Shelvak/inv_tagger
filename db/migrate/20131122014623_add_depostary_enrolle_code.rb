class AddDepostaryEnrolleCode < ActiveRecord::Migration
  def change
    add_column :analysis_requests, :depositary_enrolle_code, :string, limit: 7
  end
end
