class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    # binding.pry
    render json: ItemSerializer.format_items(items)
  end
end