require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :merchant_id}
  end

  before :each do
    @merchant = create(:merchant)
    @item1 = create(:item, name: "Item One", unit_price: 10, merchant: @merchant)
    @item2 = create(:item, name: "Item Two", unit_price: 20, merchant: @merchant)
    @item3 = create(:item, name: "Item Three", unit_price: 30, merchant: @merchant)
  end

  describe '.search' do
    context 'when both name and price params are present' do
      it 'returns an error' do
        result = Item.search(name: "Item", min_price: 10)
        expect(result).to eq({ errors: 'Can not send price and keyword search in one query' })
      end
    end

    context 'when only price params are present' do
      it 'returns items within the price range' do
        result = Item.search(min_price: 10, max_price: 20)
        expect(result).to include(@item1, @item2)
        expect(result).not_to include(@item3)
      end
    end

    context 'when only name param is present' do
      it 'returns items matching the name' do
        result = Item.search(name: "Item One")
        expect(result).to include(@item1)
        expect(result).not_to include(@item2, @item3)
      end
    end

    context 'when no params are present' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect { Item.search({}) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.find_by_name' do
    it 'returns items matching the name' do
      result = Item.find_by_name("Item One")
      expect(result).to include(@item1)
      expect(result).not_to include(@item2, @item3)
    end

    # xit 'raises ActiveRecord::RecordNotFound if no items match the name' do
    #   expect { Item.find_by_name("Nonexistent Item") }.to raise_error(ActiveRecord::RecordNotFound)
    # end
  end

  describe '.search_by_price' do
    context 'when max_price is nil' do
      it 'returns items with price >= min_price' do
        result = Item.search_by_price(15)
        expect(result).to include(@item2, @item3)
        expect(result).not_to include(@item1)
      end
    end

    context 'when min_price is nil' do
      it 'returns items with price <= max_price' do
        result = Item.search_by_price(nil, 15)
        expect(result).to include(@item1)
        expect(result).not_to include(@item2, @item3)
      end
    end

    context 'when both min_price and max_price are present' do
      it 'returns items within the price range' do
        result = Item.search_by_price(10, 20)
        expect(result).to include(@item1, @item2)
        expect(result).not_to include(@item3)
      end
    end
  end

  describe '.validate_prices' do
    it 'returns an error if min_price is negative' do
      result = Item.validate_prices(-10)
      expect(result).to eq({ errors: 'Price cannot be negative' })
    end

    it 'returns an error if max_price is negative' do
      result = Item.validate_prices(10, -20)
      expect(result).to eq({ errors: 'Price cannot be negative' })
    end

    it 'returns nil if both prices are valid' do
      result = Item.validate_prices(10, 20)
      expect(result).to be_nil
    end
  end
end
