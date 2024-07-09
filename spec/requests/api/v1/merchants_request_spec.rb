require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id
  
    get "/api/v1/merchants/#{id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id.to_s)
  
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)
  end

  it "can get all items for a given merchant ID" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry
    merchant_items.each do |merchant_items|
      expect(merchant_items).to have_key(:id)
      expect(merchant_items[:id]).to be_a(String)
  
      expect(merchant_items[:attributes]).to have_key(:name)
      expect(merchant_items[:attributes][:name]).to be_a(String)
  
      expect(merchant_items[:attributes]).to have_key(:description)
      expect(merchant_items[:attributes][:description]).to be_a(String)
  
      expect(merchant_items[:attributes]).to have_key(:unit_price)
      expect(merchant_items[:attributes][:unit_price]).to be_a(Float)
  
      expect(merchant_items[:attributes]).to have_key(:merchant_id)
      expect(merchant_items[:attributes][:merchant_id]).to be_a(Integer)
    end
  end
end