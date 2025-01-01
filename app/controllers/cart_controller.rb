class CartController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
  
    def index
      @products = Product.where(id: session[:cart])
      @products_count = @products.length()
      @total_price = @products.sum {|product| product.price}
    end
  
    def add_to_cart
      if session[:cart] == nil
        session[:cart] = []
      end
      session[:cart].push(params[:product_id])
    end
  
    def create_payment_intent
      cart = session[:cart]
      products = Product.where(id: cart)
  
      payment_intent = Stripe::PaymentIntent.create(
        amount: 100 * products.sum {|product| product.price.round()},
        currency: 'usd',
        automatic_payment_methods: {
          enabled: true,
        },
        metadata: {
          product_ids: cart.join(', '),
          user_id: current_user.id
        }
      )
      session.delete(:cart)
      render plain: payment_intent['client_secret']
    end
  end