class OrderItem
  
  attr_accessor :item_id, :price, :quantity, :description, :adcode, :category
  
  def initialize(item_id, price, quantity, description, adcode, category)
    @item_id = item_id
    @price = price
    @quantity = quantity
    @description = description
    @adcode = adcode
    @category = category    
  end
  
  def to_hash
    {
      item_id: @item_id,
      price: @price,
      quantity: @quantity,
      description: @description,
      adcode: @adcode,
      category: @category
    }
  end
end