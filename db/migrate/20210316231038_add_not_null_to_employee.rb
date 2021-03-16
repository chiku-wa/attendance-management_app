class AddNotNullToEmployee < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:employees, :employment_status_id, false)
  end
end
