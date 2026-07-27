class StockManager::PurchasesController < StockManager::BaseController
  before_action :set_purchase, only: [:edit, :update, :destroy]
  
  # def index
  #   @purchases = Purchase.includes(:supplier, :product).order(created_at: :desc)
  #   @purchases = @purchases.page(params[:page]).per(10)
  # end
  
  def new
    @purchase = Purchase.new
    @supplier_id = params[:supplier_id]
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @purchase = Purchase.new(purchase_params)
    
    if @purchase.save
      render json: { 
        success: true, 
        message: "Purchase created successfully!", 
        purchase: @purchase 
      }
    else
      render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def edit
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    if @purchase.update(purchase_params)
      render json: { success: true, message: "Purchase updated successfully!" }
    else
      render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def destroy
    @purchase.destroy
    redirect_to stock_manager_purchases_path, notice: "Purchase deleted"
  end
  
  private
  
  def set_purchase
    @purchase = Purchase.find(params[:id])
  end
  
  def purchase_params
    params.require(:purchase).permit(:supplier_id, :product_id, :quantity, :total_price, :status, :notes)
  end
end