require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.status).to eq (200)

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
    
    expect(response).to be_successful
    expect(response.status).to eq (200)

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

  it "will gracefully handle if a Item id doesn't exist" do
    get "/api/v1/items/123456789"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=123456789")
  end

  it "Can create one item" do
    merchant = FactoryBot.create(:merchant)

    item_params = ({
                    name: "White Board",
                    description: "4 by 2 great quality",
                    unit_price: 17.99,
                    merchant_id: merchant.id
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(response.status).to eq(201)
  
    json_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(json_response[:data][:type]).to eq('item')
    expect(json_response[:data][:attributes][:name]).to eq(item_params[:name])
    expect(json_response[:data][:attributes][:description]).to eq(item_params[:description])
    expect(json_response[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
    expect(json_response[:data][:attributes][:merchant_id]).to eq(item_params[:merchant_id])
    
    expect(Item.count).to eq(1)
  end

  it "can delete one item" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)
    item3 = FactoryBot.create(:item, merchant: merchant)

    delete "/api/v1/items/#{item1.id}"

    expect(response).to be_successful
    expect(response.status).to eq (204)
    expect(response.body).to be_empty
    
    expect(Item.all).to eq([item2, item3])
  end

  it "can update one item" do
    merchant = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item, merchant: merchant)

    item_params = {
      name: "White Board",
      description: "4 by 2 great quality",
      unit_price: 17.99,
      merchant_id: merchant.id
    }

    headers = { "CONTENT_TYPE" => "application/json" }
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    item_updated = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful
    expect(response.status).to eq (200)

    expect(item_updated).to have_key(:id)
    expect(item_updated[:id]).to eq(item.id.to_s)
  
    expect(item_updated).to have_key(:type)
    expect(item_updated[:type]).to be_a(String) 

    expect(item_updated).to have_key(:attributes)

    expect(item_updated[:attributes][:name]).to be_a(String) 
    expect(item_updated[:attributes][:name]).to eq("White Board") 

    expect(item_updated[:attributes][:description]).to be_a(String) 
    expect(item_updated[:attributes][:description]).to eq("4 by 2 great quality")

    expect(item_updated[:attributes][:unit_price]).to be_a(Float) 
    expect(item_updated[:attributes][:unit_price]).to eq(17.99) 

    expect(item_updated[:attributes][:merchant_id]).to be_an(Integer)
    expect(item_updated[:attributes][:merchant_id]).to eq(item.merchant_id)
  end

  it "can get item's merchant" do
    merchant = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item, merchant: merchant)
    
    get "/api/v1/items/#{item.id}/merchant"

    merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful
    expect(response.status).to eq (200)

    expect(merchant_found).to have_key(:id)
    expect(merchant_found[:id]).to eq(merchant.id.to_s)
  
    expect(merchant_found).to have_key(:attributes)
    expect(merchant_found[:attributes][:name]).to eq(merchant.name)

    expect(merchant_found).to have_key(:type)
    expect(merchant_found[:type]).to be_a(String)
  end

  it 'can get items by searching keywords' do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, name: "Calendar", merchant: merchant)
    item2 = FactoryBot.create(:item, merchant: merchant)

    get "/api/v1/items/find_all?name=aleNd"

    item_found = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.status).to eq (200)
    
    expect(item_found.first).to have_key(:id)
    expect(item_found.first[:id]).to eq(item1.id.to_s)
  
    expect(item_found.first).to have_key(:type)
    expect(item_found.first[:type]).to be_a(String) 

    expect(item_found.first).to have_key(:attributes)

    expect(item_found.first[:attributes][:name]).to be_a(String) 
    expect(item_found.first[:attributes][:name]).to eq(item1.name) 

    expect(item_found.first[:attributes][:description]).to be_a(String) 
    expect(item_found.first[:attributes][:description]).to eq(item1.description)

    expect(item_found.first[:attributes][:unit_price]).to be_a(Float) 
    expect(item_found.first[:attributes][:unit_price]).to eq(item1.unit_price) 

    expect(item_found.first[:attributes][:merchant_id]).to be_an(Integer)
    expect(item_found.first[:attributes][:merchant_id]).to eq(item1.merchant_id)
  end

  it 'Can find all items by min price' do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant, unit_price: 1599)
    item2 = FactoryBot.create(:item, merchant: merchant, unit_price: 999)
    item3 = FactoryBot.create(:item, merchant: merchant, unit_price: 499)

    min_price = 999
    get "/api/v1/items/find_all?min_price=#{min_price}"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.status).to eq (200)

    expect(items_found.first[:attributes][:unit_price]).to eq (1599) 
    expect(items_found.first[:attributes][:unit_price]).to be >= min_price 
    
    expect(items_found[1][:attributes][:unit_price]).to eq (999) 
    expect(items_found[1][:attributes][:unit_price]).to be >= min_price

    expect(items_found.count).to eq(2)
  end

  it 'Can find all items by max price' do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, merchant: merchant, unit_price: 1599)
    item2 = FactoryBot.create(:item, merchant: merchant, unit_price: 999)
    item3 = FactoryBot.create(:item, merchant: merchant, unit_price: 499)

    max_price = 999
    get "/api/v1/items/find_all?max_price=#{max_price}"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.status).to eq (200)

    expect(items_found.first[:attributes][:unit_price]).to eq (999) 
    expect(items_found.first[:attributes][:unit_price]).to be <= max_price 
    
    expect(items_found[1][:attributes][:unit_price]).to eq (499) 
    expect(items_found[1][:attributes][:unit_price]).to be <= max_price

    expect(items_found.count).to eq(2)
  end

  it 'Can reject price searches less than 0' do
    min_price = -100
    get "/api/v1/items/find_all?min_price=#{min_price}"

    items_found = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it "Won't accept name and min price in the same search" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, name: "Calendar", merchant: merchant)
    min_price = 100

    get "/api/v1/items/find_all?name=aleNd&min_price=#{min_price}"

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it "Won't accept name and max price in the same search" do
    merchant = FactoryBot.create(:merchant)
    item1 = FactoryBot.create(:item, name: "Calendar", merchant: merchant)
    max_price = 100

    get "/api/v1/items/find_all?name=aleNd&max_price=#{max_price}"

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end
end