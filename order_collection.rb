class OrderCollection
  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end

  def flatten
    @orders.map do |channel_name, count|
      [channel_name] * count
    end.flatten
  end

  def any?
    @orders.values.sum > 0
  end

  def pop_random_order
    non_empty_orders = @orders.select { |channel, count| count > 0 }
    return unless non_empty_orders.any?

    order_key = non_empty_orders.keys.sample
    @orders[order_key] -= 1
    order_key
  end
end
