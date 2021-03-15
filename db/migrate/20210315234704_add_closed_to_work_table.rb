class AddClosedToWorkTable < ActiveRecord::Migration[6.0]
  def change
    add_column(:work_tables, :closed, :boolean, null: false)
  end
end
