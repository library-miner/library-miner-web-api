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

ActiveRecord::Schema.define(version: 0) do

  create_table "project_dependencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=COMPACT COMMENT='プロジェクト依存関係'" do |t|
    t.integer  "project_from_id", null: false
    t.integer  "project_to_id"
    t.string   "library_name",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["project_from_id", "project_to_id"], name: "index_project_dependencies_on_project_from_id_project_to_id", using: :btree
    t.index ["project_from_id"], name: "index_project_dependencies_on_project_from_id", using: :btree
  end

  create_table "project_readmes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=COMPACT COMMENT='プロジェクト_README'" do |t|
    t.integer  "project_id",               null: false
    t.text     "content",    limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["project_id"], name: "project_readmes_project_id_fk", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=COMPACT COMMENT='プロジェクト基本情報'" do |t|
    t.boolean  "is_incomplete",                    default: true,  null: false
    t.integer  "github_item_id",     limit: 8
    t.string   "name",                                             null: false
    t.string   "full_name"
    t.integer  "owner_id",           limit: 8
    t.string   "owner_login_name",                 default: "",    null: false
    t.string   "owner_type",         limit: 30,    default: "",    null: false
    t.string   "github_url"
    t.boolean  "is_fork",                          default: false, null: false
    t.text     "github_description", limit: 65535
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.datetime "github_pushed_at"
    t.text     "homepage",           limit: 65535
    t.integer  "size",               limit: 8,     default: 0,     null: false
    t.integer  "stargazers_count",   limit: 8,     default: 0,     null: false
    t.integer  "watchers_count",     limit: 8,     default: 0,     null: false
    t.integer  "fork_count",         limit: 8,     default: 0,     null: false
    t.integer  "open_issue_count",   limit: 8,     default: 0,     null: false
    t.string   "github_score",                     default: "",    null: false
    t.string   "language",                         default: "",    null: false
    t.integer  "project_type_id",                  default: 0,     null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["full_name"], name: "index_projects_on_full_name", using: :btree
    t.index ["github_item_id"], name: "index_projects_on_github_item_id", unique: true, using: :btree
  end

  add_foreign_key "project_readmes", "projects", name: "project_readmes_project_id_fk"
end
