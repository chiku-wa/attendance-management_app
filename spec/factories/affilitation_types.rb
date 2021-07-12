# 所属種別のテストデータ登録用FactoryBot

FactoryBot.define do
  # =======================================================
  # 開発用
  # NOTE:テスト用と同じものを用いる

  # =======================================================
  # テスト用
  # 本務
  factory :affiltiation_type_regular, class: AffilitationType do
    affilitation_type_name { "本務" }
  end

  # 兼務
  factory :affiltiation_type_additional, class: AffilitationType do
    affilitation_type_name { "兼務" }
  end
end
