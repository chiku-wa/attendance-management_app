# === 部署登録
#
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

# === 部署階層登録
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

# === 就業状況登録
#
employment_status_work = EmploymentStatus.create!(
  status_code: "00001",
  status_name: "在職",
)
employment_status_leave = EmploymentStatus.create!(
  status_code: "00002",
  status_name: "休職",
)

employment_status_retirement = EmploymentStatus.create!(
  status_code: "00003",
  status_name: "退職",
)

employment_statuses = [
  employment_status_work,
  employment_status_leave,
  employment_status_retirement,
]

# === 社員登録
employees = []

99.times do |i|
  # gimeiのgemを使ってランダムな名前を生成
  gimei = Gimei.name

  employees << Employee.new(
    employee_code: "A#{format("%05d", i)}",
    employee_name: gimei.kanji,
    employee_name_kana: gimei.katakana,
    age: rand(1..100),
    email: "test#{i}@example.com",
    password: "foo_bar#{i}",
    employment_status: employment_statuses[
      rand(0..(employment_statuses.size - 1))
    ],
  )
end
Employee.import!(employees)
