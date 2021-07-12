# ===== 部署登録
#
department_A = FactoryBot.build(:department_A)
department_A_sales = FactoryBot.build(:department_A_sales)
department_A_sales_department = FactoryBot.build(:department_A_sales_department)
department_A_sales_department_division = FactoryBot.build(:department_A_sales_department_division)

departments = [
  department_A,
  department_A_sales,
  department_A_sales_department,
  department_A_sales_department_division,
]

Department.import!(departments)

# ===== 就業状況登録
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

# ===== 社員登録
employees = []

99.times do |i|
  # gimeiのgemを使ってランダムな名前を生成
  gimei = Gimei.name

  employees << Employee.new(
    employee_code: "A#{format("%05d", i)}",
    employee_name: gimei.kanji,
    employee_name_kana: gimei.katakana,
    age: rand(1..100),
    employment_status: employment_statuses[
      rand(0..(employment_statuses.size - 1))
    ],
  )
end
Employee.import!(employees)
