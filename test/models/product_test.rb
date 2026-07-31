require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "search matches product names and category names case-insensitively" do
    category = Category.create!(name: "Furniture")
    product = Product.create!(name: "The House in the Woods", category: category, quantity: 5, current_price: 10.0)

    assert_includes Product.search("house"), product
    assert_includes Product.search("furniture"), product
  end
end
