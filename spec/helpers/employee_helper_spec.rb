require "rails_helper"
require "font-awesome-sass"

RSpec.describe "社員機能のヘルパーに関するテスト", type: :helper do
  context "generate_sort_link(社員情報一覧のソートボタン生成)のテスト" do
    it "ソートキー=前回ソートした時と同じ、並び順=未指定、の場合、昇順が設定されること" do
      # ----- パラメータ設定
      # ソートキー:社員コード
      params[:sort_column] = :employee_code
      # 並び順:昇順
      params[:sort_direction] = nil

      # ----- メソッドを実行して期待値を確認
      expect_sort_icon = "<i class=\"fas fa-sort-up\"></i>"
      expect_sort_column = "employee_code"
      expect_sort_direction = "asc"
      expect_label = "社員コード"

      expect(
        helper.generate_sort_link(column: :employee_code, label: "社員コード")
      ).to include "#{expect_sort_icon}<a href=\"/employees/list?sort_column=#{expect_sort_column}&amp;sort_direction=#{expect_sort_direction}\">#{expect_label}</a>"
    end

    it "ソートキー=前回ソートした時と同じ、並び順=降順、の場合、昇順(指定された並び順とは逆の順序)が設定されること" do
      # ----- パラメータ設定
      # ソートキー:社員コード
      params[:sort_column] = :employee_code
      # 並び順:昇順
      params[:sort_direction] = "desc"

      # ----- メソッドを実行して期待値を確認
      expect_sort_icon = "<i class=\"fas fa-sort-up\"></i>"
      expect_sort_column = "employee_code"
      expect_sort_direction = "asc"
      expect_label = "社員コード"

      expect(
        helper.generate_sort_link(column: :employee_code, label: "社員コード")
      ).to include "#{expect_sort_icon}<a href=\"/employees/list?sort_column=#{expect_sort_column}&amp;sort_direction=#{expect_sort_direction}\">#{expect_label}</a>"
    end
  end
end
