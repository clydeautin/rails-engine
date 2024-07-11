class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(name)
    # binding.pry
    self.where("name ILIKE ?", "%#{name}%")
        .order(name: :asc)
        .first
  end
end