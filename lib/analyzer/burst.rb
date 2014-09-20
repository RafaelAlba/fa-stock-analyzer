module Analyzer

  # Keeps track of a single burst period. A burst consists of a lowest
  # and highest price along with array based indeces to quickly
  # identify where those prices occurred.
  class Burst

    attr_accessor :first_price_date, :stock_symbol, :starting_index, :highest_price_index, :starting_price, :highest_price

    def initialize(first_price_date, stock_symbol, starting_index, highest_price_index, starting_price, highest_price)

      if starting_index < 0 || highest_price_index < 0
        raise ArgumentError.new("Only positive indeces (including zero) are supported")
      end

      if starting_price <= 0.0 || highest_price <= 0.0
        raise ArgumentError.new("Only positive prices (excluding zero) are supported at the moment")
      end

      @has_ended = false

      @first_price_date = first_price_date
      @stock_symbol = stock_symbol
      @starting_index = starting_index
      @highest_price_index = highest_price_index
      @starting_price = starting_price
      @highest_price = highest_price
    end

    def has_ended?
      @has_ended
    end

    def add_price(index, price)
      if price <= 0.0
        raise ArgumentError.new("Only positive prices (excluding zero) are supported at the moment")
      end

      return if @has_ended

      # new price has dipped below start place, marking end of burst
      if @starting_price >= price
        @has_ended = true

      elsif @highest_price < price
        # previous best has been bested
        @highest_price = price
        @highest_price_index = index
      end
    end

    def valid?
      (@highest_price_index - @starting_index > 0) && (@starting_price < @highest_price)
    end

    def percentage_gain
      return 0.0 unless valid?

      (((@highest_price - @starting_price) / @starting_price) * 100).round(2)
    end

    def ==(other)
      @stock_symbol == other.stock_symbol && @starting_index == other.starting_index &&
        @highest_price_index == other.highest_price_index &&
        @starting_price == other.starting_price && @highest_price == other.highest_price
    end

    def <=>(other)
      # order based on percentage gain
      result = percentage_gain <=> other.percentage_gain

      if result == 0
        # order based on starting index
        result = @starting_index <=> other.starting_index
      end

      if result == 0
        # order alphabetically based on stock symbol if
        # percentage gain is a tie
        result = @stock_symbol <=> other.stock_symbol
      end

      result
    end

    def to_s
      inspect
    end

    def inspect
      if valid?
        start_of_burst_date_string = (@first_price_date >> @starting_index).strftime("%b %Y")
        end_of_burst_date_string = (@first_price_date >> @highest_price_index).strftime("%b %Y")
        "#{@stock_symbol}: (#{start_of_burst_date_string} - #{end_of_burst_date_string})  (#{@starting_price}, #{@highest_price}) #{percentage_gain}% gain"
      else
        "invalid burst"
      end
    end

  end

end
