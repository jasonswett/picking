require "pry"
require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"

def assign_orders(pickers, orders)
  picker_capacity = (orders.count.to_f / pickers.count).ceil

  pickers.map do |picker|
    while picker.orders.count < picker_capacity && orders.any?
      order = orders.shift
      picker.orders << order if order
    end
  end

  {
    pickers: pickers,
    fitness_score: FitnessScore.new(pickers).value
  }
end

def print_distribution_stats(distribution)
  distribution[:pickers].each do |picker|
    puts "Picker ##{picker.number}"
    puts picker.orders_by_channel
    puts
  end

  puts "Fitness score: #{distribution[:fitness_score]}"
end

def formatted_number(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

NUMBER_OF_PICKERS = 4

order_collection = OrderCollection.new(
  amazon: 4,
  back_market: 4,
  ebay: 4,
  walmart: 4
)

permutation_hash = {}

while permutation_hash.keys.count < 20_000 do
  orders = order_collection.flatten.shuffle

  if !permutation_hash[orders]
    permutation_hash[orders] = true
    print "."
  end
end

permutations = permutation_hash.keys

best_distribution = nil

permutations.each do |orders|
  pickers = Picker.generate(NUMBER_OF_PICKERS)
  distribution = assign_orders(pickers, orders)

  puts "-" * 80
  print_distribution_stats(distribution)
  puts

  best_distribution ||= distribution
  if distribution[:fitness_score] > best_distribution[:fitness_score]
    best_distribution = distribution
  end
end

puts "#{formatted_number(permutations.count)} permutations"
puts "*" * 80
puts "BEST DISTRIBUTION:"
puts "*" * 80
print_distribution_stats(best_distribution)
