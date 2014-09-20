require "yaml"
require "csv"
require "rubygems"
require "algorithms"
require "analyzer/burst"

module Analyzer

  class BurstService

    # Given a pipe delimited file with the format:
    #    full stock name, stock symbol, and chronological stock prices.
    #    It will organize the stocks based on their price bursts.
    # @param first_price_date - Date object corresponding to the first
    # @param filename - file containing price information for different
    #    stocks. Assumes file is properly formatted.
    # @return ordered [Analyzer::Burst] based on each stock's highest burst.
    #    The stock with the highest percentage gain will be first. Will omit
    #    any stocks that did not burst over the given time period.
    def self.best_bursting_stocks(first_price_date, filename)
      if first_price_date.nil? || !first_price_date.kind_of?(Date)
        raise ArgumentError.new("Date cannot be nil and it has to be of type Date")
      end

      if filename.nil? or !File.exists?(filename)
        raise ArgumentError.new("Make sure the filename you provided is correct and it exists")
      end

      ordered_bursts = Containers::RubyRBTreeMap.new

      CSV.foreach(filename, :col_sep => '|') do |row|
        stock_symbol = row[1].strip
        prices = YAML::load(row[2].strip)

        burst = Analyzer::BurstService.most_recent_highest_burst(first_price_date, stock_symbol, prices)
        ordered_bursts.push(burst, nil) unless burst.nil?
      end

      ordered_bursts.reverse_each.map do |key, value| key end
    end

    # Given an array of prices ordered sequentially, it will
    #   return an Analyzer::Burst object containing the most recent
    #   and highest burst in the stock's history.
    # @param first_price_date - Date object corresponding to the first
    #    price in the array of prices
    # @param stock_symbol - symbol for the stock being processed
    # @param Prices - array containing prices for a stock.
    #    Prices are ordered sequentially in array, with oldest
    #    price first and most recent price last.
    # @return Analyzer::Burst representing the highest burst
    #    in the stock's history
    def self.most_recent_highest_burst(first_price_date, stock_symbol, prices)
      return nil unless prices.kind_of?(Array) && !prices.empty?

      ordered_bursts = Containers::RubyRBTreeMap.new

      current_burst = Analyzer::Burst.new(first_price_date, stock_symbol, 0, 0, prices[0], prices[0])

      prices.each_with_index do |price, index|
        next if index == 0

        current_burst.add_price(index, price)

        if current_burst.has_ended?
          ordered_bursts.push(current_burst, nil) if current_burst.valid?
          current_burst = Analyzer::Burst.new(first_price_date, stock_symbol, index, index, price, price)
        end
      end

      ordered_bursts.push(current_burst, nil) unless current_burst.has_ended? || !current_burst.valid?

      ordered_bursts.max_key
    end

  end

end
