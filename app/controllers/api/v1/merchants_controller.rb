class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    render json: MerchantSerializer.format_merchant(Merchant.find(params[:id]))
  end

  def find
    if params[:name].nil? || params[:name] == ""
      render json: { data: {}, errors: [{title: "Bad Request, No name parameter", status: "400"}] }, status: :bad_request
    else
      merchant = Merchant.find_by_name(params[:name])
      if merchant
        render json: MerchantSerializer.format_merchant(merchant), status: :ok
      else
        render json: { data: {}, errors: [{title: "Couldn't find Merchant with 'name'=#{params[:name]}", status: "404"}] }, status: :not_found
      end
    end
  end
end