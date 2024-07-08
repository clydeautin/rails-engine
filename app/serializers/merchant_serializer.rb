class MerchantSerializer
  def self.format_merchants(merchants)
    {data:
      merchants.map do |merchant|
        {attributes: {
          id: merchant.id,
          name: merchant.name,
        }}
      end
    }
  end

  def self.format_merchant(merchant)
    {
      data: {
        type: 'merchant',
        id: merchant.id.to_s,
        attributes: {
          name: merchant.name
        }
      }
    }
  end
end