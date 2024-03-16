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
end
