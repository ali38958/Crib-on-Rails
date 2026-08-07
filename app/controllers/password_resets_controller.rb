class PasswordResetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    identifier = params[:identifier]
    user = find_user_by_email(identifier)
    
    if user
      otp = rand(100_000..999_999).to_s
      
      PasswordReset.where(user_type: user.class.name, user_id: user.id).destroy_all
      
      reset = PasswordReset.new(
        user_type: user.class.name,
        user_id: user.id,
        expires_at: ENV.fetch('OTP_EXPIRATION_MINUTES', 5).to_i.minutes.from_now
      )
      reset.set_otp(otp)
      
      if reset.save
        UserMailer.password_reset_email(user.email, otp).deliver_now
        render json: { success: true, message: 'OTP sent to your email.' }
      else
        render json: { success: false, message: 'Failed to generate OTP.' }
      end
    else
      render json: { success: false, message: 'Email not found.' }
    end
  end

  def verify
    identifier = params[:identifier]
    otp = params[:otp]
    
    user = find_user_by_email(identifier)
    if user
      reset = PasswordReset.find_by(user_type: user.class.name, user_id: user.id)
      if reset && reset.valid_otp?(otp)
        render json: { success: true, message: 'OTP verified.' }
      else
        render json: { success: false, message: 'Invalid or expired OTP.' }
      end
    else
      render json: { success: false, message: 'User not found.' }
    end
  end

  def update_password
    identifier = params[:identifier]
    otp = params[:otp]
    new_password = params[:new_password]
    
    user = find_user_by_email(identifier)
    if user
      reset = PasswordReset.find_by(user_type: user.class.name, user_id: user.id)
      if reset && reset.valid_otp?(otp)
        if user.update(password: new_password)
          reset.destroy # invalidate OTP
          render json: { success: true, message: 'Password updated successfully.', redirect: '/login' }
        else
          render json: { success: false, message: 'Failed to update password.' }
        end
      else
        render json: { success: false, message: 'Invalid or expired OTP.' }
      end
    else
      render json: { success: false, message: 'User not found.' }
    end
  end

  private

  def find_user_by_email(email)
    Admin.find_by(email: email) ||
      StockManager.find_by(email: email) ||
      OrderReceiver.find_by(email: email)
  end
end
