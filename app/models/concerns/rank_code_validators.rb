module RankCodeValidators
  extend ActiveSupport::Concern

  included do
    validates(
      :rank_code,
      {
        presence: true,
        length: { maximum: 2 },
        # 大文字小文字を区別せず一意とする
        uniqueness: { case_sensitive: false },
      }
    )
  end
end
