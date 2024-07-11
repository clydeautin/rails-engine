class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render json: ItemSerializer.format_items(items)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  def update
    item = Item.find(params[:id])
    Merchant.find(params[:merchant_id]) if params[:merchant_id] 
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: 404
    end
  end

  def find_all
    items = Item.search(params)
    if items.is_a?(ActiveRecord::Relation)
      render json: ItemSerializer.format_items(items), status: :ok
    else
      render json: { errors: items[:errors] }, status: :bad_request
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
