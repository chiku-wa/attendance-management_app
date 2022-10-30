class EmployeeDepartment < ApplicationRecord
  # =============== 定数
  # 有効な本務・兼務を意味する離任日の固定値
  END_DATE_FOR_ENABLED_AFFILIATION = Time.zone.parse("9999-12-31 23:59:59")

  # 本務の上限は1とする
  MAX_REGULAR = 1

  # 兼務の上限は5とする
  MAX_ADDITIONAL = 5

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
  validate(
    :end_date_is_after_start_date,
    :enabled_regular_is_only_one,
  )

  private

  # 着任日 >= 離任日の場合はバリデーションエラーとする
  def end_date_is_after_start_date
    # 判定時にエラーとなるため、前提となるプロパティがnilならreutrnし、本バリデーションではチェックを行わない。
    return if start_date.blank? || end_date.blank?

    if (start_date.strftime("%Y%m%d").to_i >= end_date.strftime("%Y%m%d").to_i)
      errors.add(
        :start_date,
        I18n.t("activerecord.errors.models.employee_department.attributes.start_date.cannot_be_after_end_date"),
      )
    end
  end

  # 有効組織の本務が複数設定されている場合はバリデーションエラーとする
  def enabled_regular_is_only_one
    # 判定時にエラーとなるため、前提となるプロパティがnilならreutrnし、本バリデーションではチェックを行わない。
    return if self.employee.blank? || self.affiliation_type.blank?

    # すでに登録済みの有効な本務数を抽出する
    registered_enabled_regular_department_size = EmployeeDepartment.joins(
      :affiliation_type
    ).where(
      employee_id: self.employee.id,
      affiliation_types: {
        affiliation_type_name: I18n.t("master_data.affiliation_type.affiliation_type_name.regular"),
      },
      end_date: END_DATE_FOR_ENABLED_AFFILIATION,
    ).count

    # 登録しようとしている有効な本務数を抽出する
    this_regular_department_size =
      (self.affiliation_type.affiliation_type_name == I18n.t("master_data.affiliation_type.affiliation_type_name.regular") &&
       self.end_date == END_DATE_FOR_ENABLED_AFFILIATION) ? 1 : 0

    # 「(すでに登録済みの有効な本務数 + 登録しようとしている有効な本務数) > 許容する本務の数」ならエラーとする
    if (registered_enabled_regular_department_size + this_regular_department_size) > MAX_REGULAR
      errors.add(
        :affiliation_type,
        I18n.t(
          "activerecord.errors.models.employee_department.attributes.affiliation_type.regular_is_only_one",
          max_regular: MAX_REGULAR,
        ),
      )
    end
  end
end
