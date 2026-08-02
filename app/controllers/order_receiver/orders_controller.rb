class OrderReceiver::OrdersController < OrderReceiver::BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :update_status, :cancel, :update_price_paid]
  
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
    @order = Order.find(params[:id])
    @order.reload
    @status_changes = @order.status_changes.order(created_at: :desc)
    @can_update_status = !@order.completed?
  end
  
  def launch
    @order = Order.new
    @order.order_items.build
  end
  
  def create_order
    puts "===== FULL PARAMS ====="
    puts params.inspect
    puts "======================"
    
    @order = Order.new(order_params)
    @order.created_by = current_user
    
    if @order.save
      redirect_to order_receiver_orders_path, notice: "Order created successfully!"
    else
      puts @order.errors.full_messages.inspect
      render :launch, status: :unprocessable_entity
    end
  end
  
  def edit
    # Edit order - you can use launch partial or create a separate edit view
    render :edit
  end

  def update
    @order.updated_by = current_user
    
    if order_params[:status].present? && @order.status != order_params[:status].to_i
      unless @order.can_transition_to?(order_params[:status])
        redirect_to order_receiver_orders_path, alert: "Invalid status transition!"
        return
      end
    end
    
    if @order.update(order_params)
      redirect_to order_receiver_orders_path, notice: "Order updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    new_status = params[:status]

    if @order.completed?
      render json: { success: false, message: "Cannot update status of a completed order." }
      return
    end

    unless @order.can_transition_to?(new_status)
      render json: { success: false, message: "Invalid status transition." }
      return
    end

    old_status = @order.status.to_s
    @order.status = new_status
    @order.updated_by = current_user

    if @order.save
      @order.record_status_change(old_status, new_status.to_s, current_user)
      render json: { success: true, message: "Status updated to #{new_status.capitalize}!" }
    else
      render json: { success: false, message: "Failed to update status." }
    end
  end

  def cancel
    if @order.completed?
      render json: { success: false, message: "Cannot cancel a completed order." }
      return
    end

    if @order.status == 'cancelled'
      render json: { success: false, message: "Order is already cancelled." }
      return
    end

    old_status = @order.status.to_s
    @order.status = 'cancelled'
    @order.updated_by = current_user

    if @order.save
      @order.record_status_change(old_status, 'cancelled', current_user)
      render json: { success: true, message: "Order has been cancelled." }
    else
      render json: { success: false, message: "Failed to cancel order." }
    end
  end

  def update_price_paid
    new_price_paid = params[:price_paid].to_f
    current_price_paid = @order.price_paid || 0
    total_price = @order.total_price

    # Validation: price paid cannot decrease
    if new_price_paid < current_price_paid
      render json: { success: false, message: "Price paid cannot be decreased." }
      return
    end

    # Validation: price paid cannot exceed total price
    if new_price_paid > total_price
      render json: { success: false, message: "Price paid cannot exceed total price." }
      return
    end

    # Validation: price paid cannot be negative
    if new_price_paid < 0
      render json: { success: false, message: "Price paid cannot be negative." }
      return
    end

    @order.price_paid = new_price_paid
    @order.updated_by = current_user

    if @order.save
      render json: { success: true, message: "Price paid updated successfully!" }
    else
      render json: { success: false, message: "Failed to update price paid." }
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
                                  order_items_attributes: [:product_id, :quantity, :price_per_unit, :_destroy])
  end
end