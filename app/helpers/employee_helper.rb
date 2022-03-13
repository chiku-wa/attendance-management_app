#
# 社員に関する処理に必要な共通メソッドを定義するヘルパークラス
#
module EmployeeHelper
  # =====================================================
  # View関連
  #

  # -----------------------------------------------------
  # # 概要
  # 社員一覧画面において、ソート処理のトリガとなるリンクを生成するためのメソッド。
  # リンクのURLには以下のパラメータを付与する。
  # * ソートのキーとなるカラム名：引数のカラム名をそのまま付与する
  # * ソートの順序(昇順、降順)：現在ソートされている順序とは逆の順序文字列(asc,desc)を付与する。
  #   ただし、現在ソートされているカラムとは別のカラムのリンクボタンを生成する場合は、デフォルトの並び順(昇順)を設定する。
  #
  # # 引数
  # * column
  # リンクボタンに埋め込む、ソートキーとなるカラム名
  # --
  # * label
  # リンクボタンのラベル名
  def generate_sort_link(column:, label:)
    # デフォルトの並び順
    sort_direction = "asc"
    # デフォルトのアイコン(↕)
    sort_icon = icon("fas", "sort")

    if column.to_s == params[:sort_column].to_s
      # 現在ソートされているカラムなら、現在の並び順とは逆の並び順をリンクのパラメータとして指定する。
      # 不正なパラメータ値が設定されている場合は昇順を設定する
      sort_direction = params[:sort_direction] == "asc" ? "desc" : "asc"

      # アイコンには現在の並び順に準拠した並び順を設定する
      # 不正なパラメータ値が設定されているならデフォルト値を使用する
      sort_icon = case params[:sort_direction]
        when "asc"
          icon("fas", "sort-up")
        when "desc"
          icon("fas", "sort-down")
        else
          sort_icon
        end
    end

    sort_icon + link_to(label, employees_list_path(sort_column: column, sort_direction: sort_direction))
  end
end
