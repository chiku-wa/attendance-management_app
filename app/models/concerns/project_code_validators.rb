module ProjectCodeValidators
  extend ActiveSupport::Concern

  included do
    validates(
      :project_code,
      {
        presence: true,
        length: { maximum: 7 },
        # 大文字小文字を区別せず一意とする
        uniqueness: { case_sensitive: false },
      }
    )
  end
end
