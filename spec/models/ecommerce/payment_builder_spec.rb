require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:delivery_address) { FactoryGirl.create(:address, :user => user)}
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { FactoryGirl.create(:payment, :order => order) }

  it "should return the payer" do
    builder = PaymentBuilder.new(order, payment, delivery_address)
    expected = {
      :nome => order.user_name,
      :email => order.user_email,
      :logradouro => delivery_address.street,
      :complemento => delivery_address.complement,
      :numero => delivery_address.number,
      :bairro => delivery_address.neighborhood,
      :cidade => delivery_address.city,
      :estado => delivery_address.state,
      :pais => delivery_address.country,
      :cep => delivery_address.zip_code,
      :tel_fixo => delivery_address.telephone }

    builder.payer.should == expected
  end

  it "should return payment data for billet" do
    builder = PaymentBuilder.new(order, payment, delivery_address)
    order.stub(:total).and_return(10.50)
    payer = builder.payer
    expected = { :valor => order.total, :id_proprio => order.id,
                :forma => "BoletoBancario", :pagador => payer,
                :razao=> "Pagamento" }

    builder.payment_data.should == expected
  end
 end
