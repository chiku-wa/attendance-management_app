# ランクのテストデータ登録用FactoryBot
FactoryBot.define do
  factory :rank_S, class: Rank do
    rank_code { "S" }
  end
  factory :rank_A, class: Rank do
    rank_code { "A" }
  end
  factory :rank_B, class: Rank do
    rank_code { "B" }
  end
  factory :rank_C, class: Rank do
    rank_code { "C" }
  end
  factory :rank_D, class: Rank do
    rank_code { "D" }
  end
end
