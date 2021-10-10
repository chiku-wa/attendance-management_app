class AddForeignKeyToWorkTable < ActiveRecord::Migration[6.0]
  def change
    # --- 勤務表テーブルに外部キーを付与する
    # 社員IDの外部キーを付与する
    add_reference(
      :work_tables,
      :employee,
      foreign_key: {
        to_table: :work_tables,
        type: :bigint,
        name: :fk_employee_id,
      },
    )

    # プロジェクトの外部キーを付与する
    add_reference(
      :work_tables,
      :project,
      foreign_key: {
        to_table: :work_tables,
        type: :bigint,
        name: :fk_project_id,
      },
    )

    # 就業状況の外部キーを付与する
    add_reference(
      :work_tables,
      :employment_status,
      foreign_key: {
        to_table: :work_tables,
        type: :bigint,
        name: :fk_employment_status_id,
      },
    )

    # ランクの外部キーを付与する
    add_reference(
      :work_tables,
      :rank,
      foreign_key: {
        to_table: :work_tables,
        type: :bigint,
        name: :fk_rank_id,
      },
    )
  end
end
