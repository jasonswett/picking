class FitnessScore
  def initialize(pickers)
    @pickers = pickers
  end

  def value
    1 / average_number_of_channels_per_picker
  end

  private

  def average_number_of_channels_per_picker
    @pickers.map { |p| p.orders_by_channel.keys.count }.sum.to_f / @pickers.count
  end
end
