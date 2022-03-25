#
# テストデータ作成に必要な共通メソッドを定義するヘルパークラス
# 開発、テスト、本番環境でそれぞれ共通的に使用するテストデータの登録処理を定義する。
#
# ========== 部署登録
department_A = FactoryBot.create(:department_A)
department_A_sales = FactoryBot.create(:department_A_sales)
department_A_sales_department1 = FactoryBot.create(:department_A_sales_department1)
department_A_sales_department1_division1 = FactoryBot.create(:department_A_sales_department1_division1)
department_A_sales_department1_division2 = FactoryBot.create(:department_A_sales_department1_division2)
department_A_sales_department2 = FactoryBot.create(:department_A_sales_department2)
department_A_sales_department2_division1 = FactoryBot.create(:department_A_sales_department2_division1)
department_A_sales_department2_division2 = FactoryBot.create(:department_A_sales_department2_division2)

department_B = FactoryBot.create(:department_B)
department_B_production = FactoryBot.create(:department_B_production)

# ========== 部署階層登録
# --- 部署階層テーブル:世代0のレコード(親=子の階層)を登録
[
  :department_A,
  :department_A_sales,
  :department_A_sales_department1,
  :department_A_sales_department1_division1,
  :department_A_sales_department1_division2,
  :department_A_sales_department2,
  :department_A_sales_department2_division1,
  :department_A_sales_department2_division2,
  :department_B,
  :department_B_production,
].each do |fb|
  DepartmentHierarchy.create(
    parent_department: eval("#{fb}"),
    child_department: eval("#{fb}"),
    generations: 0,
  )
end

# --- 部署階層テーブル:世代1〜のレコードを登録
[
  # A事業部　A01000000000
  # 　┗営業部　A01B01000000
  # 　　┗第一営業部　A01B01C01000
  # 　　　┗第一営業部　一課　　A01B01C01001
  # 　　　┗第一営業部　二課　　A01B01C01002
  # 　　┗第二営業部　A01B01C02000
  # 　　　┗第ニ営業部　　一課　　A01B01C02001
  # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
  { parent_department: department_A, child_department: department_A_sales, generations: 1 },
  { parent_department: department_A, child_department: department_A_sales_department1, generations: 2 },
  { parent_department: department_A, child_department: department_A_sales_department1_division1, generations: 3 },
  { parent_department: department_A, child_department: department_A_sales_department1_division2, generations: 3 },
  { parent_department: department_A, child_department: department_A_sales_department2, generations: 2 },
  { parent_department: department_A, child_department: department_A_sales_department2_division1, generations: 3 },
  { parent_department: department_A, child_department: department_A_sales_department2_division2, generations: 3 },

  # 　┗営業部　A01B01000000
  # 　　┗第一営業部　A01B01C01000
  # 　　　┗第一営業部　一課　　A01B01C01001
  # 　　　┗第一営業部　二課　　A01B01C01002
  # 　　┗第二営業部　A01B01C02000
  # 　　　┗第ニ営業部　　一課　　A01B01C02001
  # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
  { parent_department: department_A_sales, child_department: department_A_sales_department1, generations: 1 },
  { parent_department: department_A_sales, child_department: department_A_sales_department1_division1, generations: 2 },
  { parent_department: department_A_sales, child_department: department_A_sales_department1_division2, generations: 2 },
  { parent_department: department_A_sales, child_department: department_A_sales_department2, generations: 1 },
  { parent_department: department_A_sales, child_department: department_A_sales_department2_division1, generations: 2 },
  { parent_department: department_A_sales, child_department: department_A_sales_department2_division2, generations: 2 },

  # 　　┗第一営業部　A01B01C01000
  # 　　　┗第一営業部　一課　　A01B01C01001
  # 　　　┗第一営業部　二課　　A01B01C01002
  { parent_department: department_A_sales_department2, child_department: department_A_sales_department2_division1, generations: 1 },
  { parent_department: department_A_sales_department2, child_department: department_A_sales_department2_division2, generations: 1 },

  # 　　┗第二営業部　A01B01C02000
  # 　　　┗第ニ営業部　　一課　　A01B01C02001
  # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
  { parent_department: department_A_sales_department1, child_department: department_A_sales_department1_division1, generations: 1 },
  { parent_department: department_A_sales_department1, child_department: department_A_sales_department1_division2, generations: 1 },

  # B事業部　B01000000000
  # 　┗製造部　B01C01000000
  { parent_department: department_B, child_department: department_B_production, generations: 1 },
].each do |dh|
  DepartmentHierarchy.create(dh)
end

# ===== 権限登録
#
role_admin = Role.create!(
  role_name: I18n.t("master_data.role.admin"),
)

role_manager = Role.create!(
  role_name: I18n.t("master_data.role.manager"),
)

role_common = Role.create!(
  role_name: I18n.t("master_data.role.common"),
)

# ===== 就業状況登録
#
employment_status_work = EmploymentStatus.create!(
  status_code: I18n.t("master_data.employment_status.status_code.work"),
  status_name: I18n.t("master_data.employment_status.status_name.work"),
)
employment_status_absences = EmploymentStatus.create!(
  status_code: I18n.t("master_data.employment_status.status_code.absences"),
  status_name: I18n.t("master_data.employment_status.status_name.absences"),
)

employment_status_retirement = EmploymentStatus.create!(
  status_code: I18n.t("master_data.employment_status.status_code.retirement"),
  status_name: I18n.t("master_data.employment_status.status_name.retirement"),
)

# ===== 社員情報を登録
# 管理者
Employee.create!(
  employee_code: "999999",
  employee_name: "システム管理者",
  employee_name_kana: "システムカンリシャ",
  age: 0,
  email: ENV["ADMINISTRATOR_MAIL_ADDRESS"],
  password: ENV["ADMINISTRATOR_PASSWORD"],
  employment_status: employment_status_work,
  roles: [role_admin],
)
