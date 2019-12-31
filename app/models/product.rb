class Product < ApplicationRecord
    has_many :line_items
    has_many :orders, through: :line_items
    
    before_destroy :ensure_not_referenced_by_any_line_item

    validates :title, :description, :image_url, presence: true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates :title, uniqueness: {unique: true}
    validates :image_url, allow_blank: true, format: {
        with: %r{\.(gif|jpg|png)\Z}i,
        message: 'must be a URL for GIF, JPG or PNG image.' 
    }
    validates :title, length: {minimum: 10, message: 'Minimum ten characters pls.'}

    def self.latest
        Product.order(:updated_at).last
    end

    class Error < StandardError
    end

    private 
        # ensure that there are no line items referencing this product
        def ensure_not_referenced_by_any_line_item
            unless line_items.empty?
                raise Error.new "This product belongs in a cart."
                # errors.add(:base, 'Line Items present')
                # throw :abort
            end
        end
end
