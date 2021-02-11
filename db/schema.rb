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

ActiveRecord::Schema.define(version: 2021_02_11_010133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "department_trees", force: :cascade do |t|
    t.integer "parent_department_id", null: false
    t.integer "child_department_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_name", limit: 200, null: false
    t.string "department_kana_name", limit: 400, null: false
    t.datetime "establishment_date", null: false
    t.datetime "abolished_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "department_code", limit: 10, null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_code", limit: 6, null: false
    t.string "employee_name", limit: 110, null: false
    t.string "employee_name_kana", limit: 220, null: false
    t.integer "age", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "department_trees", "departments", column: "child_department_id", name: "fk_child_department_id"
  add_foreign_key "department_trees", "departments", column: "parent_department_id", name: "fk_parent_department_id"
end
