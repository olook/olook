# -*- encoding : utf-8 -*-
require "spec_helper"

describe BilletExpirationDate do
  context "when today is saturday" do
    let(:saturday) { Date.civil(2012, 01, 14).to_time_in_current_zone }
    let(:tuesday) { saturday + 3.days }
    it "returns tuesday" do
      Timecop.freeze(saturday) do
        expect(described_class.expiration_for_two_business_day).to eq tuesday
      end
    end
  end

  context "when today is sunday" do
    let(:sunday) { Date.civil(2012, 01, 15).to_time_in_current_zone }
    let(:tuesday) { sunday + 2.days }
    it "returns tuesday" do
      Timecop.freeze(sunday) do
        expect(described_class.expiration_for_two_business_day).to eq tuesday
      end
    end
  end

  context "when today is monday" do
    let(:monday) { Date.civil(2012, 01, 15).to_time_in_current_zone }
    let(:wednesday) { monday + 2.days }
    it "returns wednesday" do
      Timecop.freeze(monday) do
        expect(described_class.expiration_for_two_business_day).to eq wednesday
      end
    end
  end

  context "when today is tuesday" do
    let(:tuesday) { Date.civil(2012, 01, 17).to_time_in_current_zone }
    let(:thursday) { tuesday + 2.days }
    it "returns thursday" do
      Timecop.freeze(tuesday) do
        expect(described_class.expiration_for_two_business_day).to eq thursday
      end
    end
  end

  context "when today is friday" do
    let(:friday) { Date.civil(2012, 01, 18).to_time_in_current_zone }
    let(:wednesday) { friday + 2.days }
    it "returns wednesday" do
      Timecop.freeze(friday) do
        expect(described_class.expiration_for_two_business_day).to eq wednesday
      end
    end
  end

  context "when today is thursday" do
    let(:thursday) { Date.civil(2012, 01, 19).to_time_in_current_zone }
    let(:monday) { thursday + 4.days }
    it "returns monday" do
      Timecop.freeze(thursday) do
        expect(described_class.expiration_for_two_business_day).to eq monday
      end
    end
  end
end
