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

best_bursting_stocks
  Given a pipe delimited file with the format:
     full stock name, stock symbol, and chronological stock prices.
     It will organize the stocks based on their price bursts.


most_recent_highest_burst
  Given an array of prices ordered sequentially, it will return an Analyzer::Burst object containing the most recent and highest burst in the stock's history.

# Instructions for running from command line

- Install required gems  
  `bundle install --path vendor/bundle`
- Run the analyzer for the test data set(burst-data.txt) representing  stock prices from Apr 2004  
  `bundle exec bin/analyze "2004-04-01" burst-data.txt`
- Run the tests  
  `bundle exec rspec`
