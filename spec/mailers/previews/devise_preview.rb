#
# deviseで送信するメールのプレビューを確認するためのクラス
#
class DevisePreview < ActionMailer::Preview

  # ----------------------------------------------------
  # # 概要
  # パスワードリセットのメールをプレビューするためのメソッド
  #
  def reset_password_instructions
    # 一般社員をサンプルとして抽出する
    DeviseMailer.reset_password_instructions(
      Employee.includes([:roles]).where("roles.role_name" => I18n.t("master_data.role.common")).first,
      Devise.friendly_token[0, 20],
    )
  end
end
