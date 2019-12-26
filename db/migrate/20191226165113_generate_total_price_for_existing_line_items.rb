class GenerateTotalPriceForExistingLineItems < ActiveRecord::Migration[6.0]
  def up
    # replace multiple items for a single product in a cart with a single item 
    LineItem.all.each do |item|
        item.total_price = item.product.price * item.quantity
        item.save!
    end 
  end
end
