class Position
  attr_reader :id, :price, :quantity

  def initialize(attrs)
    @id = attrs["id"]
    @price = attrs["price"]
    @quantity = attrs["quantity"]
  end
end