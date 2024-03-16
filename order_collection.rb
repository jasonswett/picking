class OrderCollection
  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end

  def any?
    @orders.values.sum > 0
  end

  def pop_random_order
    non_empty_orders = @orders.select { |channel, count| count > 0 }
    order_key = non_empty_orders.keys.sample
    @orders[order_key] -= 1
    order_key
  end
end
