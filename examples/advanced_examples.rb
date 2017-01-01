require_relative './examples_helper'
require 'study'

def main
  run_example "Nested Example: PayPal Payment History" do
    require 'paypal-sdk-rest'

    print "Enter Sandbox PayPal Client ID: "
    paypal_client_id = gets.chomp

    print "Enter Sandbox PayPal Client Secret: "
    paypal_client_secret = gets.chomp

    PayPal::SDK.configure(
      :mode => "sandbox",
      :client_id => paypal_client_id,
      :client_secret => paypal_client_secret,
      :ssl_options => { } 
    )

    payment_history = PayPal::SDK::REST::Payment.all(count: 3)

    study(payment_history)
    study(payment_history, plain: true)
  end
end

main