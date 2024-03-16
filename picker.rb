class Picker
  attr_reader :number
  attr_accessor :orders

  def self.generate(number_of_pickers)
    (1..number_of_pickers).to_a.map do |number|
      new(number)
    end
  end

  def initialize(number)
    @number = number
    @orders = []
  end

  def orders_by_channel
    orders.each_with_object(Hash.new(0)) do |channel_name, counts|
      counts[channel_name] += 1
    end
  end
end
