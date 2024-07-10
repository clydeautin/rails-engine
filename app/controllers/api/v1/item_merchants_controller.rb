class Api::V1::ItemMerchantsController < ApplicationController
  def index
    item = Item.find(params[:item_id])
    if item
      render json: MerchantSerializer.format_merchant(item.merchant)
    else
      render json: "Item not found", status: :not_found
    end
  end
end