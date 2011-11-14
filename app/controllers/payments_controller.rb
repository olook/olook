# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  respond_to :html

  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])
    if @payment.valid?
      order = Order.new
      order.save
      payment_builder = PaymentBuilder.new(order, @payment)
      payment_data = payment_builder.payment_data
      response = MoIP::Client.checkout(payment_data)
      payment_response = PaymentResponse.new
      payment_response.build_attributes response
      payment_response.save
      payment_url = MoIP::Client.moip_page(response["Token"])
      @payment.url = payment_url
      @payment.order = order
      @payment.payment_response = payment_response
      @payment.save
      redirect_to(payment_path(@payment), :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :ok }
    end
  end
end
