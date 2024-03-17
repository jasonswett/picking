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

NUMBER_OF_PICKERS = 3

order_collection = OrderCollection.new(
  amazon: rand(20),
  ebay: rand(20),
  reebelo: rand(20),
  back_market: rand(20),
)

pickers = Picker.generate(NUMBER_OF_PICKERS)

def capacity(picker, starting_picker_capacity)
  starting_picker_capacity - picker.orders.count
end

def assign(order_collection, pickers)
  starting_picker_capacity = (order_collection.count.to_f / pickers.count).ceil
  puts "Picker capacity: #{starting_picker_capacity}"
  puts

  order_collection.orders_desc.keys.each do |channel_name|
    pickers.each do |picker|
      picker_capacity = capacity(picker, starting_picker_capacity)
      next unless picker_capacity > 0

      if order_collection.orders[channel_name] >= picker_capacity
        picker.orders += [channel_name] * picker_capacity
        order_collection.orders[channel_name] -= picker_capacity
      end
    end
  end

  order_collection.orders_desc.keys.each do |channel_name|
    pickers.each do |picker|
      picker_capacity = capacity(picker, starting_picker_capacity)
      next unless picker_capacity > 0

      if picker_capacity >= order_collection.orders[channel_name]
        picker.orders += [channel_name] * order_collection.orders[channel_name]
        order_collection.orders[channel_name] = 0
      end
    end
  end

  order_collection.orders_desc.keys.each do |channel_name|
    pickers.each do |picker|
      while order_collection.orders[channel_name] > 0 && capacity(picker, starting_picker_capacity) > 0 do
        picker.orders << channel_name
        order_collection.orders[channel_name] -= 1
      end
    end
  end
end

puts order_collection.orders

assign(order_collection, pickers)

pickers.each do |picker|
  puts "Picker ##{picker.number}: #{picker.orders_by_channel}"
end

puts
puts "Fitness score: #{FitnessScore.new(pickers).value}"
