# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order
  before_filter :check_user_address

  def index
  end
end
