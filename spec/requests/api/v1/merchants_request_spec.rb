require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq (200)

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
    expect(response.status).to eq (200)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id.to_s)
  
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)
  end

  it "will gracefully handle if a Merchant id doesn't exist" do
    get "/api/v1/merchants/123456789"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=123456789")
  end

  it "can get all items for a given merchant ID" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"
    
    expect(response).to be_successful
    expect(response.status).to eq (200)
    
    merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant_items.count).to eq(3)

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

  it "will gracefully handle if a Merchant id doesn't exist when searching for merchant items" do
    get "/api/v1/merchants/123456789/items"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=123456789")
  end

  it "can get one merchant by its name" do
    merchant1 = create(:merchant, name: "Target")
    merchant2 = create(:merchant)
    
    get "/api/v1/merchants/find?name=Rget"

    merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful
    expect(response.status).to eq (200)

    expect(merchant_found).to have_key(:id)
    expect(merchant_found[:id]).to eq(merchant1.id.to_s)
  
    expect(merchant_found).to have_key(:attributes)
    expect(merchant_found[:attributes][:name]).to eq(merchant1.name)

    expect(merchant_found).to have_key(:type)
    expect(merchant_found[:type]).to be_a(String)
  end

  it "will gracefully handle if no match with name" do
    merchant1 = create(:merchant, name: "Target")

    get "/api/v1/merchants/find?name=Walmart"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'name'=Walmart")
  end

  it "will gracefully handle if no parameters passed" do
    merchant1 = create(:merchant, name: "Target")

    get "/api/v1/merchants/find"

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Bad Request, No name parameter")
  end

  it "will gracefully handle if name parameter is empty" do
    merchant1 = create(:merchant, name: "Target")

    get "/api/v1/merchants/find?name="

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Bad Request, No name parameter")
  end
end