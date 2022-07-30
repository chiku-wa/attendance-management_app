class Employee < ApplicationRecord
  # =============== コールバック
  before_validation(:merge_first_name_and_last_name)

  # =============== ログイン機構を使用するためのdeviseの設定
  devise(
    # パスワードを暗号化してDBに登録:有効
    :database_authenticatable,

    # 新規登録、ユーザ自身が情報を変更することを許可:有効
    # ※サインアップ機能そのものは有効化するが、システム管理者しか新規登録・編集できないように制御を行う
    :registerable,

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

  # =============== バリデーション
  # 社員コード
  include EmployeeCodeValidators

  # 社員名(姓)
  validates(
    :employee_last_name,
    {
      presence: true,
      length: { maximum: 100 },
    }
  )

  # 社員名(名)
  validates(
    :employee_first_name,
    {
      presence: true,
      length: { maximum: 100 },
    }
  )

  # 社員名(姓・名)
  validates(
    :employee_full_name,
    {
      presence: true,
      length: { maximum: 201 },
    }
  )

  # 社員名カナ(姓)
  validates(
    :employee_last_name_kana,
    {
      presence: true,
      length: { maximum: 200 },
    }
  )

  # 社員名カナ(名)
  validates(
    :employee_first_name_kana,
    {
      presence: true,
      length: { maximum: 200 },
    }
  )

  # 社員名カナ(姓・名)
  validates(
    :employee_full_name_kana,
    {
      presence: true,
      length: { maximum: 401 },
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
  return false if self.blank?
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

# ----------------------------------------------------
# # 概要
# 以下の処理を行う。
# * 社員名(姓)と社員名(名)を全角文字で区切って結合し、社員名(姓・名)プロパティに格納
# * 社員名カナ(姓)と社員名カナ(名)を全角文字で区切って結合し、社員名カナ(姓・名)プロパティに格納
#
# # 引数
# なし
#
# # 戻り値
# なし
#
def merge_first_name_and_last_name
  # 社員名(姓)と社員名(名)を結合
  self.employee_full_name = "#{employee_last_name}　#{employee_first_name}"

  # 社員名カナ(姓)と社員名カナ(名)を結合
  self.employee_full_name_kana = "#{employee_last_name_kana}　#{employee_first_name_kana}"
end
