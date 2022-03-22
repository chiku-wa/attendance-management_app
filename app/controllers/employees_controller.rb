class EmployeesController < ApplicationController
  # [cancancan]でアクセス制御を行うための定義
  authorize_resource

  # -----------------------------------------------------
  # # 概要
  # 社員情報一覧画面に遷移するアクション
  def list
    # ----- ソート情報を取得する
    # ソートするカラムを取得する。想定しない値がパラメータに存在する場合は社員コードをキーとする。
    # ※社員一覧に出力する際に使用しているすべてのテーブルのカラムをベースにする
    sort_column = "employee_code"
    [
      Employee,
      Role,
      EmploymentStatus,
    ].each do |model_class|
      # 社員情報一覧に必要な情報がパラメータとして指定されている場合はソートキーとする。
      if model_class.column_names.include?(params[:sort_column])
        # 結合テーブルのカラム名でもソートできるようにテーブル名を修飾する。
        sort_column = "#{model_class.table_name}.#{params[:sort_column]}"
      end
    end

    # 昇順・降順を取得する。想定しない値がパラメータに存在する場合は昇順とする。
    sort_direction = ["asc", "desc"].include?(params[:sort_direction]) ?
      params[:sort_direction] : "asc"

    # ----- 以下の条件で社員情報一覧を取得
    # * ログインしているユーザは除外する
    # * N+1問題を回避するため、Viewで必要なテーブルを事前に結合しておく
    # * 受け取ったソート情報をもとにソートする、なお冗長性のあるカラム(権限、就業状況などの
    #   外部のマスタテーブルの外部キーなど)でソートした場合にも並び順が保証されるように、
    #   order byの2つめには社員コード(昇順)を固定で指定する
    # * `kaminari`gemのページネーションを考慮する
    @employees = Employee
      .where.not(id: current_employee.id)
      .includes([:roles, :employment_status])
      .order("#{sort_column} #{sort_direction}")
      .order("employee_code asc")
      .page(params[:page])
  end
end
