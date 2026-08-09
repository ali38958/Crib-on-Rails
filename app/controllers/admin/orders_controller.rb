require 'csv'

class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes(:customer, :created_by).all

    # Date range filter
    if params[:date_from].present?
      @orders = @orders.where("orders.created_at >= ?", Date.parse(params[:date_from]).beginning_of_day)
    end
    if params[:date_to].present?
      @orders = @orders.where("orders.created_at <= ?", Date.parse(params[:date_to]).end_of_day)
    end

    # Status filter
    if params[:status].present? && params[:status] != 'all'
      @orders = @orders.where(status: params[:status])
    end

    # Customer filter
    if params[:customer_id].present?
      @orders = @orders.where(customer_id: params[:customer_id])
    end

    # Pagination
    per_page = params[:per_page].to_i
    per_page = 100 if per_page > 100
    per_page = 10 if per_page < 1
    per_page = 10 if per_page.blank?

    @orders = @orders.order(created_at: :desc).page(params[:page]).per(per_page)
    @total_count = @orders.total_count

    # Summary stats
    @total_orders = Order.count
    @total_revenue = Order.sum(:total_price)
    @avg_order_value = @total_orders > 0 ? (@total_revenue / @total_orders) : 0

    # Chart data: Orders by status
    @status_data = {
      labels: ['Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled'],
      data: [
        Order.where(status: 'pending').count,
        Order.where(status: 'confirmed').count,
        Order.where(status: 'processing').count,
        Order.where(status: 'shipped').count,
        Order.where(status: 'delivered').count,
        Order.where(status: 'cancelled').count
      ]
    }

    # Chart data: Revenue trend (last 7 days)
    @trend_data = []
    (6).downto(0).each do |i|
      date = Date.today - i
      total = Order.where(created_at: date.beginning_of_day..date.end_of_day).sum(:total_price)
      @trend_data << { date: date.strftime("%b %d"), amount: total }
    end

    @customers = Customer.all.order(:name)
  end

  def export_csv
    @orders = Order.includes(:customer).all
    # Apply same filters as index
    if params[:date_from].present?
      @orders = @orders.where("orders.created_at >= ?", Date.parse(params[:date_from]).beginning_of_day)
    end
    if params[:date_to].present?
      @orders = @orders.where("orders.created_at <= ?", Date.parse(params[:date_to]).end_of_day)
    end
    if params[:status].present? && params[:status] != 'all'
      @orders = @orders.where(status: params[:status])
    end

    send_data generate_csv(@orders), filename: "orders_#{Date.today}.csv"
  end


  private

  def generate_csv(orders)
    CSV.generate(headers: true) do |csv|
      csv << ["Order ID", "Customer", "Items", "Total", "Status", "Date"]

      orders.each do |order|
        csv << [
          order.id,
          order.customer&.name || 'N/A',
          order.order_items.count,
          order.total_price,
          order.status.capitalize,
          order.created_at.strftime("%b %d, %Y")
        ]
      end
    end
  end
end