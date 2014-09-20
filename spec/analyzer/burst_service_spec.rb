require 'spec_helper'
require 'analyzer/burst_service'

describe Analyzer::BurstService do
  before(:each) do
    @first_price_date = Date.parse("2004-04-01")
  end

  describe "#best_bursting_stocks" do
    context "with nil date" do
      it "should raise argument error" do
        expect {
          Analyzer::BurstService.best_bursting_stocks(nil, "woot")
        }.to raise_error(ArgumentError)
      end
    end

    context "with nil filename" do
      it "should raise argument error" do
        expect {
          Analyzer::BurstService.best_bursting_stocks(Date.new(2004,4,1), nil)
        }.to raise_error(ArgumentError)
      end
    end

    context "with nonexistent file" do
      it "should raise argument error" do
        expect {
          Analyzer::BurstService.best_bursting_stocks(Date.new(2004,4,1), "woot")
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#most_recent_highest_burst" do
    context "with no prices" do

      it "should return nil for wrong parameter" do
        expect(Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", 0)).to be_nil
      end

      it "should return nil for nil prices" do
        expect(Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", nil)).to be_nil
      end

      it "should return nil for empty array" do
        expect(Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [])).to be_nil
      end

      it "should return nil for one price" do
        expect(Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [1.0])).to be_nil
      end
    end

    context "constant price" do
      it "should return nil" do
        burst = Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [19.0, 19.0])
        expect(burst).to be_nil
      end
    end

    context "dropping in price" do
      it "should return nil" do
        burst = Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [20.0, 19.0])
        expect(burst).to be_nil
      end
    end

    context "increasing in price" do
      it "should return a burst spanning the increase" do
        burst = Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [19.0, 20.0])
        expect(burst).to eq(Analyzer::Burst.new(@first_price_date, "TEST", 0, 1, 19.0, 20.0))
      end
    end

    context "up down up" do
      it "should return the second burst" do
        burst = Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [19.0, 20.0, 19.0, 20.0])
        expect(burst).to eq(Analyzer::Burst.new(@first_price_date, "TEST", 2, 3, 19.0, 20.0))
      end
    end

    context "down up down" do
      it "should return the only increase in price" do
        burst = Analyzer::BurstService.most_recent_highest_burst(@first_price_date, "TEST", [20.0, 19.0, 20.0, 19.0])
        expect(burst).to eq(Analyzer::Burst.new(@first_price_date, "TEST", 1, 2, 19.0, 20.0))
      end
    end

  end

end
