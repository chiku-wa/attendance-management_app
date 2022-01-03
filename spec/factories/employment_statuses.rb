# 就業状況のテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  # 在職
  factory :employment_status_work, class: EmploymentStatus do
    status_code { "00001" }
    status_name { "在職" }
  end

  # 休職
  factory :employment_status_absences, class: EmploymentStatus do
    status_code { "00002" }
    status_name { "休職" }
  end

  # 退職
  factory :employment_status_retirement, class: EmploymentStatus do
    status_code { "00003" }
    status_name { "退職" }
  end
end
