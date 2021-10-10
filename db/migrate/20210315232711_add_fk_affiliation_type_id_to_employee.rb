class AddFkAffiliationTypeIdToEmployee < ActiveRecord::Migration[6.0]
  def change
    # 所属種別IDの外部キーカラムを追加
    add_reference(
      :employees,
      :affiliation_type,
      foreign_key: {
        to_table: :affiliation_types,
        type: :bigint,
        name: :fk_affiliation_type_id,
      },
    )
  end
end
