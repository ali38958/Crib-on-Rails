class LoginController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :redirect_if_logged_in, only: [:index]
  
  def index
  end
  
  def forgot_password
  end
  
  def create
    identifier = params[:identifier]
    password = params[:password]
    
    # Check OrderReceiver first
    user = OrderReceiver.find_by(email: identifier) || OrderReceiver.find_by(id: identifier)
    
    # If not found, check StockManager
    if user.nil?
      user = StockManager.find_by(email: identifier) || StockManager.find_by(id: identifier)
    end
    
    # If not found, check Admin
    if user.nil?
      user = Admin.find_by(email: identifier) || Admin.find_by(id: identifier)
    end
    
    # Authenticate
    if user && user.authenticate(password)
      # Check if user is active
      unless user.active?
        render json: { success: false, message: "Account disabled" }, status: :unauthorized
        return
      end
      
      # Create auth token
      auth_payload = {
        user_id: user.id,
        email: user.email,
        role: user.class.name,
        type: 'auth'
      }
      
      auth_token = JWT.encode(auth_payload, ENV['SECRET_KEY_BASE'], 'HS256')
      
      # Create refresh token
      refresh_payload = {
        user_id: user.id,
        type: 'refresh'
      }
      
      refresh_token = JWT.encode(refresh_payload, ENV['REFRESH_KEY_BASE'], 'HS256')
      
      # Store both in cookies
      cookies[:auth_token] = {
        value: auth_token,
        httponly: true,
        expires: ENV['AUTH_TOKEN_LIFE'].to_i.seconds.from_now,
        path: '/'
      }
      
      cookies[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        expires: ENV['REFRESH_TOKEN_LIFE'].to_i.seconds.from_now,
        path: '/'
      }
      
      # Return the redirect URL as JSON so the frontend can show a notification before redirecting
      render json: { success: true, redirect: "/#{user.class.name.underscore}" } and return
    else
      render json: { success: false, message: "Login failed" }, status: :unauthorized
    end
  end
end