class AddCreatedUpdatedAtToEmploymentStatuses < ActiveRecord::Migration[6.0]
  def change
    # --- 就業状況テーブルにカラムを追加
    add_column(:employment_statuses, :created_at, :datetime, precision: 6, null: false)
    add_column(:employment_statuses, :updated_at, :datetime, precision: 6, null: false)
  end
end
