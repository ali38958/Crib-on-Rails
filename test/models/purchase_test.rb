require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  test "search matches purchases by supplier name or purchase id" do
    supplier = Supplier.create!(name: "Acme Supplies", phone: "123456", email: "acme@example.com")
    purchase = Purchase.create!(supplier: supplier, product: Product.create!(name: "Widget", price: 10.0), quantity: 2, total_price: 20.0)

    assert_includes Purchase.search("ACME"), purchase
    assert_includes Purchase.search(purchase.id.to_s), purchase
  end
end
