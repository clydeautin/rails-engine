require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
  end

  describe "#find_by_name" do
    it "can find merchant by name" do
      
      merchant1 = Merchant.create!(name: "Target")
      merchant2 = Merchant.create!(name: "Walmart")

      expect(Merchant.find_by_name("Target")).to eq(merchant1)
    end
  end
end