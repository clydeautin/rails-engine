class Api::V1::ItemMerchantsController < ApplicationController
  def index
    item = Item.find(params[:item_id])
    render json: MerchantSerializer.format_merchant(Merchant.find(item.merchant_id))
  end
end