class OrderReceiver::CustomersController < OrderReceiver::BaseController
  def index
    @customers = Customer.all
    
    # Search filter
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @customers = @customers.where(
        "name ILIKE ? OR phone ILIKE ? OR email ILIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Pagination
    per_page = params[:per_page].to_i
    per_page = 50 if per_page > 50
    per_page = 10 if per_page < 1
    per_page = 10 if per_page.blank?
    
    @customers = @customers.page(params[:page]).per(per_page)
    @total_count = @customers.total_count
  end
  
  def new
    @customer = Customer.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render json: { success: true, message: "Customer created successfully!", type: "success", customer: @customer }
    else
      render json: {
        success: false,
        message: @customer.errors.full_messages.join(', '),
        type: "error"
      }, status: :unprocessable_entity
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    @customer = Customer.find(params[:id])

    if @customer.update(customer_params)
      render json: { success: true, message: "Customer updated successfully!", type: "success", customer: @customer }
    else
      render json: {
        success: false,
        message: @customer.errors.full_messages.join(', '),
        type: "error"
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to order_receiver_customers_path, notice: "Customer deleted successfully"
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:name, :phone, :email, :location)
  end
end