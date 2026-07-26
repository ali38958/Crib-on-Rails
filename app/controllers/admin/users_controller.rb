class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  
  def index
    @admins = Admin.all
    @stock_managers = StockManager.all
    @order_receivers = OrderReceiver.all
  end
  
  def new
    @role = params[:role]
    @user = @role.constantize.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def edit
    @role = params[:role]
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def create
    @role = params[:role]
    @user = @role.constantize.new(user_params)
    
    if @user.save
      redirect_to admin_users_path, notice: "#{@role} created successfully"
    else
      puts "ERRORS: #{@user.errors.full_messages}"  # Debug
      render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def update
    @role = params[:role]
    
    # Don't allow admin to change their own status
    if @user.id == current_user.id && params[:user][:status].present?
      redirect_to admin_users_path, alert: "You cannot change your own status"
      return
    end
    
    # Remove password fields if blank
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully"
    else
      render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def destroy
    @role = params[:role]
    
    # Don't allow admin to delete themselves
    if @user.id == current_user.id
      redirect_to admin_users_path, alert: "You cannot delete yourself"
      return
    end
    
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully"
  end
  
  private
  
  def set_user
    @user = params[:role].constantize.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:id, :name, :phone, :email, :password, :password_confirmation, :status)
  end
end