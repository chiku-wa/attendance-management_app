# 部署情報のテストデータ登録用FactoryBot
# 以下の組織構造を作成する。

# 共通的に使用する部署の設立日、廃止日
establishment_date = DateTime.new(2021, 4, 1, 0, 0, 0)
abolished_date = DateTime.new(9999, 12, 31, 23, 59, 59)

FactoryBot.define do
  # A事業部
  factory :department_level1, class: Department do
    department_code { "A01000000000" }
    department_name { "A事業部" }
    department_kana_name { "エージギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 営業部
  factory :department_level2_1, class: Department do
    department_code { "A01B01000000" }
    department_name { "営業部" }
    department_kana_name { "エイギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第一営業部
  factory :department_level3_1, class: Department do
    department_code { "A01B01C01000" }
    department_name { "第一営業部" }
    department_kana_name { "ダイイチエイギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 営業一課
  factory :department_level4_1, class: Department do
    department_code { "A01B01C01001" }
    department_name { "営業一課" }
    department_kana_name { "エイギョウイッカ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end
end