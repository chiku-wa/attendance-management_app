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

# ----------------------------------------------------
# # 概要
# 引数として渡した文字列と同名の権限を、社員が有しているかを判定するメソッド。
#
# # 引数
# * role_name
# 権限の有無を確認したい権限の「権限名」を指定する
#
# # 戻り値
# 権限有り : true
# 権限無し : false
#
def has_role?(role_name)
  self.roles.map(&:role_name).include?(role_name)
end

# ----------------------------------------------------
# # 概要
# 引数として渡した文字列と同名の権限を社員に付与するメソッド。
#
# # 引数
# * role_name
# 付与したい権限の「権限名」を指定する
#
# # 戻り値
# 権限の付与に成功 : true
# 権限の付与に失敗 : false
#
def add_role(role_name)
  # すでに権限が付与済みならfalseを返す
  if self.has_role?(role_name)
    return false
  end

  # 権限を抽出し、存在する権限なら付与を行う
  role = Role.find_by(role_name: role_name)

  # 権限が抽出できた場合は付与する
  if role
    self.roles << role
    return true
  else
    return false
  end
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
