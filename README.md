fa-stock-analyzer
=================

#Assignment  

I felt compelled to make these assumptions based on the
current situation. Normally, I'd go back to the customer
and see what it is they wanted. I assumed the role of the
customer to make things go quicker since my I thought my
3 week vacation was already delay enough.

#I've made the following assumptions:  

- A burst can have dips in price before reaching the highest price
- Prices can never be zero, since they wouldn't be on the market.

# Stock Analytics  

## Bursting Service
Want to find out the biggest bursts for your preferred stocks?  This is the perfect service for you!

- best_bursting_stocks  
     Given a pipe delimited file with the format:
        full stock name, stock symbol, and chronological stock prices.
        It will organize the stocks based on their price bursts.  
     @param first_price_date - Date object corresponding to the first  
     @param filename - file containing price information for different
        stocks. Assumes file is properly formatted.  
     @return ordered [Analyzer::Burst] based on each stock's highest burst.
        The stock with the highest percentage gain will be first. Will omit
        any stocks that did not burst over the given time period.  


- most_recent_highest_burst  
     Given an array of prices ordered sequentially, it will
       return an Analyzer::Burst object containing the most recent
       and highest burst in the stock's history.  
     @param first_price_date - Date object corresponding to the first
        price in the array of prices  
     @param stock_symbol - symbol for the stock being processed  
     @param Prices - array containing prices for a stock.
        Prices are ordered sequentially in array, with oldest
        price first and most recent price last.  
     @return Analyzer::Burst representing the highest burst
        in the stock's history  

# Instructions for running from command line

- Install required gems  
  `bundle install --path vendor/bundle`
- Run the analyzer for the test data set(burst-data.txt) representing  stock prices from Apr 2004  
  `bundle exec bin/analyze "2004-04-01" burst-data.txt`
- Run the tests  
  `bundle exec rspec`
