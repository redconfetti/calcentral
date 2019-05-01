# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190422180339) do

  create_table "canvas_site_mailing_list_members", force: :cascade do |t|
    t.integer  "mailing_list_id",                             null: false
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "email_address",   limit: 255,                 null: false
    t.boolean  "can_send",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "canvas_site_mailing_list_members", ["mailing_list_id", "email_address"], name: "mailing_list_membership_index", unique: true

  create_table "canvas_site_mailing_lists", force: :cascade do |t|
    t.string   "canvas_site_id",         limit: 255
    t.string   "canvas_site_name",       limit: 255
    t.string   "list_name",              limit: 255
    t.string   "state",                  limit: 255
    t.datetime "populated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "members_count"
    t.integer  "populate_add_errors"
    t.integer  "populate_remove_errors"
    t.string   "type",                   limit: 255
  end

  add_index "canvas_site_mailing_lists", ["canvas_site_id"], name: "index_canvas_site_mailing_lists_on_canvas_site_id", unique: true

  create_table "canvas_synchronization", force: :cascade do |t|
    t.datetime "last_guest_user_sync"
    t.datetime "latest_term_enrollment_csv_set"
  end

  create_table "link_categories", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.string   "slug",       limit: 255,                 null: false
    t.boolean  "root_level",             default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "link_categories_link_sections", id: false, force: :cascade do |t|
    t.integer "link_category_id"
    t.integer "link_section_id"
  end

  create_table "link_sections", force: :cascade do |t|
    t.integer  "link_root_cat_id"
    t.integer  "link_top_cat_id"
    t.integer  "link_sub_cat_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "link_sections_links", id: false, force: :cascade do |t|
    t.integer "link_section_id"
    t.integer "link_id"
  end

  create_table "links", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "url",         limit: 255
    t.string   "description", limit: 255
    t.boolean  "published",               default: true
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "links_user_roles", id: false, force: :cascade do |t|
    t.integer "link_id"
    t.integer "user_role_id"
  end

  create_table "oec_course_codes", force: :cascade do |t|
    t.string   "dept_name",      limit: 255, null: false
    t.string   "catalog_id",     limit: 255, null: false
    t.string   "dept_code",      limit: 255, null: false
    t.boolean  "include_in_oec",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oec_course_codes", ["dept_code"], name: "index_oec_course_codes_on_dept_code"
  add_index "oec_course_codes", ["dept_name", "catalog_id"], name: "index_oec_course_codes_on_dept_name_and_catalog_id", unique: true

  create_table "ps_uc_clc_oauth", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string  "uc_clc_ldap_uid", limit: 255
    t.string  "uc_clc_app_id",   limit: 255
    t.text    "access_token"
    t.text    "refresh_token"
    t.integer "uc_clc_expire",   limit: 8
    t.text    "app_data"
  end

  add_index "ps_uc_clc_oauth", ["uc_clc_ldap_uid", "uc_clc_app_id"], name: "index_ps_uc_clc_oauth_on_uid_app_id", unique: true

  create_table "ps_uc_clc_srvalert", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string   "uc_alrt_title",   limit: 255,                 null: false
    t.text     "uc_alrt_snippt"
    t.text     "uc_alrt_body",                                null: false
    t.datetime "uc_alrt_pubdt",                               null: false
    t.boolean  "uc_alrt_display",             default: false, null: false
    t.boolean  "uc_alrt_splash",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ps_uc_clc_srvalert", ["uc_alrt_display", "created_at"], name: "index_Pps_uc_clc_srvalert_on_display_and_created_at"

  create_table "ps_uc_recent_uids", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string   "uc_clc_oid",     limit: 255
    t.string   "uc_clc_stor_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ps_uc_recent_uids", ["uc_clc_oid"], name: "ps_uc_recent_uids_index"

  create_table "ps_uc_saved_uids", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string   "uc_clc_oid",     limit: 255
    t.string   "uc_clc_stor_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ps_uc_saved_uids", ["uc_clc_oid"], name: "ps_uc_saved_uids_index"

  create_table "ps_uc_user_auths", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string   "uc_clc_ldap_uid", limit: 255,                 null: false
    t.boolean  "uc_clc_is_su",                default: false, null: false
    t.boolean  "uc_clc_active",               default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "uc_clc_is_au",                default: false, null: false
    t.boolean  "uc_clc_is_vw",                default: false, null: false
  end

  add_index "ps_uc_user_auths", ["uc_clc_ldap_uid"], name: "index_ps_uc_user_auths_on_uid", unique: true

  create_table "ps_uc_user_data", primary_key: "uc_clc_id", force: :cascade do |t|
    t.string   "uc_clc_ldap_uid", limit: 255
    t.string   "uc_clc_prefnm",   limit: 255
    t.datetime "uc_clc_fst_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "ps_uc_user_data", ["uc_clc_ldap_uid"], name: "index_ps_uc_user_data_on_uid", unique: true

  create_table "schema_migrations_backup", id: false, force: :cascade do |t|
    t.string "version", limit: 255
  end

  create_table "schema_migrations_fixed_backup", id: false, force: :cascade do |t|
    t.string "version", limit: 255
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "slug", limit: 255
  end

  create_table "webcast_course_site_log", force: :cascade do |t|
    t.integer  "canvas_course_site_id",    null: false
    t.datetime "webcast_tool_unhidden_at", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "webcast_course_site_log", ["canvas_course_site_id"], name: "webcast_course_site_log_unique_index", unique: true

end
