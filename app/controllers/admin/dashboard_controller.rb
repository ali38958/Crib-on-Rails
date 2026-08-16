class Admin::DashboardController < Admin::BaseController
  def index
    # Chart Data: Last 7 days revenue and order count
    @days = (6.downto(0)).map { |i| i.days.ago.to_date }
    
    # Aggregation in Ruby to avoid SQL dialect issues
    orders_last_7_days = Order.where("created_at >= ?", 6.days.ago.beginning_of_day).to_a
    orders_by_date = orders_last_7_days.group_by { |o| o.created_at.to_date }

    @revenue_data = @days.map do |date| 
      orders_for_day = orders_by_date[date] || []
      [date.strftime("%a"), orders_for_day.sum { |o| o.total_price || 0 }]
    end.to_h

    @orders_data = @days.map do |date|
      orders_for_day = orders_by_date[date] || []
      [date.strftime("%a"), orders_for_day.size]
    end.to_h
  end
end