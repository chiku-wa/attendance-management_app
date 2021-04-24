class FixedUniqueToTable < ActiveRecord::Migration[6.0]
  # 設計書通りの一意インデックスを付与し、インデックス名を見直す
  def change
    # --- 部署テーブル
    # 一意制約名をリネーム
    rename_index(
      :departments,
      :index_departments_on_department_code_establishment_abolished,
      :unique_departments_on_department_code_establishment_abolished,
    )

    # --- 所属種別テーブル
    # 一意制約名をリネーム
    rename_index(
      :affiliation_types,
      :index_affiliation_types_on_affiliation_type_name,
      :unique_affiliation_types_on_affiliation_type_name,
    )

    # --- 社員
    # 一意制約名をリネーム
    rename_index(
      :employees,
      :index_employees_on_employee_code,
      :unique_employees_on_employee_code,
    )
    # 不要な一意制約を削除
    remove_index(:employees, name: :index_employees_on_employment_status_id)

    # --- 就業状況テーブル
    # 一意制約を付与
    add_index(:employment_statuses, :status_code, name: :unique_employment_statuses_on_status_code, unique: true)
    add_index(:employment_statuses, :status_name, name: :unique_employment_statuses_on_status_name, unique: true)

    # --- 社員-部署テーブル
    # 不要な一意制約を削除
    remove_index(:employee_departments, name: :index_employee_departments_on_affiliation_type_id)

    # --- プロジェクトテーブル
    # 一意制約名をリネーム
    rename_index(
      :projects,
      :index_projects_on_project_code,
      :unique_projects_on_project_code,
    )

    # 不要な一意制約を削除
    remove_index(:projects, name: :index_projects_on_project_name)
  end
end
