class FitnessScore
  def initialize(pickers)
    @pickers = pickers
  end

  def value
    1 / average_number_of_channels_per_picker
  end

  private

  def average_number_of_channels_per_picker
    sum_of_number_of_channels(pickers_with_orders).to_f / pickers_with_orders.count
  end

  def sum_of_number_of_channels(pickers)
    pickers.map { |p| p.orders_by_channel.keys.count }.sum
  end

  def pickers_with_orders
    @pickers.select { |p| p.orders_by_channel.keys.count > 0 }
  end
end
