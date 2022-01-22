class EmployeeController < ApplicationController
  # [cancancan]でアクセス制御を行うための定義
  authorize_resource

  def list
  end
end
