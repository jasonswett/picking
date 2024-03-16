require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"

order_collection = OrderCollection.new(
  amazon: 2,
  ebay: 2,
  back_market: 2
)

pickers = Picker.generate(3)

while order_collection.any?
  pickers.map do |picker|
    order = order_collection.pop_random_order
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
