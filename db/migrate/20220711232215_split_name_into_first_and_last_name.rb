class SplitNameIntoFirstAndLastName < ActiveRecord::Migration[6.1]
  # ----- 既存の氏名を、姓と名に分割する

  # 変更反映用マイグレーション
  def up
    # ----- 氏名
    # 既存の「社員名」カラムを削除
    remove_column(:employees, :employee_name)

    # 「社員名(姓)」「社員名(名)」カラムを追加
    add_column(:employees, :employee_last_name, :string, limit: 100, null: false, comment: "社員名(姓)")
    add_column(:employees, :employee_first_name, :string, limit: 100, null: false, comment: "社員名(名)")

    # ----- カナ
    # 既存の「社員名(フリガナ)」カラムを削除
    remove_column(:employees, :employee_name_kana)

    # 「社員名カナ(名)」「社員名カナ(名)」カラムを追加
    add_column(:employees, :employee_last_name_kana, :string, limit: 200, null: false, comment: "社員名カナ(姓)")
    add_column(:employees, :employee_first_name_kana, :string, limit: 200, null: false, comment: "社員名カナ(名)")
  end

  # ロールバック用マイグレーション
  def down
    # ----- 氏名
    # 「社員名(姓)」「社員名(名)」カラムを削除
    remove_column(:employees, :employee_last_name)
    remove_column(:employees, :employee_first_name)

    # 「社員名」カラムを追加
    add_column(:employees, :employee_name, :string, limit: 110, null: false, comment: "社員名")

    # ----- カナ
    # 「社員名カナ(名)」「社員名カナ(名)」カラムを削除
    remove_column(:employees, :employee_last_name_kana)
    remove_column(:employees, :employee_first_name_kana)

    # 「社員名(フリガナ)」カラム追加
    add_column(:employees, :employee_name_kana)
  end
end
