require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
  it "can return one item" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    get "/api/v1/items/#{item1.id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry
    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(item1.id.to_s)
  
    expect(item).to have_key(:type)
    expect(item[:type]).to be_a(String) 

    expect(item).to have_key(:attributes)

    expect(item[:attributes][:name]).to be_a(String) 
    expect(item[:attributes][:name]).to eq(item1.name) 

    expect(item[:attributes][:description]).to be_a(String) 
    expect(item[:attributes][:description]).to eq(item1.description)

    expect(item[:attributes][:unit_price]).to be_a(Float) 
    expect(item[:attributes][:unit_price]).to eq(item1.unit_price) 

    expect(item[:attributes][:merchant_id]).to be_an(Integer)
    expect(item[:attributes][:merchant_id]).to eq(item1.merchant_id)
  end
end