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

ActiveRecord::Schema[7.1].define(version: 2024_07_17_124908) do
  create_table "catalog_hours", force: :cascade do |t|
    t.time "start_at"
    t.time "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services_hours", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "services_id"
    t.integer "catalog_hours_id"
    t.index ["catalog_hours_id"], name: "index_services_hours_on_catalog_hours_id"
    t.index ["services_id"], name: "index_services_hours_on_services_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "name"
    t.string "color"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_availabilities", force: :cascade do |t|
    t.integer "day"
    t.integer "week"
    t.integer "month"
    t.integer "year"
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_id"
    t.integer "services_id"
    t.integer "catalog_hours_id"
    t.index ["catalog_hours_id"], name: "index_users_availabilities_on_catalog_hours_id"
    t.index ["services_id"], name: "index_users_availabilities_on_services_id"
    t.index ["users_id"], name: "index_users_availabilities_on_users_id"
  end

  add_foreign_key "services_hours", "catalog_hours", column: "catalog_hours_id"
  add_foreign_key "services_hours", "services", column: "services_id"
  add_foreign_key "users_availabilities", "catalog_hours", column: "catalog_hours_id"
  add_foreign_key "users_availabilities", "services", column: "services_id"
  add_foreign_key "users_availabilities", "users", column: "users_id"
end
