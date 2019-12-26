class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price1 
    product.price * quantity
  end
end
