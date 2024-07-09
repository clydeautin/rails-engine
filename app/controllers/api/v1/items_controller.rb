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
end