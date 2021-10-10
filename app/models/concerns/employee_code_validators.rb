module EmployeeCodeValidators
  extend ActiveSupport::Concern

  included do
    validates(
      :employee_code,
      {
        presence: true,
        length: { maximum: 6 },
        # 大文字小文字を区別せず一意とする
        uniqueness: { case_sensitive: false },
      }
    )
  end
end
