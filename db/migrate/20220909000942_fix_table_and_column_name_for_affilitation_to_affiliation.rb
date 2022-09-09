class FixTableAndColumnNameForAffilitationToAffiliation < ActiveRecord::Migration[6.1]
  # ----- 所属種別テーブルカラム名の物理名の誤記を修正
  # affili`t`ation → affiliation

  def up
    # テーブル、カラム名を変更
    rename_table(:affilitation_types, :affiliation_types)
    rename_column(
      :affiliation_types,
      :affilitation_type_name,
      :affiliation_type_name
    )

    # インデックス名を変更
    rename_index(
      :affiliation_types,
      :unique_affilitation_types_on_affilitation_type_name,
      :unique_affiliation_types_on_affiliation_type_name,
    )

    # 外部キーを変更
    rename_column(
      :employee_departments,
      :affilitation_type_id,
      :affiliation_type_id,
    )
    remove_foreign_key(
      :employee_departments,
      name: :fk_affilitation_type_id,
    )
    add_foreign_key(
      :employee_departments,
      :affiliation_types,
      column: :affiliation_type_id,
      name: :fk_affiliation_type_id,
    )
  end

  def down
    # テーブル、カラム名を変更
    rename_table(:affiliation_types, :affilitation_types)
    rename_column(
      :affilitation_types,
      :affiliation_type_name,
      :affilitation_type_name
    )

    # インデックス名を変更
    rename_index(
      :affiliation_types,
      :unique_affiliation_types_on_affiliation_type_name,
      :unique_affilitation_types_on_affilitation_type_name,
    )

    # 外部キーを変更
    rename_column(
      :employee_departments,
      :affiliation_type_id,
      :affilitation_type_id,
    )
    remove_foreign_key(
      :employee_departments,
      name: :fk_affiliation_type_id,
    )
    add_foreign_key(
      :employee_departments,
      :affilitation_types,
      column: :affilitation_type_id,
      name: :fk_affilitation_type_id,
    )
  end
end
