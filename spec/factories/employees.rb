# 社員情報のテストデータ登録用FactoryBot
FactoryBot.define do
  # 汎用社員情報
  # ※外部キーに紐づく情報はここでは定義しない。
  #   呼び出し側でFactoryBotを呼び出してテストデータを作成することとする。
  factory :employee, class: Employee do
    employee_code { "Tom" }
    employee_name { "山田　太郎" }
    employee_name_kana { "ヤマダ　タロウ" }
    age { 30 }
  end
end
