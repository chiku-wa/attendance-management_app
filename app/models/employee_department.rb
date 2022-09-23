class EmployeeDepartment < ApplicationRecord
  # =============== 従属関係
  # 社員
  belongs_to :employee
  # 部署
  belongs_to :department
  # 所属種別
  belongs_to :affiliation_type

  # =============== バリデーション
  # 着任日
  validates(
    :start_date,
    {
      presence: true,
    }
  )

  # 離任日
  validates(
    :end_date,
    {
      presence: true,
    }
  )

  # =============== カスタムバリデーション
  validate :end_date_is_after_start_date

  private

  # 着任日 >= 離任日の場合はバリデーションエラーとする
  def end_date_is_after_start_date
    # 判定時にエラーとなるため、着任日、離任日のいずれかがnil値ならreutrnし、本バリデーションではチェックを行わない。
    # ※presenceのValidationに一任するため
    return if start_date.blank? || end_date.blank?

    if (start_date.strftime("%Y%m%d").to_i >= end_date.strftime("%Y%m%d").to_i)
      errors.add(
        :start_date,
        I18n.t("activerecord.errors.models.employee_department.attributes.start_date.cannot_be_after_end_date"),
      )
    end
  end
end
