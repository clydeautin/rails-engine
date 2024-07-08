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
end