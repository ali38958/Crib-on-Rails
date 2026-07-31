require "test_helper"

class SupplierTest < ActiveSupport::TestCase
  test "search matches case-insensitively by name, phone, email, or contact person" do
    supplier = Supplier.create!(name: "Acme Supplies", phone: "123456", email: "acme@example.com", contact_person: "Jane Doe")

    assert_includes Supplier.search("ACME"), supplier
    assert_includes Supplier.search("jane"), supplier
    assert_includes Supplier.search("EXAMPLE"), supplier
    assert_includes Supplier.search("123"), supplier
  end
end
