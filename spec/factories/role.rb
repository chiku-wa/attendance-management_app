# ランクのテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  factory :role_admin, class: Role do
    role_name { I18n.t("master_data.role.admin") }
  end

  factory :role_manager, class: Role do
    role_name { I18n.t("master_data.role.manager") }
  end

  factory :role_common, class: Role do
    role_name { I18n.t("master_data.role.common") }
  end
end
