# 社員-部署情報のテストデータ登録用FactoryBot
FactoryBot.define do
  # --- 本務と兼務を持つ社員
  # 本務情報
  factory :employee_department_regular, class: EmployeeDepartment do
    association(:employee, factory: :employee)
    association(:department, factory: :department_A)
    association(:affilitation_type, factory: :affiltiation_type_regular)
    start_date { Time.zone.local(2021, 4, 1, 0, 0, 0) }
    end_date { Time.zone.local(9999, 12, 31, 23, 59, 59) }
  end
end
