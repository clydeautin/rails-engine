class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  belongs_to :merchant

  def self.search(params)
    # binding.pry
    if params[:name] && (params[:min_price] || params[:max_price])
      # render json: {errors: 'Can not send price and keyword search in one query'}, status: :bad_request
      return {errors: 'Can not send price and keyword search in one query'}
      # raise ArgumentError::P
    elsif params[:min_price] || params[:max_price]
      self.search_by_price(params[:min_price], params[:max_price])
    elsif params[:name]
      self.find_by_name(params[:name])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def self.find_by_name(name)
    items = self.where("name ILIKE ?", "%#{name}%")
    raise ActiveRecord::RecordNotFound if items.empty?
    items
  end

  def self.search_by_price(min_price = 0, max_price = nil)
    # binding.pry
    error = validate_prices(min_price, max_price)
    return error if error
    if max_price.nil?
      self.where("unit_price >= ?", min_price)
    elsif min_price.nil?
      self.where("unit_price <= ?", max_price)
    else
      # binding.pry
      items = self.where("unit_price >= ? AND unit_price <= ?", min_price, max_price)
    end
  end

  def self.validate_prices(min_price = 0, max_price = 0)
    return {errors:'Price cannot be negative'} if min_price.to_i < 0 || max_price.to_i < 0
  end

  def self.find_by_min_price(min_price)
    self.where("unit_price >= #{min_price}")
  end

  def self.find_by_max_price(min_price)
    self.where("unit_price <= #{min_price}")
  end

  # def self.mixed_params
  #   if statement
  # end
end