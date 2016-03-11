require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# get '/hello-monkey' do
#   Twilio::TwiML::Response.new do |r|
#     r.Say 'Hello Monkey'
#   end.text
# end

get '/sms-quickstart' do
    twiml = Twilio::TwiML::Response.new do |r|
        r.Message do |message|
        message.Body "Body"
        message.Media "https://demo.twilio.com/owl.png"
        message.Media "https://demo.twilio.com/logo.png"
        end
    end
    twiml.text
end
