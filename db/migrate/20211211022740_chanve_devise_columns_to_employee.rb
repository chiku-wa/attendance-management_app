class ChanveDeviseColumnsToEmployee < ActiveRecord::Migration[6.0]
  # deviseでデフォルトで追加されるカラムの定義を修正する
  def up
    # --- 社員テーブル
    # メールアドレスは、一般的に上限とされる255文字までとする
    change_column(:employees, :email, :string, limit: 255)

    # 一意制約名をリネーム(既存の制約名と同じ命名規則にする)
    # メールアドレス
    rename_index(
      :employees,
      :index_employees_on_email,
      :unique_employees_on_email,
    )

    # パスワードリセット用トークン
    rename_index(
      :employees,
      :index_employees_on_reset_password_token,
      :unique_employees_on_reset_password_token,
    )
  end
end
