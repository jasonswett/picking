require "pry"
require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"

def assign_orders(pickers, orders)
  orders.sort!
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
  puts "-" * 80

  distribution[:pickers].each do |picker|
    puts "Picker ##{picker.number}"
    puts picker.orders_by_channel
    puts
  end

  puts "Fitness score: #{distribution[:fitness_score]}"
end

pickers = Picker.generate(4)

order_collection = OrderCollection.new(
  amazon: 110,
  back_market: 100,
  ebay: 100,
  walmart: 90
)

orders = order_collection.flatten.shuffle
distribution = assign_orders(pickers, orders)
print_distribution_stats(distribution)
