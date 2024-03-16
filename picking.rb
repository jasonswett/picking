require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"

def assign_orders(pickers, orders)
  while orders.any?
    pickers.map do |picker|
      order = orders.pop
      picker.orders << order if order
    end
  end

  puts "-" * 80

  pickers.each do |picker|
    puts "Picker ##{picker.number}"
    puts picker.orders_by_channel
    puts
  end

  puts "Fitness score: #{FitnessScore.new(pickers).value}"
end

pickers = Picker.generate(3)

order_collection = OrderCollection.new(
  amazon: 2,
  ebay: 2,
  back_market: 2
)

assign_orders(pickers, order_collection.flatten)
