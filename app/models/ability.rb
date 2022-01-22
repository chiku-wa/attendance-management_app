# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(employee)
    # ----- 以下はcancancanで自動出力された文字コメント定義
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    # -----
    # ==============ポリシー
    # ブラックリスト形式とする。一旦すべての機能に対してアクセスを許した上で制限を加える。
    # [理由]アクセスを許容する`can`メソッドには、コントローラ、アクションは指定できないため
    #

    # =============== 共通設定
    # すべての機能を利用可能にする
    can(:manage, :all)

    # =============== アクセス制限設定
    if employee.roles.map(&:role_name).include?(I18n.t("master_data.role.admin"))
      # ----- システム管理者
      # ※すべての機能を利用可能にするため`cannnot`による制限は行わない

    elsif employee.roles.map(&:role_name).include?(I18n.t("master_data.role.manager"))
      # ----- マネージャ
      # 社員情報登録画面

    elsif employee.roles.map(&:role_name).include?(I18n.t("master_data.role.common"))
      # ----- 一般社員

    else
      # ----- その他の権限(権限を持っていない場合も含む)
      # すべてのページにアクセスできないようにする
      cannot(:manage, :all)
    end
  end
end
