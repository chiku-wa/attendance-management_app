class FixProjectCode < ActiveRecord::Migration[6.0]
  def change
    # プロジェクトコードの長さを修正
    change_column(:projects, :project_code, :string, limit: 7)
  end
end
