# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_02_230557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affilitation_types", comment: "所属種別", force: :cascade do |t|
    t.string "affilitation_type_name", limit: 10, null: false, comment: "所属種別名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["affilitation_type_name"], name: "unique_affilitation_types_on_affilitation_type_name", unique: true
  end

  create_table "departments", comment: "部署テーブル", force: :cascade do |t|
    t.string "department_name", limit: 200, null: false, comment: "部署名"
    t.string "department_kana_name", limit: 400, null: false, comment: "部署名(カナ)"
    t.datetime "establishment_date", null: false, comment: "設立日"
    t.datetime "abolished_date", null: false, comment: "廃止日"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "department_code", limit: 12, null: false, comment: "部署コード"
    t.index ["department_code", "establishment_date", "abolished_date"], name: "unique_departments_on_department_code_establishment_abolished", unique: true
  end

  create_table "employee_departments", comment: "社員 - 部署", force: :cascade do |t|
    t.bigint "department_id", null: false, comment: "部署ID"
    t.bigint "employee_id", null: false, comment: "社員ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "affilitation_type_id", null: false, comment: "所属種別ID"
    t.datetime "start_date", precision: 6, null: false, comment: "着任日"
    t.datetime "end_date", precision: 6, null: false, comment: "離任日"
  end

  create_table "employees", comment: "社員", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false, comment: "社員コード"
    t.string "employee_name", limit: 110, null: false, comment: "社員名"
    t.string "employee_name_kana", limit: 220, null: false, comment: "社員名(フリガナ)"
    t.integer "age", limit: 2, null: false, comment: "年齢"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "employment_status_id", null: false, comment: "就業状況ID"
    t.index ["employee_code"], name: "unique_employees_on_employee_code", unique: true
  end

  create_table "employment_statuses", comment: "就業状況", force: :cascade do |t|
    t.string "status_name", limit: 100, null: false, comment: "就業状況"
    t.string "status_code", limit: 5, null: false, comment: "就業状況コード"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_code"], name: "unique_employment_statuses_on_status_code", unique: true
    t.index ["status_name"], name: "unique_employment_statuses_on_status_name", unique: true
  end

  create_table "hierarchy_departments", comment: "部署階層", force: :cascade do |t|
    t.bigint "parent_department_id", null: false, comment: "親部署ID"
    t.bigint "child_department_id", null: false, comment: "子親部署ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", comment: "プロジェクト", force: :cascade do |t|
    t.string "project_code", limit: 110, null: false, comment: "プロジェクトコード"
    t.string "project_name", limit: 300, null: false, comment: "プロジェクト名"
    t.boolean "enabled", null: false, comment: "有効フラグ"
    t.datetime "start_date", comment: "プロジェクト開始日"
    t.datetime "end_date", comment: "プロジェクト終了日"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_code"], name: "unique_projects_on_project_code", unique: true
  end

  create_table "ranks", comment: "ランク", force: :cascade do |t|
    t.string "rank_code", limit: 2, null: false, comment: "ランクコード"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rank_code"], name: "index_ranks_on_rank_code", unique: true
  end

  create_table "work_tables", comment: "勤務表", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false, comment: "就業状況コード"
    t.datetime "working_date", null: false, comment: "勤務日"
    t.string "project_code", limit: 110, null: false, comment: "プロジェクトコード"
    t.string "rank_code", limit: 2, null: false, comment: "ランクコード"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "closed", null: false, comment: "締めフラグ"
  end

  add_foreign_key "employee_departments", "affilitation_types", name: "fk_affilitation_type_id"
  add_foreign_key "employee_departments", "departments", name: "fk_department_id"
  add_foreign_key "employee_departments", "employees", name: "fk_employee_id"
  add_foreign_key "employees", "employment_statuses", name: "fk_employment_status_id"
  add_foreign_key "hierarchy_departments", "departments", column: "child_department_id", name: "fk_child_department_id"
  add_foreign_key "hierarchy_departments", "departments", column: "parent_department_id", name: "fk_parent_department_id"
end
