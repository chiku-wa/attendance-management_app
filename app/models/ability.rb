# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # ----------------------------------------------------
  # # 概要
  # cancancanの標準メソッド。
  # 引数として渡したユーザ認証用モデルインスタンス(本アプリではEmployeeモデルクラス)をもとに、
  # 紐づく権限(Roleモデルクラス)によってアクセスできる機能を制御する。
  # なお、ホワイトリスト形式とし、一旦すべての機能に対してアクセスを制限(cannot)した上で許可(can)する。
  #
  # 権限の上下関係は下記のとおりとする。
  # システム管理者 > マネージャ > 一般社員
  #
  # 上位権限を有している社員は、下位の権限がアクセス可能な機能はすべて利用可能であることとする。
  #
  # # 引数
  # * employee
  # ユーザ認証用モデルインスタンス(デフォルトのuserから変更)
  #
  def initialize(employee)
    # =============== 共通設定
    # すべての機能を制限する
    # ※cancancanのデフォルトなので特に明示しない

    # =============== アクセス制限設定
    if employee.has_role?(I18n.t("master_data.role.admin"))
      # ----- システム管理者
      # マネージャがアクセス可能な機能を許可
      can_manager

      # システム管理者のみがアクセス可能な機能を許可
      # 社員情報
      can(:list, Employee)
    elsif employee.has_role?(I18n.t("master_data.role.manager"))
      # ----- マネージャ
      # マネージャがアクセス可能な機能を許可
      can_manager
    elsif employee.has_role?(I18n.t("master_data.role.common"))
      # ----- 一般社員
      # 一般社員がアクセス可能な機能を許可
      can_common
    end
  end

  # =============== プライベートメソッド
  private

  # ----------------------------------------------------
  # # 概要
  # 一般社員に対するアクセス許可設定をまとめたメソッド。
  #
  def can_common
    # 勤怠画面へのアクセスを許可
    can(:manage, :main)
  end

  # ----------------------------------------------------
  # # 概要
  # マネージャに対するアクセス許可設定をまとめたメソッド。
  #
  def can_manager
    # 勤怠画面へのアクセスを許可
    can_common
  end
end
