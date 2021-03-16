class FixAffiliationTypeFk < ActiveRecord::Migration[6.0]
  # 誤って設定された所属種別の外部キー制約を修正する
  def change
    # 社員情報の所属種別外部キーを削除
    remove_column(:employees, :affiliation_type_id)

    # 社員−部署に所属種別の外部キーカラムを追加
    add_reference(
      :employee_departments,
      :affiliation_type,
      foreign_key: {
        to_table: :affiliation_types,
        type: :bigint,
        name: :fk_affiliation_type_id,
      },
    )
  end
end
