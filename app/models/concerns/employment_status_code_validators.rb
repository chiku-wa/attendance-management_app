module EmploymentStatusCodeValidators
  extend ActiveSupport::Concern

  included do
    validates(
      :status_code,
      {
        presence: true,
        uniqueness: { case_sensitive: false }, # 大文字と小文字は区別しない
        length: { maximum: 5 },
      }
    )
  end
end
