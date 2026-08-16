class OrderReceiver::BaseController < ApplicationController
  before_action :authenticate_request
  before_action :require_order_receiver
end