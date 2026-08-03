class OrderReceiver::DashboardController < OrderReceiver::BaseController
  def index
    # Stats
    @total_orders = Order.count
    @pending_orders = Order.where(status: 'pending').count
    @confirmed_orders = Order.where(status: 'confirmed').count
    @processing_orders = Order.where(status: 'processing').count
    @delivered_orders = Order.where(status: 'delivered').count
    @total_customers = Customer.count
    
    # Recent orders sorted by status priority
    # Use Arel.sql() to wrap raw SQL
    status_order_sql = Arel.sql("
      CASE status 
        WHEN 'pending' THEN 1
        WHEN 'confirmed' THEN 2
        WHEN 'processing' THEN 3
        WHEN 'shipped' THEN 4
        WHEN 'delivered' THEN 5
        WHEN 'cancelled' THEN 6
        ELSE 7 
      END, created_at DESC
    ")
    
    @recent_orders = Order.includes(:customer)
                          .order(status_order_sql)
                          .limit(10)
    
    # Chart data: Order status distribution
    @status_counts = {
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
    
    # Chart data: Last 7 days order trend
    @trend_data = []
    (6).downto(0).each do |i|
      date = Date.today - i
      count = Order.where(created_at: date.beginning_of_day..date.end_of_day).count
      @trend_data << { date: date.strftime("%b %d"), count: count }
    end
  end
end