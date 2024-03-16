require "rspec"
require_relative "../order_collection"

describe OrderCollection do
  describe "#any?" do
    context "none" do
      it "returns false" do
        order_collection = OrderCollection.new(ebay: 0)
        expect(order_collection.any?).to be false
      end
    end

    context "some" do
      it "returns true" do
        order_collection = OrderCollection.new(ebay: 1)
        expect(order_collection.any?).to be true
      end
    end
  end

  describe "#flatten" do
    it "returns a flattened version" do
      order_collection = OrderCollection.new(ebay: 2, amazon: 3)
      expect(order_collection.flatten).to eq(%i(ebay ebay amazon amazon amazon))
    end
  end

  describe "#pop_random_order" do
    it "returns a channel" do
      order_collection = OrderCollection.new(ebay: 1)
      expect(order_collection.pop_random_order).to eq(:ebay)
    end

    it "decreases the number of orders" do
      order_collection = OrderCollection.new(ebay: 1)
      order_collection.pop_random_order
      expect(order_collection.orders).to eq(ebay: 0)
    end

    context "no orders left" do
      it "returns nothing" do
        order_collection = OrderCollection.new(ebay: 0)
        expect(order_collection.pop_random_order).to be nil
      end
    end
  end
end
