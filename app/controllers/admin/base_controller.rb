class Admin::BaseController < ApplicationController
  before_action :authenticate_request
  before_action :require_admin
end