class FixReferencesToWorkTables < ActiveRecord::Migration[6.0]
  def change
    # 勤務表テーブルの外部キーにNOT NULLを付与する
    change_column_null(:work_tables, :employee_id, false)
    change_column_null(:work_tables, :project_id, false)
    change_column_null(:work_tables, :employment_status_id, false)
    change_column_null(:work_tables, :rank_id, false)

    # コメントを付与する
    change_column_comment(:work_tables, :employee_id, from: "", to: "社員ID")
    change_column_comment(:work_tables, :project_id, from: "", to: "プロジェクトID")
    change_column_comment(:work_tables, :employment_status_id, from: "", to: "就業状況ID")
    change_column_comment(:work_tables, :rank_id, from: "", to: "ランクID")

    # 誤りのあるコメントを修正
    change_column_comment(:work_tables, :employee_code, from: "就業状況コード", to: "社員コード")

    # 不足している列を追加する
    add_column(:work_tables, :employment_status_code, :string, limit: 5, null: false, comment: "就業状況コード")

    # 各カラムの長さを修正する
    change_column(:work_tables, :project_code, :string, limit: 7)
  end
end
