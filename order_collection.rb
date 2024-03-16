class OrderCollection
  def initialize(orders)
    @orders = orders
  end

  def any?
    @orders.values.sum > 0
  end
end
