require "spec_helper"

describe Checkout::BilletsController do

  it "routes to #show" do
    get("/pagamento/boletos/1").should route_to("checkout/billets#show", :id => "1")
  end

end