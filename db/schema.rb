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

ActiveRecord::Schema[8.1].define(version: 2026_01_18_020144) do
  create_table "categories", force: :cascade do |t|
    t.integer "components_count", default: 0
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.integer "parent_id"
    t.integer "position", default: 0
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "commercial_licenses", force: :cascade do |t|
    t.integer "component_id", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "license_key", null: false
    t.integer "organization_id", null: false
    t.integer "price_cents", null: false
    t.integer "seats", default: 1
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_commercial_licenses_on_component_id"
    t.index ["license_key"], name: "index_commercial_licenses_on_license_key", unique: true
    t.index ["organization_id"], name: "index_commercial_licenses_on_organization_id"
    t.index ["status"], name: "index_commercial_licenses_on_status"
  end

  create_table "component_versions", force: :cascade do |t|
    t.text "changelog"
    t.string "checksum"
    t.integer "component_id", null: false
    t.datetime "created_at", null: false
    t.integer "downloads_count", default: 0
    t.string "min_rails_version"
    t.string "min_ruby_version"
    t.string "package_url"
    t.datetime "published_at"
    t.text "release_notes"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "version", null: false
    t.index ["component_id", "version"], name: "index_component_versions_on_component_id_and_version", unique: true
    t.index ["component_id"], name: "index_component_versions_on_component_id"
    t.index ["status"], name: "index_component_versions_on_status"
  end

  create_table "components", force: :cascade do |t|
    t.integer "category_id"
    t.integer "commercial_price_cents"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "developer_id", null: false
    t.string "documentation_url"
    t.integer "downloads_count", default: 0
    t.boolean "featured", default: false
    t.integer "license_type", default: 0, null: false
    t.string "name", null: false
    t.datetime "published_at"
    t.text "readme"
    t.string "repository_url"
    t.string "slug", null: false
    t.integer "stars_count", default: 0
    t.integer "status", default: 0, null: false
    t.string "tagline"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_components_on_category_id"
    t.index ["developer_id"], name: "index_components_on_developer_id"
    t.index ["featured"], name: "index_components_on_featured"
    t.index ["published_at"], name: "index_components_on_published_at"
    t.index ["slug"], name: "index_components_on_slug", unique: true
    t.index ["status"], name: "index_components_on_status"
  end

  create_table "downloads", force: :cascade do |t|
    t.integer "component_version_id", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.integer "organization_id"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id"
    t.index ["component_version_id"], name: "index_downloads_on_component_version_id"
    t.index ["created_at"], name: "index_downloads_on_created_at"
    t.index ["organization_id"], name: "index_downloads_on_organization_id"
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "organization_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["organization_id", "user_id"], name: "index_organization_memberships_on_organization_id_and_user_id", unique: true
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
    t.index ["user_id"], name: "index_organization_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "billing_email"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "logo_url"
    t.string "name", null: false
    t.string "slug", null: false
    t.string "stripe_customer_id"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["stripe_customer_id"], name: "index_organizations_on_stripe_customer_id", unique: true
  end

  create_table "payouts", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.integer "developer_id", null: false
    t.datetime "paid_at"
    t.date "period_end", null: false
    t.date "period_start", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_payout_id"
    t.datetime "updated_at", null: false
    t.index ["developer_id"], name: "index_payouts_on_developer_id"
    t.index ["status"], name: "index_payouts_on_status"
    t.index ["stripe_payout_id"], name: "index_payouts_on_stripe_payout_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body"
    t.integer "component_id", null: false
    t.datetime "created_at", null: false
    t.integer "helpful_count", default: 0
    t.integer "rating", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["component_id", "user_id"], name: "index_reviews_on_component_id_and_user_id", unique: true
    t.index ["component_id"], name: "index_reviews_on_component_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.integer "organization_id", null: false
    t.integer "plan", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_subscription_id"
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.integer "commercial_license_id"
    t.datetime "created_at", null: false
    t.string "currency", default: "usd", null: false
    t.integer "developer_payout_cents"
    t.integer "organization_id", null: false
    t.integer "platform_fee_cents"
    t.integer "status", default: 0, null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_transfer_id"
    t.integer "subscription_id"
    t.integer "transaction_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_license_id"], name: "index_transactions_on_commercial_license_id"
    t.index ["organization_id"], name: "index_transactions_on_organization_id"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["stripe_payment_intent_id"], name: "index_transactions_on_stripe_payment_intent_id"
    t.index ["subscription_id"], name: "index_transactions_on_subscription_id"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.datetime "email_verified_at"
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "github_username"
    t.string "last_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.string "stripe_account_id"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_username"], name: "index_users_on_github_username", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "commercial_licenses", "components"
  add_foreign_key "commercial_licenses", "organizations"
  add_foreign_key "component_versions", "components"
  add_foreign_key "components", "categories"
  add_foreign_key "components", "users", column: "developer_id"
  add_foreign_key "downloads", "component_versions"
  add_foreign_key "downloads", "organizations"
  add_foreign_key "downloads", "users"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users"
  add_foreign_key "payouts", "users", column: "developer_id"
  add_foreign_key "reviews", "components"
  add_foreign_key "reviews", "users"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "transactions", "commercial_licenses"
  add_foreign_key "transactions", "organizations"
  add_foreign_key "transactions", "subscriptions"
end
