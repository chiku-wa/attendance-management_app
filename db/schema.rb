# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_26_232630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliation_types", comment: "所属種別", force: :cascade do |t|
    t.string "affiliation_type_name", limit: 10, null: false, comment: "所属種別名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["affiliation_type_name"], name: "unique_affiliation_types_on_affiliation_type_name", unique: true
  end

  create_table "department_hierarchies", comment: "部署階層", force: :cascade do |t|
    t.bigint "parent_department_id", null: false, comment: "親部署ID"
    t.bigint "child_department_id", null: false, comment: "子親部署ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "generations", null: false
    t.index ["parent_department_id", "child_department_id"], name: "index_department_hierarchies_on_parent_child", unique: true
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
    t.bigint "affiliation_type_id", null: false, comment: "所属種別ID"
    t.datetime "start_date", precision: 6, null: false, comment: "着任日"
    t.datetime "end_date", precision: 6, null: false, comment: "離任日"
  end

  create_table "employee_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "employee_id", null: false
    t.bigint "role_id", null: false
    t.index ["employee_id", "role_id"], name: "unique_employee_roles_on_employee_id_role_id", unique: true
    t.index ["employee_id"], name: "index_employee_roles_on_employee_id"
    t.index ["role_id"], name: "index_employee_roles_on_role_id"
  end

  create_table "employees", comment: "社員", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false, comment: "社員コード"
    t.integer "age", limit: 2, null: false, comment: "年齢"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "employment_status_id", null: false, comment: "就業状況ID"
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "employee_last_name", limit: 100, null: false, comment: "社員名(姓)"
    t.string "employee_first_name", limit: 100, null: false, comment: "社員名(名)"
    t.string "employee_last_name_kana", limit: 200, null: false, comment: "社員名カナ(姓)"
    t.string "employee_first_name_kana", limit: 200, null: false, comment: "社員名カナ(名)"
    t.string "employee_full_name", limit: 201, null: false, comment: "社員名(姓・名)"
    t.string "employee_full_name_kana", limit: 401, null: false, comment: "社員名カナ(姓・名)"
    t.index ["email"], name: "unique_employees_on_email", unique: true
    t.index ["employee_code"], name: "unique_employees_on_employee_code", unique: true
    t.index ["reset_password_token"], name: "unique_employees_on_reset_password_token", unique: true
  end

  create_table "employment_statuses", comment: "就業状況", force: :cascade do |t|
    t.string "status_name", limit: 100, null: false, comment: "就業状況"
    t.string "status_code", limit: 5, null: false, comment: "就業状況コード"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_code"], name: "unique_employment_statuses_on_status_code", unique: true
    t.index ["status_name"], name: "unique_employment_statuses_on_status_name", unique: true
  end

  create_table "projects", comment: "プロジェクト", force: :cascade do |t|
    t.string "project_code", limit: 7, null: false, comment: "プロジェクトコード"
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

  create_table "roles", force: :cascade do |t|
    t.string "role_name", limit: 20, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_name"], name: "unique_roles_on_role_name", unique: true
  end

  create_table "work_tables", comment: "勤務表", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false, comment: "社員コード"
    t.datetime "work_date", precision: 6, null: false, comment: "出勤日時"
    t.string "project_code", limit: 7, null: false, comment: "プロジェクトコード"
    t.string "rank_code", limit: 2, null: false, comment: "ランクコード"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "closed", null: false, comment: "締めフラグ"
    t.bigint "employee_id", null: false, comment: "社員ID"
    t.bigint "project_id", null: false, comment: "プロジェクトID"
    t.bigint "employment_status_id", null: false, comment: "就業状況ID"
    t.bigint "rank_id", null: false, comment: "ランクID"
    t.string "status_code", limit: 5, null: false, comment: "就業状況コード"
    t.datetime "leave_date", precision: 6, null: false, comment: "退勤日時"
    t.index ["employee_id"], name: "index_work_tables_on_employee_id"
    t.index ["employment_status_id"], name: "index_work_tables_on_employment_status_id"
    t.index ["project_id"], name: "index_work_tables_on_project_id"
    t.index ["rank_id"], name: "index_work_tables_on_rank_id"
  end

  add_foreign_key "department_hierarchies", "departments", column: "child_department_id", name: "fk_child_department_id"
  add_foreign_key "department_hierarchies", "departments", column: "parent_department_id", name: "fk_parent_department_id"
  add_foreign_key "employee_departments", "affiliation_types", name: "fk_affiliation_type_id"
  add_foreign_key "employee_departments", "departments", name: "fk_department_id"
  add_foreign_key "employee_departments", "employees", name: "fk_employee_id", on_delete: :cascade
  add_foreign_key "employee_roles", "employees", name: "fk_employee_id", on_delete: :cascade
  add_foreign_key "employee_roles", "roles", name: "fk_role_id"
  add_foreign_key "employees", "employment_statuses", name: "fk_employment_status_id"
  add_foreign_key "work_tables", "employees", name: "fk_employee_id"
  add_foreign_key "work_tables", "employment_statuses", name: "fk_employment_status_id"
  add_foreign_key "work_tables", "projects", name: "fk_project_id"
  add_foreign_key "work_tables", "ranks", name: "fk_rank_id"
end
