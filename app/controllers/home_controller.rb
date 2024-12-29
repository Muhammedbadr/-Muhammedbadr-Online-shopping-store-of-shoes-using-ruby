class HomeController < ApplicationController 
    def index 
        @categories = Category.all()
        products = Product.all()
        size = request.query_parameters["size"]
        category_id = request.query_parameters["category"]
        price = request.query_parameters["price"]
        products = products.where(size: size ) if size != nil
        products = products.where(category_id: category_id ) if category_id != nil
            if price == "1"
                products = products.where("price < ? " , 50)
            elsif price == "2"
                products = products.where("price  < ?", 300)
            else price == "3"
                products = products.where("price  > ?", 300)
            end
        @products = products
    end 
end