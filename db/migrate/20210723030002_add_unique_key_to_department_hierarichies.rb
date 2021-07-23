class AddUniqueKeyToDepartmentHierarichies < ActiveRecord::Migration[6.0]
  def change
    # 親部署IDと子部署IDの一意制約を付与する
    # 部署コード、設立日、廃止日の複合ユニークを付与
    add_index(
      :department_hierarchies,
      [:parent_department_id, :child_department_id],
      unique: true,
      # デフォルトのインデックス名だと長すぎるためリネーム(PostgreSQLのエラー回避用)
      name: :index_department_hierarchies_on_parent_child,
    )
  end
end
