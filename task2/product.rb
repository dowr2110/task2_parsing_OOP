class Product
  attr_accessor :name, :price, :image

  def initialize(name, price, image)
    @name = name
    @price = price
    @image = image
  end

  def to_s
    [@name, @price, @image].join(', ')
  end
end
