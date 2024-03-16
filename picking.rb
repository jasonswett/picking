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

NUMBER_OF_PICKERS = 4

order_collection = OrderCollection.new(
  amazon: 4,
  back_market: 4,
  #ebay: 10,
  #walmart: 9
)

permutations = order_collection.flatten.permutation.to_a
puts "#{permutations.count} possible permutations, #{permutations.uniq.count} unique"

best_distribution = nil

permutations.uniq.each do |orders|
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

puts "*" * 80
puts "BEST DISTRIBUTION:"
puts "*" * 80
print_distribution_stats(best_distribution)
