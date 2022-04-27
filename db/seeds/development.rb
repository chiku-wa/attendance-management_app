# ===== 社員登録
# ----- 社員情報を構成する外部情報を取得
# 就業状況
employment_status_work = EmploymentStatus.find_by(status_code: I18n.t("master_data.employment_status.status_code.work"))
employment_status_absences = EmploymentStatus.find_by(status_code: I18n.t("master_data.employment_status.status_code.absences"))
employment_status_retirement = EmploymentStatus.find_by(status_code: I18n.t("master_data.employment_status.status_code.retirement"))

employment_statuses = [
  employment_status_work,
  employment_status_absences,
  employment_status_retirement,
]

# 権限
role_admin = Role.find_by(role_name: I18n.t("master_data.role.admin"))
role_manager = Role.find_by(role_name: I18n.t("master_data.role.manager"))
role_common = Role.find_by(role_name: I18n.t("master_data.role.common"))

# 一般社員、マネージャー
employees = []
(1..100).each do |i|
  # gimeiのgemを使ってランダムな名前を生成
  gimei = Gimei.name

  employees << Employee.new(
    employee_code: "A#{format("%05d", i)}",
    employee_name: gimei.kanji,
    employee_name_kana: gimei.katakana,
    age: rand(20..100),
    email: "test#{i}@example.com",
    password: "foo_bar#{i}",
    employment_status: employment_statuses[
      rand(0..(employment_statuses.size - 1))
    ],
  )
end

Employee.import!(employees)

# 社員に権限を付与
# ※社員の作成と同時だと、Employeeモデルクラス生成時にrolesプロパティが消失するため、ここで処理。
employees.each_with_index do |employee, i|
  # 10人に1人をマネージャーに割り当てる
  employee.roles = i % 10 == 0 ? [role_manager] : [role_common]
end
