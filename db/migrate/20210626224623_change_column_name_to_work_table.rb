class ChangeColumnNameToWorkTable < ActiveRecord::Migration[6.0]
  def change
    rename_column(:work_tables, :employment_status_code, :status_code)
  end
end
