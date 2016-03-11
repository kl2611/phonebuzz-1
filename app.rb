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
    r.Message "Hey Monkey. Thanks for the message!"
  end
  twiml.text
end
