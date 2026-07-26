class Admin::BaseController < ApplicationController
  before_action :authenticate_request
  before_action :require_admin
  
  def authenticate_request
    auth_token = cookies[:auth_token]
    
    if auth_token.nil?
      redirect_to login_path, alert: 'Please login'
      return
    end
    
    decoded = decode_token(auth_token, ENV['SECRET_KEY_BASE'])
    
    if decoded && decoded['type'] == 'auth' && decoded['role'] == 'Admin'
      @current_user = Admin.find(decoded['user_id'])
    else
      redirect_to login_path, alert: 'Unauthorized'
    end
  rescue
    redirect_to login_path, alert: 'Session expired'
  end
end