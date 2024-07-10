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
    if item.destroy
      render json: ItemSerializer.new(item)
    else
      render json: { error: item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find(params[:id])
    if params[:merchant_id] && Merchant.find(params[:merchant_id]).nil?
      render json: { error: "Merchant not found" }, status: :not_found
    elsif item.update(item_params)
        render json: ItemSerializer.new(item)
    else
      # should probably refactor after wed class
      render json: { error: item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def find_all
    if params[:name] && !params[:min_price] && !params[:max_price]
      items = Item.find_by_name(params[:name])
      if items
        render json: ItemSerializer.format_items(items), status: :ok
      else
        # passing, should probably refactor after wednesday error handling class
        render json: { data: {errors: 'No items found'} }, status: :not_found
      end
    elsif params[:min_price] && !params[:name] && !params[:max_price]
      items = Item.find_by_min_price(params[:min_price])
      if items && params[:min_price].to_i >= 0
        render json: ItemSerializer.format_items(items), status: :ok
      else
        # passing, should probably refactor after wednesday error handling class // bad_request = 400 error, not_found = 404
      render json: {errors: 'Price cannot be negative'}, status: :bad_request
      end
    elsif params[:max_price] && !params[:name] && !params[:min_price]
      items = Item.find_by_max_price(params[:max_price])
      if items && params[:max_price].to_i >= 0
        render json: ItemSerializer.format_items(items), status: :ok
      else
      render json: {errors: 'Price cannot be negative'}, status: :bad_request
      end
    else
      render json: {errors: 'Can not send price and keyword search in one query'}, status: :bad_request
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
