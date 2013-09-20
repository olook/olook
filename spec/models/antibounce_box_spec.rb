require 'spec_helper'

describe AntibounceBox do
  describe "#need_antibounce_box" do
    context "brands section specific validation" do
      context "action == show" do 
        let(:search) { OpenStruct.new(pages: 3, current_page: 3, expressions: {"brand" => ["whatever"]})}
        let(:params) {{"action" => "show", "controller" => "brands", "category" => "roupa"}}
        let(:brands) { ["dfsafds"] }

        context "category-related testing" do
          context "when category derives from clothes" do
            let(:params) {{"action" => "show", "controller" => "brands", "category" => "roupa"}}            
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true}
          end

          context "when category doesn't derive from clothes" do
            let(:params) {{"action" => "show", "controller" => "brands", "category" => "dsfafds"}}            
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_false}
          end          
        end

        context "brand-related testing" do
          context "when at least one brand is selected" do
            let(:search) { OpenStruct.new(pages: 3, current_page: 3, expressions: {"brand" => ["whatever"]})}            
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true}
          end

          context "when no brand is selected" do
            let(:search) { OpenStruct.new(pages: 3, current_page: 3, expressions: {"brand" => []})}            
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_false}
          end                              
        end

        it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true} 
      end

      context "action != show" do
        let(:params) {{"action" => "whatever", "controller" => "brands"}}
        it { expect(AntibounceBox.need_antibounce_box?(nil, nil, params)).to be_false} 
      end
    end

    context "generic validation" do
      context "action == show" do 
        let(:search) { OpenStruct.new(pages: 3, current_page: 3)}
        let(:params) {{"action" => "show", "controller" => "catalogs"}}
        let(:brands) { ["dfsafds"] }

        context "result-related testing" do
          context "when there are no results" do
            let(:search) { OpenStruct.new(pages: 0)}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true} 
          end

          context "when it's the last page" do
            let(:search) { OpenStruct.new(pages: 3, current_page: 3)}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true} 
          end

          context "when it's not the last page" do
            let(:search) { OpenStruct.new(pages: 3, current_page: 2)}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_false} 
          end
        end

        context "brand-related testing" do
          context "when there are no brands" do
            let(:brands) {[]}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_false} 
          end

          context "when there are non-whitelisted brands" do
            let(:brands) {["safsd"]}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true} 
          end

          context "when there are whitelisted brands" do
            let(:brands) {["olook"]}
            it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_false} 
          end
        end

        it { expect(AntibounceBox.need_antibounce_box?(search, brands, params)).to be_true} 
      end

      context "action != show" do
        let(:params) {{"action" => "whatever", "controller" => "catalogs"}}
        it { expect(AntibounceBox.need_antibounce_box?(nil, nil, params)).to be_false} 
      end
    end

    context "other sections" do
      let(:params) {{"action" => "whatever", "controller" => "whatever"}}
      it { expect(AntibounceBox.need_antibounce_box?(nil, nil, params)).to be_false} 
    end    
  end
end
