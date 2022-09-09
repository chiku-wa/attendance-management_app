# 所属種別のテストデータ登録用FactoryBot

FactoryBot.define do
  # =======================================================
  # テスト用
  # 本務
  factory :affiliation_type_regular, class: AffiliationType do
    affiliation_type_name { "本務" }
  end

  # 兼務
  factory :affiliation_type_additional, class: AffiliationType do
    affiliation_type_name { "兼務" }
  end
end
