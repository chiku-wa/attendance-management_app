class Project < ApplicationRecord

  # === バリデーション
  # プロジェクトコード
  validates(
    :project_code,
    {
      presence: true,
      length: { maximum: 7 },
      # 大文字小文字を区別せず一意とする
      uniqueness: { case_sensitive: false },
    }
  )

  # プロジェクト名
  validates(
    :project_name,
    {
      presence: true,
      length: { maximum: 300 },
    }
  )

  # 有効フラグ
  validates(
    :enabled,
    {
      presence: true,
    }
  )

  # プロジェクト開始日と終了日のバリデーション
  validate :start_or_end_is_nil

  # ======================================
  private

  # プロジェクト開始日、プロジェクト終了日のいずれかしか登録されていない(どちらか片方のみnil)場合
  # はエラーを発生させる。
  # ※業務上、プロジェクト開始日とプロジェクト終了日双方がnilはまだ開始されていないプロジェクトを
  #  意味するが、どちらか片方しか登録されていないケースはありえないため
  def start_or_end_is_nil
    if self.start_date.present? && !self.end_date.present?
      errors.add(:end_date, "がnilです。")
    end
    if !self.start_date.present? && self.end_date.present?
      errors.add(:start_date, "がnilです。")
    end
  end
end
