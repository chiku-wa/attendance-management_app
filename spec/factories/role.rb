# ランクのテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  factory :role_admin, class: Role do
    role_name { "管理者" }
  end

  factory :role_manager, class: Role do
    role_name { "マネージャー" }
  end

  factory :role_common, class: Role do
    role_name { "一般社員" }
  end
end
