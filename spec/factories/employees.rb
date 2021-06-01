# 社員情報のテストデータ登録用FactoryBot
FactoryBot.define do
  # 汎用社員情報
  factory :employee, class: Employee do
    employee_code { "A00001" }
    employee_name { "山田　太郎" }
    employee_name_kana { "ヤマダ　タロウ" }
    age { 30 }

    # 外部キー情報
    association(:employment_status, factory: :employment_status_work)
  end
end
