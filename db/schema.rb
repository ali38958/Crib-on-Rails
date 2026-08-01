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

ActiveRecord::Schema[8.1].define(version: 2026_08_01_140648) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", id: { type: :string, limit: 50 }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 50
    t.string "name", limit: 50, null: false
    t.string "password_digest", limit: 255
    t.string "phone", limit: 50
    t.integer "status", default: 1
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", limit: 50
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 50
    t.text "location"
    t.string "name", limit: 50
    t.string "phone", limit: 20
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id"
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.integer "product_id"
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id", unique: true
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_receivers", id: { type: :string, limit: 50 }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 50
    t.string "name", limit: 50, null: false
    t.string "password_digest", limit: 255
    t.string "phone", limit: 50
    t.integer "status", default: 1
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_order_receivers_on_email", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.integer "customer_id"
    t.decimal "price_paid", precision: 10, scale: 2
    t.integer "status", default: 0
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["created_by_id"], name: "index_orders_on_created_by_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["updated_by_id"], name: "index_orders_on_updated_by_id"
  end

  create_table "price_changes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "new_price", precision: 10, scale: 2, null: false
    t.decimal "old_price", precision: 10, scale: 2, null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_price_changes_on_created_at"
    t.index ["product_id", "created_at"], name: "index_price_changes_on_product_id_and_created_at"
    t.index ["product_id"], name: "index_price_changes_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.decimal "current_price", precision: 10, scale: 2, default: "0.0"
    t.string "image_url", limit: 100
    t.string "name", limit: 100
    t.integer "quantity", default: 0
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "product_id"
    t.integer "quantity", default: 0
    t.integer "status", default: 0
    t.integer "supplier_id"
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchases_on_product_id"
    t.index ["supplier_id", "product_id"], name: "index_purchases_on_supplier_id_and_product_id"
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
  end

  create_table "stock_managers", id: { type: :string, limit: 50 }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 50
    t.string "name", limit: 50, null: false
    t.string "password_digest", limit: 255
    t.string "phone", limit: 50
    t.integer "status", default: 1
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_stock_managers_on_email", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.text "address"
    t.string "contact_person"
    t.datetime "created_at", null: false
    t.string "email", limit: 50
    t.string "name", limit: 50
    t.string "phone", limit: 20
    t.integer "purchases_count", default: 0
    t.string "tax_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_suppliers_on_email", unique: true
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "price_changes", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "purchases", "products"
  add_foreign_key "purchases", "suppliers"
end
