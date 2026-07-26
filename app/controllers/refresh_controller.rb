class RefreshController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    refresh_token = cookies[:refresh_token]
    
    if refresh_token.nil?
      render json: { error: 'No refresh token' }, status: :unauthorized
      return
    end
    
    decoded = decode_token(refresh_token, ENV['REFRESH_KEY_BASE'])
    
    if decoded && decoded['type'] == 'refresh'
      # Find user across all three models
      user = Admin.find_by(id: decoded['user_id']) ||
             StockManager.find_by(id: decoded['user_id']) ||
             OrderReceiver.find_by(id: decoded['user_id'])
      
      if user
        new_auth_token = generate_auth_token(user)
        
        cookies[:auth_token] = {
          value: new_auth_token,
          httponly: true,
          expires: ENV['AUTH_TOKEN_LIFE'].to_i.seconds.from_now
        }
        
        render json: { success: true, message: 'Token refreshed' }
      else
        render json: { error: 'User not found' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid refresh token' }, status: :unauthorized
    end
  end
end