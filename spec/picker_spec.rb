require "rspec"
require_relative "../picker"

describe Picker do
  describe ".generate" do
    it "generates two pickers with numbers" do
      pickers = Picker.generate(2)
      expect(pickers.count).to eq(2)
      expect(pickers[0].number).to eq(1)
      expect(pickers[1].number).to eq(2)
    end
  end

  describe "#orders_by_channel" do
    it "returns orders by channel count" do
      picker = Picker.new(1)
      picker.orders << :ebay
      picker.orders << :ebay
      picker.orders << :amazon

      expect(picker.orders_by_channel[:ebay]).to eq(2)
      expect(picker.orders_by_channel[:amazon]).to eq(1)
    end
  end
end
