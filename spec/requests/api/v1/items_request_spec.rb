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
    # require 'pry'; binding.pry
    expect(response.status).to eq(201)
  
    json_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(json_response[:data][:type]).to eq('item')
    expect(json_response[:data][:attributes][:name]).to eq(item_params[:name])
    expect(json_response[:data][:attributes][:description]).to eq(item_params[:description])
    expect(json_response[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
    expect(json_response[:data][:attributes][:merchant_id]).to eq(item_params[:merchant_id])
    
    expect(Item.count).to eq(1)
  end
end