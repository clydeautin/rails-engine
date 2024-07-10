class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_by_name(name)
    self.where("name ILIKE ?", "%#{name}%")
  end
end