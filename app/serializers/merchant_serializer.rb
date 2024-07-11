class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  has_many :items

  def self.format_merchants(merchants)
    {data:
      merchants.map do |merchant|
        {
          id: merchant.id,
          attributes: {
            id: merchant.id,
            name: merchant.name,
          }
        }
      end
    }
  end

  def self.format_merchant(merchant)
    {
      data: {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: {
          name: merchant.name
        }
      }
    }
  end
end