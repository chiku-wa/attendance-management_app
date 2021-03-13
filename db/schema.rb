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

ActiveRecord::Schema.define(version: 2021_03_11_232336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliation_types", force: :cascade do |t|
    t.string "affiliation_type_name", limit: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["affiliation_type_name"], name: "index_affiliation_types_on_affiliation_type_name", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_name", limit: 200, null: false
    t.string "department_kana_name", limit: 400, null: false
    t.datetime "establishment_date", null: false
    t.datetime "abolished_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "department_code", limit: 10, null: false
    t.index ["department_code"], name: "index_departments_on_department_code", unique: true
  end

  create_table "employee_departments", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false
    t.string "employee_name", limit: 110, null: false
    t.string "employee_name_kana", limit: 220, null: false
    t.integer "age", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "employment_status_id"
    t.index ["employee_code"], name: "index_employees_on_employee_code", unique: true
    t.index ["employment_status_id"], name: "index_employees_on_employment_status_id"
  end

  create_table "employment_statuses", force: :cascade do |t|
    t.string "status_name", limit: 100, null: false
  end

  create_table "hierarchy_departments", force: :cascade do |t|
    t.bigint "parent_department_id", null: false
    t.bigint "child_department_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_code", limit: 110, null: false
    t.string "project_name", limit: 300, null: false
    t.boolean "enabled", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_code"], name: "index_projects_on_project_code", unique: true
    t.index ["project_name"], name: "index_projects_on_project_name", unique: true
  end

  create_table "ranks", force: :cascade do |t|
    t.string "rank_code", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rank_code"], name: "index_ranks_on_rank_code", unique: true
  end

  create_table "work_tables", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false
    t.datetime "working_date", null: false
    t.string "project_code", limit: 110, null: false
    t.string "rank_code", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "employee_departments", "departments", name: "fk_department_id"
  add_foreign_key "employee_departments", "employees", name: "fk_emplouee_id"
  add_foreign_key "employees", "employment_statuses", name: "fk_employment_statuses_id"
  add_foreign_key "hierarchy_departments", "departments", column: "child_department_id", name: "fk_child_department_id"
  add_foreign_key "hierarchy_departments", "departments", column: "parent_department_id", name: "fk_parent_department_id"
end
