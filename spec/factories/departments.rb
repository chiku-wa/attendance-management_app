# 部署情報のテストデータ登録用FactoryBot

FactoryBot.define do
  # =======================================================
  # 共通部

  # ----- 共通変数
  # 部署の設立日、廃止日
  establishment_date = DateTime.new(2021, 4, 1, 0, 0, 0)
  abolished_date = DateTime.new(9999, 12, 31, 23, 59, 59)

  # =======================================================
  # 開発用
  # ※「テスト用」と共用

  # =======================================================
  # テスト用
  # 以下の階層構造の部署情報を想定する
  # 以下の組織構造を持つ部署のテストデータ
  #
  # A事業部　A01000000000
  # 　┗営業部　A01B01000000
  # 　　┗第一営業部　A01B01C01000
  # 　　　┗第一営業部　一課　　A01B01C01001
  # 　　　┗第一営業部　二課　　A01B01C01002
  # 　　┗第二営業部　A01B01C02000
  # 　　　┗第ニ営業部　　一課　　A01B01C02001
  # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
  # B事業部　B01000000000

  # A事業部
  factory :department_A, class: Department do
    department_code { "A01000000000" }
    department_name { "A事業部" }
    department_kana_name { "エージギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 営業部
  factory :department_A_sales, class: Department do
    department_code { "A01B01000000" }
    department_name { "営業部" }
    department_kana_name { "エイギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第一営業部
  factory :department_A_sales_department1, class: Department do
    department_code { "A01B01C01000" }
    department_name { "第一営業部" }
    department_kana_name { "ダイイチエイギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第一営業部　一課
  factory :department_A_sales_department1_division1, class: Department do
    department_code { "A01B01C01001" }
    department_name { "第一営業部　一課" }
    department_kana_name { "ダイイチエイギョウブ　イッカ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第一営業部　ニ課
  factory :department_A_sales_department1_division2, class: Department do
    department_code { "A01B01C01002" }
    department_name { "第一営業部　ニ課" }
    department_kana_name { "ダイイチエイギョウブ　ニカ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第二営業部
  factory :department_A_sales_department2, class: Department do
    department_code { "A01B01C02000" }
    department_name { "第二営業部" }
    department_kana_name { "ダイニエイギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第ニ営業部　一課
  factory :department_A_sales_department2_division1, class: Department do
    department_code { "A01B01C02001" }
    department_name { "第ニ営業部　一課" }
    department_kana_name { "ダイニエイギョウブ　イッカ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # 第ニ営業部　ニ課
  factory :department_A_sales_department2_division2, class: Department do
    department_code { "A01B01C02002" }
    department_name { "第ニ営業部　ニ課" }
    department_kana_name { "ダイニエイギョウブ　ニカ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # B事業部
  factory :department_B, class: Department do
    department_code { "B01000000000" }
    department_name { "B事業部" }
    department_kana_name { "ビージギョウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end
end
