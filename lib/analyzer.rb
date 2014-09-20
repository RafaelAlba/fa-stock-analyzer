require "csv"
require "analyzer/burst_service"

def clean(str)
  str.sub(/^\s*/, "").sub(/\s*$/, "")
end

def to_float_array(str)
  str.sub(/\[/, "").sub(/\]/, "").split(",").map do |string_number|
    clean(string_number).to_f
  end
end

CSV.foreach("one-company.txt", :col_sep => '|') do |row|
  full_name = clean(row[0])
  symbol_name = clean(row[1])
  prices = to_float_array(clean(row[2]))

  burst = BurstService.best_burst(prices)

  puts "SYMBOL: #{symbol_name}, BEST BURST: #{burst}"
end
