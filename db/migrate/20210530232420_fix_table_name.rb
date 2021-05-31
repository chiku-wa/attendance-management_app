class FixTableName < ActiveRecord::Migration[6.0]
  def change
    # --- 所属種別テーブルの綴り間違いを修正
    # 一意制約名を修正
    rename_index(
      :affiliation_types,
      :unique_affiliation_types_on_affiliation_type_name,
      :unique_affilitation_types_on_affilitation_type_name,
    )

    # カラム名を修正
    rename_column(
      :affiliation_types,
      :affiliation_type_name,
      :affilitation_type_name,
    )

    # テーブル名を修正
    rename_table(:affiliation_types, :affilitation_types)

    # --- 所属種別テーブルのカラムを外部キーとして使っているカラム名・制約名を修正
    # 列名修正
    rename_column(
      :employee_departments,
      :affiliation_type_id,
      :affilitation_type_id,
    )

    # 外部キー名修正
    remove_foreign_key(:employee_departments, name: :fk_affiliation_type_id)
    add_foreign_key(
      :employee_departments,
      :affilitation_types,
      column: :affilitation_type_id,
      name: :fk_affilitation_type_id,
    )
  end
end
