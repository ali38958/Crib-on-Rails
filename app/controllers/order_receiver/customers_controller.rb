class OrderReceiver::CustomersController < OrderReceiver::BaseController
  def index
    @customers = Customer.all
    
    # Search filter
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @customers = @customers.where(
        "LOWER(name) LIKE LOWER(?) OR LOWER(phone) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)",
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
    
    respond_to do |format|
      format.html { render :index }
      format.js { render partial: 'table', layout: false }
    end
  end
  
  def new
    @customer = Customer.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @customer = Customer.new(customer_params)
    
    if @customer.save
      respond_to do |format|
        format.html { redirect_to order_receiver_customers_path, notice: "Customer created successfully!" }
        format.json { render json: { success: true, message: "Customer created successfully!", customer: @customer } }
      end
    else
      respond_to do |format|
        format.html { render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false }
        format.json { render json: { success: false, message: @customer.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    @customer = Customer.find(params[:id])
    
    if @customer.update(customer_params)
      respond_to do |format|
        format.html { redirect_to order_receiver_customers_path, notice: "Customer updated successfully!" }
        format.json { render json: { success: true, message: "Customer updated successfully!", customer: @customer } }
      end
    else
      respond_to do |format|
        format.html { render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false }
        format.json { render json: { success: false, message: @customer.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
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