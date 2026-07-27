class StockManager::SuppliersController < StockManager::BaseController
  before_action :set_supplier, only: [:edit, :update, :destroy]
  
  def index
    # Parse URL params
    @view = params[:view] || 'suppliers'
    
    # Supplier params
    @supplier_page = (params[:supplier_page] || 1).to_i
    @supplier_limit = valid_limit(params[:supplier_limit])
    @supplier_search = params[:supplier_search] || ''
    
    # Purchase params
    @purchase_page = (params[:purchase_page] || 1).to_i
    @purchase_limit = valid_limit(params[:purchase_limit])
    @purchase_search = params[:purchase_search] || ''
    @purchase_date_from = params[:purchase_date_from] || ''
    @purchase_date_to = params[:purchase_date_to] || ''
    @purchase_product = params[:purchase_product] || ''
    
    # Suppliers query
    @suppliers = Supplier.search(@supplier_search)
    @suppliers = @suppliers.page(@supplier_page).per(@supplier_limit)
    
    # Purchases query
    @purchases = Purchase.includes(:supplier, :product).search(@purchase_search)
    
    # Date filter
    if @purchase_date_from.present? && @purchase_date_to.present?
      @purchases = @purchases.where(
        created_at: Date.parse(@purchase_date_from).beginning_of_day..Date.parse(@purchase_date_to).end_of_day
      )
    elsif @purchase_date_from.present?
      @purchases = @purchases.where("created_at >= ?", Date.parse(@purchase_date_from).beginning_of_day)
    elsif @purchase_date_to.present?
      @purchases = @purchases.where("created_at <= ?", Date.parse(@purchase_date_to).end_of_day)
    end
    
    # Product filter
    if @purchase_product.present?
      @purchases = @purchases.where(product_id: @purchase_product)
    end
    
    @purchases = @purchases.page(@purchase_page).per(@purchase_limit)
    
    # For dropdowns
    @all_suppliers = Supplier.all.order(:name)
    @all_products = Product.all.order(:name)
  end
  
  def new
    @supplier = Supplier.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @supplier = Supplier.new(supplier_params)
    
    if @supplier.save
      render json: { success: true, message: "Supplier created successfully!", supplier: @supplier }
    else
      render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def edit
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    if @supplier.update(supplier_params)
      render json: { success: true, message: "Supplier updated successfully!", supplier: @supplier }
    else
      render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def destroy
    @supplier.destroy
    redirect_to stock_manager_path(view: 'suppliers'), notice: "Supplier deleted successfully"
  end
  
  private
  
  def set_supplier
    @supplier = Supplier.find(params[:id])
  end
  
  def supplier_params
    params.require(:supplier).permit(:name, :contact_person, :phone, :email, :address)
  end
  
  def valid_limit(limit)
    limit = limit.to_i
    return 10 if limit < 1
    [10, 25, 50].min_by { |valid| (valid - limit).abs }
  end
end