class Picker
  attr_reader :number

  def self.generate(number_of_pickers)
    (1..number_of_pickers).to_a.map do |number|
      new(number)
    end
  end

  def initialize(number)
    @number = number
  end

  def has_capacity?
    true
  end
end
