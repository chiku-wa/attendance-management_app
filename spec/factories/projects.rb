# プロジェクトのテストデータ登録用FactoryBot
FactoryBot.define do
  factory :project, class: Project do
    project_code { "AB00001" }
    project_name { "プロジェクトA" }
    enabled { true }
    start_date { Time.zone.local(2021, 4, 1, 0, 0, 0) }
    end_date { Time.zone.local(2022, 3, 31, 0, 0, 0) }
  end
end
