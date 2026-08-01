class OrderReceiver::OrdersController < OrderReceiver::BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  
  def index
    @orders = Order.includes(:customer, :created_by).all
    
    # Search filter
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @orders = @orders.joins(:customer).where(
        "orders.id::text LIKE ? OR customers.name LIKE ? OR customers.phone LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Status filter
    if params[:status].present? && params[:status] != 'all'
      @orders = @orders.where(status: params[:status])
    end
    
    # Date range filter
    if params[:date_from].present?
      @orders = @orders.where("orders.created_at >= ?", Date.parse(params[:date_from]).beginning_of_day)
    end
    if params[:date_to].present?
      @orders = @orders.where("orders.created_at <= ?", Date.parse(params[:date_to]).end_of_day)
    end
    
    # Pagination
    per_page = params[:per_page].to_i
    per_page = 50 if per_page > 50
    per_page = 10 if per_page < 1
    per_page = 10 if per_page.blank?
    
    @orders = @orders.order(created_at: :desc).page(params[:page]).per(per_page)
    @total_count = @orders.total_count
  end
  
  def show
    render partial: 'show', layout: false if request.xhr?
  end
  
  def new
    @order = Order.new
    @order.order_items.build
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @order = Order.new(order_params)
    @order.created_by = current_user
    
    if @order.save
      respond_to do |format|
        format.html { redirect_to order_receiver_orders_path, notice: "Order created successfully!" }
        format.json { render json: { success: true, message: "Order created successfully!", order: @order } }
      end
    else
      respond_to do |format|
        format.html { render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false }
        format.json { render json: { success: false, message: @order.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    @order.updated_by = current_user
    
    # Check status transition rules
    if order_params[:status].present? && @order.status != order_params[:status].to_i
      unless @order.can_transition_to?(order_params[:status])
        respond_to do |format|
          format.html { redirect_to order_receiver_orders_path, alert: "Invalid status transition!" }
          format.json { render json: { success: false, message: "Invalid status transition!" }, status: :unprocessable_entity }
        end
        return
      end
    end
    
    if @order.update(order_params)
      respond_to do |format|
        format.html { redirect_to order_receiver_orders_path, notice: "Order updated successfully!" }
        format.json { render json: { success: true, message: "Order updated successfully!", order: @order } }
      end
    else
      respond_to do |format|
        format.html { render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false }
        format.json { render json: { success: false, message: @order.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @order.destroy
    redirect_to order_receiver_orders_path, notice: "Order deleted successfully"
  end
  
  private
  
  def set_order
    @order = Order.find(params[:id])
  end
  
  def order_params
    params.require(:order).permit(:customer_id, :status, :total_price, :price_paid, :location, 
                                  order_items_attributes: [:id, :product_id, :quantity, :price_per_unit, :_destroy])
  end
end