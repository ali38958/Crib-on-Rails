require "test_helper"
require "jwt"

class OrderReceiver::CustomersControllerTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  setup do
    ENV["SECRET_KEY_BASE"] ||= "test_secret"
    @order_receiver = OrderReceiver.create!(name: "Test Receiver", email: "receiver@example.com", password: "password123", status: :active)
    @auth_token = JWT.encode({ user_id: @order_receiver.id, role: "OrderReceiver", type: "auth" }, ENV["SECRET_KEY_BASE"], "HS256")
  end

  test "create redirects to the customers index with a notice" do
    post order_receiver_customers_path,
      params: { customer: { name: "New Customer", phone: "1234567890", email: "new@example.com", location: "Nairobi" } },
      headers: { "HTTP_COOKIE" => "auth_token=#{@auth_token}" }

    assert_redirected_to order_receiver_customers_path
    assert_equal "Customer created successfully!", flash[:notice]
  end

  test "update redirects to the customers index with a notice" do
    customer = Customer.create!(name: "Existing Customer", phone: "0987654321", email: "existing@example.com")

    patch order_receiver_customer_path(customer),
      params: { customer: { name: "Updated Customer", phone: "1111111111", email: "updated@example.com" } },
      headers: { "HTTP_COOKIE" => "auth_token=#{@auth_token}" }

    assert_redirected_to order_receiver_customers_path
    assert_equal "Customer updated successfully!", flash[:notice]
  end
end
