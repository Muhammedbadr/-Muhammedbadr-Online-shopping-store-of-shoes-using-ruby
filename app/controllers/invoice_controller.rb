class InvoiceController < ApplicationController
    def index
    end
    def create
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        event = nil

        begin
            event = Stripe::Webhook.construct_event(
                payload, sig_header, Rails.application.credentials[:stripe][:webhook]
            )
        rescue JSON::ParserError => e
            head 400
            return
        rescue Stripe::SignatureVerificationError => e
            head 400
            return
        end

        case event.type
        when 'payment_intent.succeeded'
            intent = event['data']['object']
            product_ids = intent["metadata"]["product_ids"].split(", ")
            user_id = intent["metadata"]["user_id"]
            product_ids.each do |product_id|
                Invoice.create(user_id: user_id, product_id: product_id, amount: Product.find(product_id).price)
            end
        else
            puts "Unhandled event type: #{event.type}"
        end

        head 200
    end

end
