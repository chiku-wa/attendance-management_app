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
  has_many :employee_roles, dependent: :destroy # 社員が削除された場合は、権限も連動して削除する
  has_many :roles, through: :employee_roles

  # 社員-部署、部署
  has_many :employee_departments, dependent: :destroy # 社員が削除された場合は、部署の所属情報も連動して削除する
  has_many :departments, through: :employee_departments

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
  # 社員インスタンスが空の場合はfalseを返す
  return false if self.blank?

  # 権限名に一致する権限を有している場合はtrueを返す
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
  if role
    self.roles << role
    return true
  else
    return false
  end
end

# ----------------------------------------------------
# # 概要
# 引数として渡した部署インスタンスを、社員が有しているかを判定するメソッド。
#
# # 引数
# * department
# 所属の有無を確認したい部署インスタンスを指定する
#
# # 戻り値
# 所属有り : true
# 所属無し : false
#
def has_department?(department)
  # 社員インスタンスが空の場合はfalseを返す
  return false if self.blank?

  # 引数の部署インスタンスを保有している場合はtrueを返す
  self.departments.include?(department)
end

# ----------------------------------------------------
# # 概要
# 引数として渡した組織、所属種別、着任日、離任日をもとに、社員に部署の所属情報を付与するメソッド。
#
# # 引数
# * department
# 付与したい部署インスタンスを指定する
#
# * affiliation_type_name
# 所属種別名

#
# # 戻り値
# 所属情報の付与に成功 : 社員-部署情報のインスタンス
# 所属情報の付与に失敗 : 例外を発生させる。
# すでに所属情報が付与済み：nil
#
def add_department(department:, affiliation_type_name:, start_date:, end_date:)
  # 引数に合致するの所属種別がない場合は例外を発生させる
  affiliation_type = AffiliationType.find_by(
    affiliation_type_name: affiliation_type_name,
  )

  if affiliation_type.blank?
    raise(
      RuntimeError,
      "#{I18n.t("activerecord.attributes.affiliation_type.affiliation_type_name")}に一致する#{I18n.t("activerecord.models.affiliation_type")}が存在しません。",
    )
  end

  # 部署の設立日 >= 着任日(時分秒が異なっても同日であれば)の場合はnilを返す
  if (start_date.strftime("%Y%m%d").to_i >= end_date.strftime("%Y%m%d").to_i)
    raise(
      RuntimeError,
      "#{I18n.t("activerecord.errors.models.employee_department.attributes.start_date.cannot_be_after_end_date")}"
    )
  end

  # すでに同一の部署が付与済みならnilを返す
  return nil if EmployeeDepartment.find_by(
    department: department,
    employee: self,
  )

  # 部署を付与し、社員-部署インスタンスを返す
  EmployeeDepartment.create(
    employee: self,
    department: department,
    affiliation_type: affiliation_type,
    start_date: start_date,
    end_date: end_date,
  )
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
