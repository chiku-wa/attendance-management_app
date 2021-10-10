class RenameEmploymentStatusesIdToEmploymentStatusId < ActiveRecord::Migration[6.0]
  def up
    rename_column(:employees, :employment_statuses_id, :employment_status_id)
  end
end
