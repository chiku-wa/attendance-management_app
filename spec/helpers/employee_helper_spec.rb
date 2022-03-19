require "rails_helper"
require "font-awesome-sass"

RSpec.describe "社員機能のヘルパーに関するテスト", type: :helper do
  before do
    # リンクボタンの期待値を確認するためのProcオブジェクトを生成する
    @expect_sort_link_proc = Proc.new do |sort_icon, column, direction, label|
      "#{sort_icon}<a id=\"sort_#{column}\" href=\"/employees/list?sort_column=#{column}&amp;sort_direction=#{direction}\">#{label}</a>"
    end
  end

  context "generate_sort_link(社員情報一覧のソートボタン生成)のテスト" do
    it "ソートキー=前回ソートした時と同じ、並び順=未指定、の場合は昇順が設定されること" do
      # ========== パラメータ設定(現在ソートされているカラム、順序)
      # 社員コード、並び替え指定なし
      params[:sort_column] = :employee_code
      params[:sort_direction] = nil

      # ----- 期待値を確認
      sort_column = "employee_code"
      label = "社員コード"

      # 並び順が指定されていないため、アイコンは「↕」となることを確認
      expect_sort_icon = "<i class=\"fas fa-sort\"></i>"
      expect_sort_direction = "asc"

      expect(
        helper.generate_sort_link(column: sort_column, label: label)
      ).to include @expect_sort_link_proc.call(expect_sort_icon, sort_column, expect_sort_direction, label)
    end

    it "ソートキー=前回ソートした時と同じ、並び順=降順、の場合、昇順(指定された並び順とは逆の順序)が設定されること" do
      # ========== パラメータ設定(現在ソートされているカラム、順序)
      # 社員コード、昇順
      params[:sort_column] = :employee_code
      params[:sort_direction] = "desc"

      # ========== 期待値を確認
      sort_column = "employee_code"
      label = "社員コード"

      expect_sort_icon = "<i class=\"fas fa-sort-down\"></i>"
      expect_sort_direction = "asc"

      expect(
        helper.generate_sort_link(column: sort_column, label: label)
      ).to include @expect_sort_link_proc.call(expect_sort_icon, sort_column, expect_sort_direction, label)
    end

    it "ソートしてないカラムのリンクのパラメータには、強制的に昇順が設定されること" do
      # ========== 現在ソートされているパラメータ設定
      # 社員コード、昇順
      params[:sort_column] = :employee_code
      params[:sort_direction] = "asc"

      # ========== 期待値を確認
      # ----- ソートキーとして指定されたカラムの場合
      sort_column = "employee_code"
      label = "社員コード"

      # ソートされているカラムは、アイコンも現在の並び順に連動していること
      expect_sort_icon = "<i class=\"fas fa-sort-up\"></i>"
      # パラメータが現在の並び順とは逆になっていること
      expect_sort_direction = "desc"

      expect(
        helper.generate_sort_link(column: sort_column, label: label)
      ).to include @expect_sort_link_proc.call(expect_sort_icon, sort_column, expect_sort_direction, label)

      # ----- ソートキーとして指定されていないカラムの場合
      sort_column = "email"
      label = "メールアドレス"

      # テストに矛盾点を発生させないための抑止ロジック
      expect(params[:sort_column].to_s).not_to eq sort_column

      # ソートされていないカラムはアイコンが「↕」となること
      expect_sort_icon = "<i class=\"fas fa-sort\"></i>"
      # パラメータが昇順になっていること
      expect_sort_direction = "asc"

      expect(
        helper.generate_sort_link(column: sort_column, label: label)
      ).to include @expect_sort_link_proc.call(expect_sort_icon, sort_column, expect_sort_direction, label)
    end
  end
end
