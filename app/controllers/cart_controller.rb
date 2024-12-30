class CartController < ApplicationController
    def index 
        @products = Product.where(id: session[:cart])
        @products_count = @products.length()
        @total_price = @products.sum{|product| product.price}
    end
    def add_to_cart
        # Add item to the cart
        if session[:cart] == nil
            session[:cart] = []
        end
        session[:cart].push(params[:product_id])
    end
end
