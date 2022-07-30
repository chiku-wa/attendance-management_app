class AddFullNameColumn < ActiveRecord::Migration[6.1]
  def change
    # `社員名(姓)`、`社員名(名)`カラムを追加
    add_column(:employees, :employee_full_name, :string, limit: 201, null: false, comment: "社員名(姓・名)")
    add_column(:employees, :employee_full_name_kana, :string, limit: 401, null: false, comment: "社員名カナ(姓・名)")
  end
end
