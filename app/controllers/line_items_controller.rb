class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    # find product based on ID passed in as param of post req
    product = Product.find(params[:product_id])
    
    # build a line item in current cart based on selected product
    @line_item = @cart.add_product(product)
    # @line_item = @cart.line_items.build(product_id: product.id)

    # reset counter upon user adding something to cart
    session[:counter] = 0

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url }
        format.js   { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    # noting down the cart before we remove the line_item
    curr_cart = @line_item.cart

    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path(curr_cart), notice: 'Successfully removed item from your cart.' }
      format.json { head :no_content }
    end
  end

  # PUT /line_items
  # PUT /line_items.json
  def quantity
    @cart = Cart.find(session[:cart_id])
    @line_item = LineItem.find(params[:id])
    if params[:increment]
      @line_item = @cart.add_product(@line_item.product)
      if @line_item.save
        respond_to do |format|
          format.html { redirect_to store_path, notice: 'Line item was successfully increased.' }
          format.js { @current_item = @line_item }
          format.json { head :ok }
        end
      end
    else
      if @line_item.quantity > 1
        @line_item.quantity -= 1
        if @line_item.save
          respond_to do |format|
            format.html { redirect_to store_path, notice: 'Line item was successfully decreased.' }
            format.js { @current_item = @line_item }
            format.json { head :ok }
          end
        end
      else
        @line_item.destroy
        respond_to do |format|
          format.html { redirect_to store_path, notice: 'Line item was successfully destroyed.' }
          format.js { @current_item = @line_item }
          format.json { head :ok }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
