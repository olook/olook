# -*- encoding : utf-8 -*-
require "spec_helper"

describe BilletExpirationDate do
  context "when today is saturday" do
    let(:saturday) { Date.civil(2012, 01, 14).to_time_in_current_zone }
    let(:tuesday) { saturday + 3.days }
    it "returns tuesday" do
      Timecop.freeze(saturday) do
        expect(described_class.business_day_expiration_date).to eq tuesday
      end
    end
  end

  context "when today is sunday" do
    let(:sunday) { Date.civil(2012, 01, 15).to_time_in_current_zone }
    let(:tuesday) { sunday + 2.days }
    it "returns tuesday" do
      Timecop.freeze(sunday) do
        expect(described_class.business_day_expiration_date).to eq tuesday
      end
    end
  end

  context "when today is monday" do
    let(:monday) { Date.civil(2012, 01, 15).to_time_in_current_zone }
    let(:wednesday) { monday + 2.days }
    it "returns wednesday" do
      Timecop.freeze(monday) do
        expect(described_class.business_day_expiration_date).to eq wednesday
      end
    end
  end

  context "when today is tuesday" do
    let(:tuesday) { Date.civil(2012, 01, 17).to_time_in_current_zone }
    let(:thursday) { tuesday + 2.days }
    it "returns thursday" do
      Timecop.freeze(tuesday) do
        expect(described_class.business_day_expiration_date).to eq thursday
      end
    end
  end

  context "when today is wednesday" do
    let(:wednesday) { Date.civil(2012, 01, 18).to_time_in_current_zone }
    let(:friday) { wednesday + 2.days }
    it "returns friday" do
      Timecop.freeze(wednesday) do
        expect(described_class.business_day_expiration_date).to eq friday
      end
    end
  end

  context "when today is thursday" do
    let(:thursday) { Date.civil(2012, 01, 19).to_time_in_current_zone }
    let(:monday) { thursday + 4.days }
    it "returns monday" do
      Timecop.freeze(thursday) do
        expect(described_class.business_day_expiration_date).to eq monday
      end
    end
  end

  context "when today is friday" do
    let(:friday) { Date.civil(2012, 01, 20).to_time_in_current_zone }
    let(:tuesday) { friday + 4.days }
    it "returns tuesday" do
      Timecop.freeze(friday) do
        expect(described_class.business_day_expiration_date).to eq tuesday
      end
    end
  end
end
