# ランクのテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  factory :role_admin, class: Role do
    role_name { "管理者" }
  end
end
