#
# 社員に関する処理に必要な共通メソッドを定義するヘルパークラス
#
module EmployeeHelper
  # =====================================================
  # View関連
  #

  # -----------------------------------------------------
  # # 概要
  # 社員一覧画面において、ソート処理のトリガとなるリンクを生成するためのメソッド
  #
  # # 引数
  # * リンクボタンに埋め込む、ソートキーとなるカラム名
  # テスト対象のモデルインスタンスを指定する
  # --
  # * label
  # リンクボタンのラベル名
  def generate_sort_link(column:, label:)
    # 昇順にソートされた場合は降順のリンクを、降順にソートされた場合は昇順のリンクを生成する
    # ※asc,desc以外の値の場合は明示的にascを設定する
    sort_direction = params[:sort_direction] == "asc" ? "desc" : "asc"
    link_to(label, employees_list_path(sort_column: column, sort_direction: sort_direction))
  end
end
