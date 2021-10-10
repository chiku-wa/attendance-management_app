class AddCommentToTableAndColumn < ActiveRecord::Migration[6.0]
  # テーブル、カラムのコメントに論理名を設定する
  # ※db:rollbackできるようにするために、引数にはfrom,toを加えておくこと
  def change
    # =========================
    # ===== 部署テーブル
    change_table_comment(:departments, from: "", to: "部署テーブル")
    change_column_comment(:departments, :department_code, from: "", to: "部署コード")
    change_column_comment(:departments, :establishment_date, from: "", to: "設立日")
    change_column_comment(:departments, :abolished_date, from: "", to: "廃止日")
    change_column_comment(:departments, :department_name, from: "", to: "部署名")
    change_column_comment(:departments, :department_kana_name, from: "", to: "部署名(カナ)")

    # =========================
    # ===== 部署階層テーブル
    change_table_comment(:hierarchy_departments, from: "", to: "部署階層")
    change_column_comment(:hierarchy_departments, :parent_department_id, from: "", to: "親部署ID")
    change_column_comment(:hierarchy_departments, :child_department_id, from: "", to: "子親部署ID")

    # =========================
    # ===== 社員-部署テーブル
    change_table_comment(:employee_departments, from: "", to: "社員 - 部署")
    change_column_comment(:employee_departments, :department_id, from: "", to: "部署ID")
    change_column_comment(:employee_departments, :employee_id, from: "", to: "社員ID")
    change_column_comment(:employee_departments, :affiliation_type_id, from: "", to: "所属種別ID")
    change_column_comment(:employee_departments, :start_date, from: "", to: "着任日")
    change_column_comment(:employee_departments, :end_date, from: "", to: "離任日")

    # =========================
    # ===== 所属種別テーブル
    change_table_comment(:affiliation_types, from: "", to: "所属種別")
    change_column_comment(:affiliation_types, :affiliation_type_name, from: "", to: "所属種別名")

    # =========================
    # ===== 社員テーブル
    change_table_comment(:employees, from: "", to: "社員")
    change_column_comment(:employees, :employee_code, from: "", to: "社員コード")
    change_column_comment(:employees, :employee_name, from: "", to: "社員名")
    change_column_comment(:employees, :age, from: "", to: "年齢")
    change_column_comment(:employees, :employee_name_kana, from: "", to: "社員名(フリガナ)")
    change_column_comment(:employees, :employment_status_id, from: "", to: "就業状況ID")

    # =========================
    # ===== 就業状況テーブル
    change_table_comment(:employment_statuses, from: "", to: "就業状況")
    change_column_comment(:employment_statuses, :status_code, from: "", to: "就業状況コード")
    change_column_comment(:employment_statuses, :status_name, from: "", to: "就業状況")

    # =========================
    # ===== プロジェクトテーブル
    change_table_comment(:projects, from: "", to: "プロジェクト")
    change_column_comment(:projects, :project_code, from: "", to: "プロジェクトコード")
    change_column_comment(:projects, :project_name, from: "", to: "プロジェクト名")
    change_column_comment(:projects, :enabled, from: "", to: "有効フラグ")
    change_column_comment(:projects, :start_date, from: "", to: "プロジェクト開始日")
    change_column_comment(:projects, :end_date, from: "", to: "プロジェクト終了日")

    # =========================
    # ===== ランクテーブル
    change_table_comment(:ranks, from: "", to: "ランク")
    change_column_comment(:ranks, :rank_code, from: "", to: "ランクコード")

    # =========================
    # ===== 勤務表テーブル
    change_table_comment(:work_tables, from: "", to: "勤務表")
    change_column_comment(:work_tables, :employee_code, from: "", to: "社員コード")
    change_column_comment(:work_tables, :working_date, from: "", to: "勤務日")
    change_column_comment(:work_tables, :project_code, from: "", to: "プロジェクトコード")
    change_column_comment(:work_tables, :employee_code, from: "", to: "就業状況コード")
    change_column_comment(:work_tables, :rank_code, from: "", to: "ランクコード")
    change_column_comment(:work_tables, :closed, from: "", to: "締めフラグ")
  end
end
