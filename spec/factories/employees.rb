# 社員情報のテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  # 汎用社員情報
  factory :employee, class: Employee do
    employee_code { "A00001" }
    employee_name { "山田　太郎" }
    employee_name_kana { "ヤマダ　タロウ" }
    age { 30 }

    association(:employment_status, factory: :employment_status_work)
  end
end
