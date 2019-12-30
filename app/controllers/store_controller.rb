class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
    
    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end

    @visit_counter = session[:counter]
  end
end
