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
role_manager = Role.find_by(role_name: I18n.t("master_data.role.manager"))
role_common = Role.find_by(role_name: I18n.t("master_data.role.common"))

# ----- 社員情報を登録
employees = []
(1..100).each do |i|
  # gimeiのgemを使ってランダムな名前を生成
  gimei = Gimei.name

  employees << Employee.new(
    employee_code: "A#{format("%05d", i)}",
    employee_last_name: gimei.last.kanji,
    employee_first_name: gimei.first.kanji,
    employee_last_name_kana: gimei.last.katakana,
    employee_first_name_kana: gimei.first.katakana,
    age: rand(20..100),
    email: "test#{i}@example.com",
    password: "foo_bar#{i}",
    employment_status: employment_statuses[
      rand(0..(employment_statuses.size - 1))
    ],
  )
end

# 社員一覧画面で社員名でソートされた場合に、`社員名カナ(姓)` + `社員名カナ(名)`の組み合わせで
# ソートされていることを担保するためのテストデータを登録する。
# `社員名カナ(姓)` + `社員名カナ(名)`でソートされた場合と、下記のパターンでソートされた場合に
# 並び順が異なるように登録する。
# ※ `<ソートキー1>` + `<ソートキー2>`の組み合わせで表記している
#
# * `社員名カナ(姓)` + `社員名カナ(名)`
# * `社員名カナ(姓)` + `社員番号`
# * `社員名カナ(姓)` + 登録した順序
#
# ---
#
# [例]
#
# * `社員名カナ(姓)` + `社員名カナ(名)`でソートした場合の並び順
#
# | 社員名   | 社員名(カナ)  |
# | ----- | -------- |
# | 山田　三郎 | ヤマダ　サブロウ |
# | 山田　次郎 | ヤマダ　ジロウ  |
# | 山田　太郎 | ヤマダ　タロウ  |
#
# * `社員名カナ(姓)` + `社員番号`、`社員名カナ(姓)` + 登録した順序でソートした場合の並び順
#     ※社員番号は連番で採番しているため、登録した順序と等価
#
# | 社員名   | 社員名(カナ)  |
# | ----- | -------- |
# | 山田　太郎 | ヤマダ　タロウ  |
# | 山田　次郎 | ヤマダ　ジロウ  |
# | 山田　三郎 | ヤマダ　サブロウ |
#
# * `社員名カナ(姓)` + `社員名カナ(姓)`
#
# | 社員名   | 社員名(カナ)  |
# | ----- | -------- |
# | 山田　三郎 | ヤマダ　サブロウ |
# | 山田　太郎 | ヤマダ　タロウ  |
# | 山田　次郎 | ヤマダ　ジロウ  |
#
employee_code_index = 1
[
  ["山田", "太郎", "ヤマダ", "タロウ"],
  ["山田", "次郎", "ヤマダ", "ジロウ"],
  ["山田", "三郎", "ヤマダ", "サブロウ"],
].each do |employee_last_name,
           employee_first_name,
           employee_last_name_kana,
           employee_first_name_kana|
  i = employees.size + employee_code_index

  employees << Employee.new(
    employee_code: "A#{format("%05d", i)}",
    employee_last_name: employee_last_name,
    employee_first_name: employee_first_name,
    employee_last_name_kana: employee_last_name_kana,
    employee_first_name_kana: employee_first_name_kana,
    age: rand(20..100),
    email: "test#{i}@example.com",
    password: "foo_bar#{i}",
    employment_status: employment_statuses[
      rand(0..(employment_statuses.size - 1))
    ],
  )

  employee_code_index += 1
end

Employee.import!(employees)

# ----- 社員に部署と権限を付与
# 部署の付与に使用する変数を定義
departments = Department.all
start_date = Time.zone.parse("2022-04-01 23:00:00")
end_date = Time.zone.parse("9999-12-31 23:59:59")

# ※社員の作成と同時だと、Employeeモデルクラス生成時にrolesプロパティが消失するため、ここで処理。
employees.each_with_index do |employee, i|
  # [部署を付与]
  # 本務を付与
  department_of_regular = employee.add_department(
    department: departments[i % departments.size],
    affiliation_type_name: I18n.t("master_data.affiliation_type.affiliation_type_name.regular"),
    start_date: start_date,
    end_date: end_date,
  )

  # 本務部署と異なる部署の兼務を付与する(偏りをなくすためにshuffleする)
  employee.add_department(
    department: departments.where.not(id: department_of_regular.id).shuffle[0],
    affiliation_type_name: I18n.t("master_data.affiliation_type.affiliation_type_name.additional"),
    start_date: start_date,
    end_date: end_date,
  )

  # [権限付与]
  # 10人に1人を「マネージャー」を割り当て、それ以外は「一般社員」を割り当てる
  employee.roles = i % 10 == 0 ? [role_manager] : [role_common]
end
