require "pry"
require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"
require_relative "genetic_algorithm"

def mutate(orders, mutation_count:)
  orders = orders.dup

  first_index = rand(orders.count)
  second_index = rand(orders.count)

  buffer = orders[first_index]
  orders[first_index] = orders[second_index]
  orders[second_index] = buffer

  if mutation_count <= 0
    orders
  else
    mutate(orders, mutation_count: mutation_count - 1)
  end
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
  distribution[:pickers].each do |picker|
    puts "Picker ##{picker.number}: #{picker.orders_by_channel}"
  end

  puts "Fitness score: #{distribution[:fitness_score]}"
end

def formatted_number(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

NUMBER_OF_PICKERS = 4

order_collection = OrderCollection.new(
  amazon: 30,
  back_market: 20,
  ebay: 20,
  walmart: 10
)

GeneticAlgorithm.run(order_collection.flatten.shuffle)
