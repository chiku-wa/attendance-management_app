class EmploymentStatus < ApplicationRecord
  # === 従属関係
  # 社員
  has_many :employees

  # === バリデーション
  # 就業状況コード
  include EmploymentStatusCodeValidators

  # 就業状況
  validates(
    :status_name,
    {
      presence: true,
      uniqueness: { case_sensitive: false }, # 大文字と小文字は区別しない
      length: { maximum: 100 },
    }
  )
end
