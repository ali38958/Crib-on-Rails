class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:destroy]
  
  def destroy
    cookies.delete(:auth_token)
    cookies.delete(:refresh_token)
    redirect_to login_path, notice: "Logged out"
  end
end