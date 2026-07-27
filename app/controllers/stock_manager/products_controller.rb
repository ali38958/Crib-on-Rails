class StockManager::ProductsController < StockManager::BaseController
  before_action :set_product, only: [:edit, :update]
  
  def index
    # Start with base query
    @products = Product.includes(:category).order(created_at: :desc)
    
    # Search filter - uses LIKE (SQLite's LIKE is case-insensitive by default for ASCII)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @products = @products.where(
        "products.name LIKE ? OR categories.name LIKE ?", 
        search_term, 
        search_term
      ).references(:categories)
    end
    
    # Category filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
    
    # Get all categories for filter dropdown
    @categories = Category.all
    
    # Pagination - smart limit
    per_page = params[:per_page].to_i
    per_page = 50 if per_page > 50   # Max 50
    per_page = 10 if per_page < 1    # Min 10
    per_page = 10 if per_page.blank? # Default 10
    
    # This only loads the current page, not all records
    @products = @products.page(params[:page]).per(per_page)
    
    # Count total matching records (efficient COUNT query)
    @total_count = @products.total_count
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