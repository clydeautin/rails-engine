class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_by_name(name)
    items = self.where("name ILIKE ?", "%#{name}%")
    raise ActiveRecord::RecordNotFound if items.empty?
    items
  end

  def self.find_by_min_price(min_price)
    self.where("unit_price >= #{min_price}")
  end

  def self.find_by_max_price(min_price)
    self.where("unit_price <= #{min_price}")
  end
end