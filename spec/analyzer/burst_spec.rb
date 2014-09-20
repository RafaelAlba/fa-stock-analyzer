require 'spec_helper'
require 'analyzer/burst'

describe Analyzer::Burst do
  before(:each) do
    @first_price_date = Date.parse("2004-04-01")
    @stock_symbol = "TEST"
  end

  describe "#has_ended?" do

    context "brand new Burst" do
      it "should not have ended" do
        expect(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 0, 1.0, 2.0).has_ended?).to be(false)
      end
    end

  end

  describe "#valid?" do

    context "with negative starting index" do
      it "should not be valid" do
        expect {
          Analyzer::Burst.new(@first_price_date, @stock_symbol, -1, 0, 1.0, 2.0).valid?
        }.to raise_error(ArgumentError)
      end
    end

    context "with negative starting and highest price index" do
      it "should not be valid" do
        expect {
          Analyzer::Burst.new(@first_price_date, @stock_symbol, -2, -1, 1.0, 2.0).valid?
        }.to raise_error(ArgumentError)
      end
    end

    context "with negative highest price index" do
      it "should not be valid" do
        expect {
          Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, -1, 1.0, 2.0).valid?
        }.to raise_error(ArgumentError)
      end
    end

    context "with same starting and highest price index" do
      it "should not be valid" do
        expect(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 0, 1.0, 2.0).valid?).to be(false)
      end
    end

    context "with same starting and highest price" do
      it "should not be valid" do
        expect(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 1.0).valid?).to be(false)
      end
    end

    context "burst with highest price lower than starting price" do
      it "should not be valid" do
        expect(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 2.0, 1.0).valid?).to be(false)
      end
    end

    context "burst with highest price index lower than starting starting index" do
      it "should not be valid" do
        expect(Analyzer::Burst.new(@first_price_date, @stock_symbol, 1, 0, 1.0, 2.0).valid?).to be(false)
      end
    end

    context "burst with zero starting price" do
      it "should not be valid" do
        expect {
          Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 0.0, 2.0).valid?
        }.to raise_error(ArgumentError)
      end
    end

    context "burst with zero highest price" do
      it "should not be valid" do
        expect {
          Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 0.0).valid?
        }.to raise_error(ArgumentError)
      end
    end

  end

  describe "#percentage_gain" do

    context "with an invalid burst" do
      it "should return 0.0 percentage gain" do
        Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 0, 1.0, 2.0)
      end
    end

  end

  describe "#add_price" do
    before(:each) do
      @burst = Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 2.0)
    end

    context "adding a zero price to the burst" do
      it "should end the burst" do
        expect {
          @burst.add_price(2, 0.0)
        }.to raise_error(ArgumentError)
      end
    end

    context "adding a negative price to the burst" do
      it "should end the burst" do
        expect {
          @burst.add_price(2, -1.0)
        }.to raise_error(ArgumentError)
      end
    end

    context "adding a price to the burst that's equal to the starting price" do
      it "should end the burst" do
        @burst.add_price(2, 1.0)
        expect(@burst.has_ended?).to be(true)
      end
    end

    context "adding a price to the burst that's lower than the starting price" do
      it "should end the burst" do
        @burst.add_price(2, 0.5)
        expect(@burst.has_ended?).to be(true)
      end
    end

    context "adding a price to the burst that's equal to the highest price" do
      it "should not affect the burst" do
        @burst.add_price(2, 2.0)
        expect(@burst).to eq(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 2.0))
      end
    end

    context "adding a price to the burst that's lower than the highest price but higher than starting price" do
      it "should not affect the burst" do
        @burst.add_price(2, 1.5)
        expect(@burst).to eq(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 2.0))
      end
    end

    context "adding a price to the burst that's higher than the highest price" do
      it "should update burst to new highest price and index" do
        @burst.add_price(2, 3.0)
        expect(@burst).to eq(Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 2, 1.0, 3.0))
      end
    end

  end

  describe "<=>" do
    before(:each) do
      @burst = Analyzer::Burst.new(@first_price_date, @stock_symbol, 0, 1, 1.0, 2.0)
    end

    context "other's percentage gain is less" do
      it "should return 1" do
        expect(@burst <=> Analyzer::Burst.new(@first_price_date, "OTHER", 0, 1, 1.0, 1.5)).to be(1)
      end
    end

    context "other's percentage gain is equal" do
      context "and its stock symbol comes before in the alphabet" do
        it "should return 1" do
          expect(@burst <=> Analyzer::Burst.new(@first_price_date, "AOTHER", 0, 1, 1.0, 2.0)).to be(1)
        end
      end
      context "and its stock symbol comes after in the alphabet" do
        it "should return -1" do
          expect(@burst <=> Analyzer::Burst.new(@first_price_date, "ZOTHER", 0, 1, 1.0, 2.0)).to be(-1)
        end
      end
      context "and its stock symbol is the same" do
        it "should return 0" do
          expect(@burst <=> Analyzer::Burst.new(@first_price_date, "TEST", 0, 1, 1.0, 2.0)).to be(0)
        end
      end
    end

    context "other's percentage gain is greater" do
      it "should return 1" do
        expect(@burst <=> Analyzer::Burst.new(@first_price_date, "OTHER", 0, 1, 1.0, 3.0)).to be(-1)
      end
    end
  end

end
