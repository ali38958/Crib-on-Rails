class StockManager::PurchasesController < StockManager::BaseController
  def index
    @purchases = Purchase.order(created_at: :desc)
  end
  
  def new
    @purchase = Purchase.new
  end
  
  def create
    @purchase = Purchase.new(purchase_params)
    if @purchase.save
      # Update product quantity
      product = Product.find(@purchase.product_id)
      product.update(quantity: product.quantity + @purchase.quantity)
      
      redirect_to stock_manager_purchases_path, notice: "Purchase created successfully"
    else
      render :new
    end
  end
  
  private
  
  def purchase_params
    params.require(:purchase).permit(:supplier_id, :product_id, :quantity, :total_price)
  end
end