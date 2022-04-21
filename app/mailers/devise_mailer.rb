#
# deviseから送信される各種メールをカスタマイズするためのクラス
#
class DeviseMailer < Devise::Mailer
  # ----------------------------------------------------
  # # 概要
  # パスワードリセットメールのカスタマイズ用メソッド
  def reset_password_instructions(record, token, opts = {})
    mail = super

    # 件名の先頭にアプリ名を付与する
    mail.subject = "【#{I18n.t("app_name")}】#{mail.subject}"

    mail
  end
end
