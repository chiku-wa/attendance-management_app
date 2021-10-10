# 就業状況のテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  # 在職
  factory :employment_status_work, class: EmploymentStatus do
    status_code { "00001" }
    status_name { "在職" }
  end
end
