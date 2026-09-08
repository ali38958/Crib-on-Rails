class DashboardsController < ApplicationController
  before_action :authenticate_request
  
  def index
    redirect_to role_specific_path(current_role)
  end
end