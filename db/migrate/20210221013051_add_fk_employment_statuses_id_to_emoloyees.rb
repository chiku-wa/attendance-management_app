class AddFkEmploymentStatusesIdToEmoloyees < ActiveRecord::Migration[6.0]
  def change
    # 就業状況IDの外部キーカラムを追加
    add_reference(
      :employees,
      :employment_statuses,
      foreign_key: {
        to_table: :employment_statuses,
        type: :bigint,
        name: :fk_employment_statuses_id,
      },
    )
  end
end
