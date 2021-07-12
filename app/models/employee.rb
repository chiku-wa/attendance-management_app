class Employee < ApplicationRecord

  # === 従属関係
  # 社員-部署
  has_many :employee_departments

  # 勤務表
  has_many :work_tables

  # 就業状況
  belongs_to :employment_status

  # === フィルタリング
  before_save :formatting_name

  # === バリデーション
  # 社員コード
  include EmployeeCodeValidators

  # 社員名
  validates(
    :employee_name,
    {
      presence: true,
      length: { maximum: 110 },
    }
  )

  # 社員名(フリガナ)
  validates(
    :employee_name_kana,
    {
      presence: true,
      length: { maximum: 220 },
    }
  )

  # 年齢
  validates(
    :age,
    {
      presence: true,
    }
  )

  # 就業状況
  validates(
    :employment_status,
    {
      presence: true,
    }
  )
end

# ======================================
private

# === メソッド

# 社員名、社員名(フリガナ)の前後の空白を除去し、姓と名の間の空白を半角に変換する
def formatting_name
  [
    "employee_name",
    "employee_name_kana",
  ].each do |attribute|
    # 前後の空白除去
    self.send(attribute)&.gsub!(/^[[:space:]]|[[:space:]]$/, "")

    # 全角スペースを半角スペースに置換
    self.send(attribute)&.gsub!(/　/, " ")
  end
end
