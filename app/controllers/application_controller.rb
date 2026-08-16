class ApplicationController < ActionController::Base
  include AuthHelper
  allow_browser versions: :modern
  stale_when_importmap_changes
  
  helper_method :current_user, :logged_in?, :current_role
  
  def current_user
    return @current_user if defined?(@current_user)

    if cookies[:auth_token]
      decoded = decode_token(cookies[:auth_token], ENV['SECRET_KEY_BASE'])
      if decoded && decoded['type'] == 'auth'
        @current_user = decoded['role'].constantize.find_by(id: decoded['user_id']) rescue nil
        return @current_user if @current_user
      end
    end

    if cookies[:refresh_token]
      decoded_refresh = decode_token(cookies[:refresh_token], ENV['REFRESH_KEY_BASE'])
      if decoded_refresh && decoded_refresh['type'] == 'refresh'
        user = Admin.find_by(id: decoded_refresh['user_id']) ||
               StockManager.find_by(id: decoded_refresh['user_id']) ||
               OrderReceiver.find_by(id: decoded_refresh['user_id'])
        if user
          new_auth_token = generate_auth_token(user)
          cookies[:auth_token] = {
            value: new_auth_token,
            httponly: true,
            expires: ENV['AUTH_TOKEN_LIFE'].to_i.seconds.from_now
          }
          @current_user = user
          return @current_user
        end
      end
    end

    nil
  rescue
    nil
  end
  
  def logged_in?
    current_user.present?
  end
  
  def current_role
    current_user&.class&.name
  end
  
  def authenticate_request
    unless logged_in?
      is_fetch = request.format.json? || 
                 request.headers['Sec-Fetch-Dest'] == 'empty' || 
                 request.xhr? || 
                 (request.headers['Accept'] && request.headers['Accept'].match?(/turbo/i))

      if is_fetch
        render json: { error: 'Unauthorized' }, status: :unauthorized
      else
        redirect_to login_path, alert: 'Please login first'
      end
    end
  end
  
  def redirect_if_logged_in
    if logged_in?
      redirect_to role_specific_path(current_role)
    end
  end
  
  def require_admin
    redirect_to dashboard_path, alert: 'Unauthorized' unless current_role == 'Admin'
  end
  
  def require_stock_manager
    redirect_to dashboard_path, alert: 'Unauthorized' unless current_role == 'StockManager'
  end
  
  def require_order_receiver
    redirect_to dashboard_path, alert: 'Unauthorized' unless current_role == 'OrderReceiver'
  end
  
  private
  
  def role_specific_path(role)
    case role
    when 'Admin'
      admin_path
    when 'StockManager'
      stock_manager_path
    when 'OrderReceiver'
      order_receiver_path
    else
      login_path
    end
  end
end