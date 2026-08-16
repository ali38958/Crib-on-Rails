class StockManager::BaseController < ApplicationController
  before_action :authenticate_request
  before_action :require_stock_manager
end