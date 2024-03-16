require "rspec"
require_relative "../fitness_score"
require_relative "../picker"

describe FitnessScore do
  context "one channel" do
    it "returns 100%" do
      picker = Picker.new(1)
      picker.orders = { reebelo: 5 }
      expect(FitnessScore.new([picker]).value).to eq(1.00)
    end
  end

  context "two channels" do
    it "returns 50%" do
      picker = Picker.new(1)
      picker.orders = { reebelo: 5, ebay: 2 }
      expect(FitnessScore.new([picker]).value).to eq(0.50)
    end
  end
end
