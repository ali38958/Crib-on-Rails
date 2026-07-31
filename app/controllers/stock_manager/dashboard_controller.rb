class StockManager::DashboardController < StockManager::BaseController
  def index
    @total_products = Product.count
    @low_stock = Product.where("quantity < 10").count
    @out_of_stock = Product.where(quantity: 0).count
    @total_purchases = Purchase.count
    @recent_purchases = Purchase.order(created_at: :desc).limit(5)
  end
end