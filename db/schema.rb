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

ActiveRecord::Schema[7.0].define(version: 2023_09_13_072353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_tags", force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "tag_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_types", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.text "content"
    t.integer "author_id"
    t.integer "user_id"
    t.integer "article_type_id"
    t.integer "context_id"
    t.string "hindi_title"
    t.string "english_title"
    t.string "video_link"
    t.text "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_approved"
    t.integer "scripture_id"
    t.text "content_eng"
    t.text "interpretation_eng"
    t.integer "index"
    t.integer "raag_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "sampradaya_id"
    t.text "biography"
    t.date "birth_date"
    t.date "death_date"
    t.boolean "is_approved"
    t.integer "user_id"
    t.boolean "is_saint", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_eng"
  end

  create_table "chapters", force: :cascade do |t|
    t.integer "scripture_id"
    t.string "name"
    t.integer "parent_id"
    t.boolean "is_section", default: false
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_reportings", force: :cascade do |t|
    t.text "report_msg"
    t.integer "article_id"
    t.integer "comment_id"
    t.integer "user_id"
    t.boolean "is_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.integer "depth", default: 0
    t.boolean "is_blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "contexts", force: :cascade do |t|
    t.string "name"
    t.boolean "is_approved", default: false
    t.integer "user_id"
    t.integer "theme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contributed_articles", force: :cascade do |t|
    t.string "contributor"
    t.integer "mobile"
    t.text "content"
    t.text "interpretation"
    t.string "article_type_id"
    t.integer "raag_id"
    t.string "author_id"
    t.integer "user_id"
    t.integer "context_id"
    t.string "hindi_title"
    t.string "english_title"
    t.string "video_link"
    t.integer "scripture_id"
    t.string "source_book"
    t.integer "article_index"
    t.boolean "is_read", default: false
    t.boolean "is_hold", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cs_articles", force: :cascade do |t|
    t.integer "scripture_id"
    t.integer "chapter_id"
    t.integer "article_id"
    t.integer "user_id"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hindi_months", force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.boolean "is_purshottam_month"
    t.integer "panchang_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "image"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable"
  end

  create_table "panchang_tithis", force: :cascade do |t|
    t.date "date"
    t.integer "tithi"
    t.string "paksh"
    t.text "description"
    t.string "title"
    t.integer "year"
    t.integer "panchang_id"
    t.integer "hindi_month_id"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panchangs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "panchang_type"
    t.integer "vikram_samvat"
    t.boolean "is_tithi_populated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "raags", force: :cascade do |t|
    t.string "name"
    t.string "name_eng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sampradayas", force: :cascade do |t|
    t.string "name"
    t.string "originator"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scripture_articles", force: :cascade do |t|
    t.integer "scripture_id"
    t.integer "chapter_id"
    t.integer "article_type_id"
    t.text "content"
    t.text "content_eng"
    t.text "interpretation"
    t.text "interpretation_eng"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scripture_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scriptures", force: :cascade do |t|
    t.integer "scripture_type_id"
    t.integer "user_id"
    t.string "name"
    t.string "name_eng"
    t.text "description"
    t.integer "author_id"
    t.string "keywords"
    t.integer "sampradaya_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.integer "scripture_id"
    t.string "title"
    t.text "story"
    t.integer "author_id"
    t.integer "index"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strota", force: :cascade do |t|
    t.string "title"
    t.text "source"
    t.integer "strota_type_id"
    t.string "keyword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strota_articles", force: :cascade do |t|
    t.integer "strotum_id"
    t.integer "index"
    t.text "content"
    t.text "interpretation"
    t.integer "article_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strota_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.string "email"
    t.string "username"
    t.boolean "is_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.boolean "is_approved", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theme_articles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "theme_id"
    t.integer "theme_chapter_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theme_chapters", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "theme_id"
    t.boolean "is_default", default: true
    t.integer "display_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "biography"
    t.string "mobile"
    t.text "address"
    t.string "city"
    t.string "pincode"
    t.integer "state_id"
    t.date "date_of_birth"
    t.string "facebook_url"
    t.string "youtube_url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username"
    t.integer "role_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_blocked", default: false
    t.string "jti"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
