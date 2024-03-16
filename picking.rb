require "pry"
require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"

def mutate(orders)
  first_index = rand(orders.count)
  second_index = rand(orders.count)

  buffer = orders[first_index]
  orders[first_index] = orders[second_index]
  orders[second_index] = buffer
  orders
end

def assign_orders(pickers, orders)
  original_orders = orders.dup
  picker_capacity = (orders.count.to_f / pickers.count).ceil

  pickers.map do |picker|
    while picker.orders.count < picker_capacity && orders.any?
      order = orders.shift
      picker.orders << order if order
    end
  end

  {
    orders: original_orders,
    pickers: pickers,
    fitness_score: FitnessScore.new(pickers).value
  }
end

def print_distribution_stats(distribution)
  puts "-" * 80

  distribution[:pickers].each do |picker|
    puts "Picker ##{picker.number}: #{picker.orders_by_channel}"
  end

  puts "Fitness score: #{distribution[:fitness_score]}"
  puts
end

def formatted_number(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

NUMBER_OF_PICKERS = 4

order_collection = OrderCollection.new(
  amazon: 8,
  back_market: 8,
  ebay: 8,
  walmart: 8
)

permutation_hash = {}

while permutation_hash.keys.count < 20_000 do
  orders = order_collection.flatten.shuffle

  if !permutation_hash[orders]
    permutation_hash[orders] = true
  end
end

NUMBER_OF_WINNING_DISTRIBUTIONS = 3

def winning_distributions_from_orders(order_set)
  distributions = []

  order_set.each do |orders|
    distributions << assign_orders(Picker.generate(NUMBER_OF_PICKERS), orders)
  end

  distributions.sort_by! { |d| d[:fitness_score] }.reverse!
  distributions[0..(NUMBER_OF_WINNING_DISTRIBUTIONS - 1)]
end

permutations = permutation_hash.keys
winning_distributions = winning_distributions_from_orders(permutations)

winning_distributions.each do |distribution|
  print_distribution_stats(distribution)
end

mutant_order_set = 100.times.map do
  mutate(winning_distributions[0][:orders].dup)
end

puts "*" * 80
winning_distributions_from_orders(mutant_order_set).each do |distribution|
  print_distribution_stats(distribution)
end

#10.times do
#  distribution = assign_orders(Picker.generate(NUMBER_OF_PICKERS), mutate(winning_distributions[0][:orders]).dup)
#  print_distribution_stats(distribution)
#end
