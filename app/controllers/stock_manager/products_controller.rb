class StockManager::ProductsController < StockManager::BaseController
  before_action :set_product, only: [:edit, :update]
  
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @product = Product.new(product_params)
    
    if @product.save
      redirect_to stock_manager_products_path, notice: "Product created successfully"
    else
      render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def edit
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    if @product.update(product_params)
      redirect_to stock_manager_products_path, notice: "Product updated successfully"
    else
      render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false
    end
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def product_params
    params.require(:product).permit(:name, :category_id, :quantity, :current_price, :image)
  end
end