class Employee < ApplicationRecord
  # =============== ログイン機構を使用するためのdeviseの設定
  devise(
    # パスワードを暗号化してDBに登録:有効
    :database_authenticatable,

    # サインアップ、ユーザ自身が情報を変更することを許可:無効化
    # ※システム管理者があらかじめ社員を登録していることが前提であり、第三者がサインアップすることは許さない
    # :registerable,

    # パスワードリセット機能:有効
    :recoverable,

    # ログイン状態を記憶する機能:有効
    :rememberable,

    # メールアドレス、パスワードのバリデーション機能:有効
    :validatable
  )

  # =============== 従属関係
  # 社員-部署
  has_many :employee_departments

  # 勤務表
  has_many :work_tables

  # 就業状況
  belongs_to :employment_status

  # 社員-権限(中間テーブル)、権限
  has_many :employee_roles
  has_many :roles, through: :employee_roles

  # =============== フィルタリング
  before_save :formatting_name

  # =============== バリデーション
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

  # メールアドレス
  validates(
    :email,
    {
      length: { maximum: 255 },
    }
  )
end

# =============== パブリックメソッド
public

def has_role?(role_name)
  self.roles.map(&:role_name).include?(role_name)
end

# =============== プライベートメソッド
private

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
