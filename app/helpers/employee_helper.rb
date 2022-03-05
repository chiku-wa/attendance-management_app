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
    # ----- リンクに埋め込むソートの昇順・降順を定義する
    # 昇順にソートされた場合は降順のリンクを、降順にソートされた場合は昇順のリンクを生成する
    # ※asc,desc以外の値の場合は明示的にascを設定する
    sort_direction = params[:sort_direction] == "asc" ? "desc" : "asc"

    # ----- 現在のソート状況を指し示すアイコンを生成する
    sort_icon = icon("fas", "sort")
    # 現在ソートされているカラムなら対応する矢印のアイコンに変更する
    if column.to_s == params[:sort_column].to_s
      sort_icon = sort_direction == "asc" ? icon("fas", "sort-up") : icon("fas", "sort-down")
    end

    sort_icon + link_to(label, employees_list_path(sort_column: column, sort_direction: sort_direction))
  end
end
