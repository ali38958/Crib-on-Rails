class StockManager::ProductsController < StockManager::BaseController
  before_action :set_product, only: [:edit, :update]
  
  def index
    @products = Product.includes(:category).all

    @total_products = Product.count
    @low_stock = Product.where("quantity < 10 AND quantity > 0").count
    @out_of_stock = Product.where(quantity: 0).count
    @total_purchases = Purchase.count
    @recent_purchases = Purchase.includes(:product, :supplier).order(created_at: :desc).limit(5)

    if params[:filter] == 'low'
      @products = @products.low_stock
      @filter_label = 'Low Stock'
    elsif params[:filter] == 'out'
      @products = @products.out_of_stock
      @filter_label = 'Out of Stock'
    elsif params[:filter] == 'in'
      @products = @products.in_stock
      @filter_label = 'In Stock'
    else
      @filter_label = 'All Products'
    end

    if params[:search].present?
      @products = @products.search(params[:search])
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    @categories = Category.all

    per_page = params[:per_page].to_i
    per_page = 50 if per_page > 50
    per_page = 10 if per_page < 1
    per_page = 10 if per_page.blank?

    @products = @products.page(params[:page]).per(per_page)
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