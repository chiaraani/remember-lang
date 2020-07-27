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

ActiveRecord::Schema.define(version: 2020_07_27_152945) do

  create_table "defined_definers", id: false, force: :cascade do |t|
    t.integer "defined_id", null: false
    t.integer "definer_id", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.date "scheduled_for", null: false
    t.boolean "passed"
    t.integer "word_id", null: false
    t.datetime "performed_at"
    t.datetime "created_at", null: false
    t.index ["word_id"], name: "index_reviews_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "spelling", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spelling"], name: "index_words_on_spelling", unique: true
  end

end
