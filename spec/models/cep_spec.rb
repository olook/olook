require 'spec_helper'

describe Cep do
  describe "#adapt_cep_to_address_hash" do
    let(:cep) { FactoryGirl.create(:cep) }
    context "when " do
      it "returns a zipcode-friendly hash" do
        {
          zip_code: cep.cep.insert(5, '-'), 
          street: cep.endereco, 
          neighborhood: cep.bairro, 
          city: cep.cidade, 
          state: cep.estado
        }.should eq(cep.adapt_cep_to_address_hash)
      end
    end
  end
end
