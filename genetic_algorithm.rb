class GeneticAlgorithm
  NUMBER_OF_MUTANT_ORDERS = 1000
  NUMBER_OF_GENERATIONS = 1000

  def self.assign_orders(pickers, orders)
    original_orders = orders.dup
    picker_capacity = (orders.count.to_f / pickers.count).ceil

    pickers.map do |picker|
      while picker.orders.count < picker_capacity && orders.any?
        order = orders.shift
        picker.orders << order if order
      end
    end

    {
      orders: original_orders,
      pickers: pickers,
      fitness_score: FitnessScore.new(pickers).value
    }
  end

  def self.mutate(orders, mutation_count:)
    orders = orders.dup

    first_index = rand(orders.count)
    second_index = rand(orders.count)

    buffer = orders[first_index]
    orders[first_index] = orders[second_index]
    orders[second_index] = buffer

    if mutation_count <= 0
      orders
    else
      mutate(orders, mutation_count: mutation_count - 1)
    end
  end

  def self.winning_distribution_from_orders(order_set)
    distributions = []

    order_set.each do |orders|
      distributions << assign_orders(Picker.generate(NUMBER_OF_PICKERS), orders)
    end

    distributions.sort_by! { |d| d[:fitness_score] }.reverse!
    distributions[0]
  end

  def self.winning_mutants(previously_winning_distribution, generation_index)
    mutant_order_set = NUMBER_OF_MUTANT_ORDERS.times.map do
      mutate(previously_winning_distribution[:orders], mutation_count: rand(5))
    end

    new_potentially_winning_distribution = winning_distribution_from_orders(mutant_order_set)

    if new_potentially_winning_distribution[:fitness_score] > previously_winning_distribution[:fitness_score]
      winning_distribution = new_potentially_winning_distribution
    else
      winning_distribution = previously_winning_distribution
    end

    puts "-" * 80
    puts "Generation: #{generation_index} of #{NUMBER_OF_GENERATIONS}"
    puts
    puts "Winning distribution:"
    print_distribution_stats(winning_distribution)
    puts

    return if generation_index >= NUMBER_OF_GENERATIONS
    winning_mutants(winning_distribution, generation_index + 1)
  end

  def self.run(orders)
    winning_distribution = winning_distribution_from_orders([orders])
    original_highest_fitness_score = winning_distribution[:fitness_score]
    print_distribution_stats(winning_distribution)


    winning_mutants(winning_distribution, 1)

    puts "Initial highest fitness score: #{original_highest_fitness_score}"
  end
end
