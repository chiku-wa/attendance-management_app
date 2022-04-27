# 就業状況のテストデータ登録用FactoryBot
FactoryBot.define do
  # =======================================================
  # テスト用
  # 在職
  factory :employment_status_work, class: EmploymentStatus do
    status_code { I18n.t("master_data.employment_status.status_code.work") }
    status_name { I18n.t("master_data.employment_status.status_name.work") }
  end

  # 休職
  factory :employment_status_absences, class: EmploymentStatus do
    status_code { I18n.t("master_data.employment_status.status_code.absences") }
    status_name { I18n.t("master_data.employment_status.status_name.absences") }
  end

  # 退職
  factory :employment_status_retirement, class: EmploymentStatus do
    status_code { I18n.t("master_data.employment_status.status_code.retirement") }
    status_name { I18n.t("master_data.employment_status.status_name.retirement") }
  end
end
