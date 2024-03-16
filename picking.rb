require_relative "order_collection"
require_relative "picker"

order_collection = OrderCollection.new(
  ebay: 4,
  walmart: 3,
  reebelo: 2,
  amazon: 1,
  back_market: 8
)

pickers = Picker.generate(3)

while order_collection.any?
  pickers.map do |picker|
    picker.orders << order_collection.pop_random_order
  end
end
