class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    render json: MerchantSerializer.format_merchant(Merchant.find(params[:id]))
  end

  def find
    merchant = Merchant.find_by_name(params[:name])
    if merchant
      render json: MerchantSerializer.format_merchant(merchant), status: :ok
    else
        # passing, should probably refactor after wednesday error handling class
      render json: { data: {error: 'Merchant not found'} }, status: :not_found
    end
  end
end