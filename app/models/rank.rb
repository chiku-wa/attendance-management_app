class Rank < ApplicationRecord
  # === バリデーション
  # ランクコード
  include RankCodeValidators
end
