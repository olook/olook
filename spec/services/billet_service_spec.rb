require "spec_helper"

describe BilletService do
  it "Generate uniq file name" do
    file_name1 = BilletService.file_name
    file_name2 = BilletService.file_name
    expect(file_name1).to_not eql(file_name2)
  end
  context "When have payments" do
    before do
      order = FactoryGirl.create(:order)
      @payment1 = FactoryGirl.create(:billet, state: 'waiting_payment', id: '175320')
      @payment1.order = order
      @payment2 = FactoryGirl.create(:billet, state: 'authorized')
    end
    context "with correct payment" do
      it "fill successful payment on hash" do
        BilletService.should_receive(:parse_file).with('text.txt').and_return(["                           000000#{@payment1.id}6 220313 220313           #{@payment1.total_paid.to_s.gsub('.',',')}       0,00       0,00           #{@payment1.total_paid.to_s.gsub('.',',')}      0,92T LIQ COMPENS", "                           000000#{@payment2.id}6 220313 220313          116,30       0,00       0,00          116,30      0,92T LIQ COMPENS"])
        hash = BilletService.process_billets('text.txt')
        expect(hash[:successful]).to_not be_empty
      end
    end
  end
end
