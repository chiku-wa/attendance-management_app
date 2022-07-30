# 社員情報のテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  # 在職
  factory :employee, class: Employee do
    employee_code { "A00001" }
    employee_last_name { "山田" }
    employee_first_name { "太郎" }
    employee_last_name_kana { "ヤマダ" }
    employee_first_name_kana { "タロウ" }
    age { 30 }
    email { "yamada.tarou@example.com" }
    password { "foo_bar_yamada" }

    association(:employment_status, factory: :employment_status_work)
  end

  # 休職
  factory :employee_absences, class: Employee do
    employee_code { "A00002" }
    employee_last_name { "鈴木" }
    employee_first_name { "次郎" }
    employee_last_name_kana { "スズキ" }
    employee_first_name_kana { "ジロウ" }
    age { 30 }
    email { "suzuki.jirou@example.com" }
    password { "foo_bar_suzuki" }

    association(:employment_status, factory: :employment_status_absences)
  end

  # 退職
  factory :employee_retirement, class: Employee do
    employee_code { "A00003" }
    employee_last_name { "田代" }
    employee_first_name { "三郎" }
    employee_last_name_kana { "タシロ" }
    employee_first_name_kana { "サブロウ" }
    age { 30 }
    email { "tashiro.saburou@example.com" }
    password { "foo_bar_tashiro" }

    association(:employment_status, factory: :employment_status_retirement)
  end
end
