#
# deviseから送信される各種メールをカスタマイズするためのクラス
#
class DeviseMailer < Devise::Mailer
  # メール本文内に画像を埋め込むための
  before_action :add_inline_attachment!

  # ----------------------------------------------------
  # # 概要
  # パスワードリセットメールのカスタマイズ用メソッド
  def reset_password_instructions(record, token, opts = {})
    mail = super

    # 件名の先頭にアプリ名を付与する
    mail.subject = "【#{I18n.t("app_name")}】#{mail.subject}"

    mail
  end

  private

  # ----------------------------------------------------
  # # 概要
  # メール本文内に画像を埋め込むための読み込み処理
  def add_inline_attachment!
    image_names = [
      # ロゴ
      "logo.png",
    ]

    image_names.each do |image_name|
      attachments.inline[image_name] = File.read("#{Rails.root}/app/assets/images/" + image_name)
    end
  end
end
