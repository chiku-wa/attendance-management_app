class ChangeWorkTableColumnsForWorkAndLeave < ActiveRecord::Migration[6.1]
  # =========================
  # ===== 勤務表テーブル
  def up
    # 物理名と論理名を修正
    change_column_comment(:work_tables, :working_date, from: "勤務日", to: "出勤日時")
    change_column(:work_tables, :working_date, :datetime, precision: 6)
    rename_column(:work_tables, :working_date, :work_date)

    # 退勤日時を追加
    add_column(:work_tables, :leave_date, :datetime, precision: 6, null: false)
    change_column_comment(:work_tables, :leave_date, from: "", to: "退勤日時")
  end

  def down
    # 物理名と論理名を修正
    rename_column(:work_tables, :work_date, :working_date)
    change_column(:work_tables, :working_date, :datetime, precision: nil)
    change_column_comment(:work_tables, :working_date, from: "出勤日時", to: "勤務日")

    # 退勤日時を削除
    remove_column(:work_tables, :leave_date)
  end
end
