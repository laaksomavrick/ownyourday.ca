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

ActiveRecord::Schema[7.0].define(version: 2023_10_22_152033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "metadata", default: "{}", null: false
    t.integer "position"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.bigint "goal_id"
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_milestones_on_goal_id"
  end

  create_table "task_lists", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "date", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date"], name: "index_task_lists_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_task_lists_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "goal_id"
    t.bigint "task_list_id"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "name"
    t.integer "position"
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
    t.index ["task_list_id"], name: "index_tasks_on_task_list_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", default: "Europe/London", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
