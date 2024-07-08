class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    # binding.pry
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    render json: MerchantSerializer.format_merchant(Merchant.find(params[:id]))
    
  end
end