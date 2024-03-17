require "pry"
require_relative "order_collection"
require_relative "picker"
require_relative "fitness_score"
require_relative "genetic_algorithm"

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
