# 部署情報のテストデータ登録用FactoryBot

FactoryBot.define do
  # =======================================================
  # 共通部

  # ----- 共通変数
  # 部署の設立日、廃止日
  establishment_date = DateTime.new(2021, 4, 1, 0, 0, 0)
  abolished_date = DateTime.new(9999, 12, 31, 23, 59, 59)

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
  # 　┗製造部　B01C01000000
  #
  # 下記はテストの際に必要に応じて登録するための部署情報とする。
  # テスト部署1 Z99999999991
  # 　┗テスト部署2 Z99999999992
  # 　　┗テスト部署3 Z99999999993

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

  # 製造部
  factory :department_B_production, class: Department do
    department_code { "B01C01000000" }
    department_name { "製造部" }
    department_kana_name { "セイゾウブ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # テスト部署1
  factory :department_test_1, class: Department do
    department_code { "Z99999999991" }
    department_name { "テスト部署1" }
    department_kana_name { "テストブショイチ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # テスト部署2
  factory :department_test_2, class: Department do
    department_code { "Z99999999992" }
    department_name { "テスト部署2" }
    department_kana_name { "テストブショニ" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end

  # テスト部署3
  factory :department_test_3, class: Department do
    department_code { "Z99999999993" }
    department_name { "テスト部署3" }
    department_kana_name { "テストブショサン" }
    establishment_date { establishment_date }
    abolished_date { abolished_date }
  end
end
