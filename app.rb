require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# get '/hello-monkey' do
#   Twilio::TwiML::Response.new do |r|
#     r.Say 'Hello Monkey'
#   end.text
# end

get '/sms-quickstart' do
  sender = params[:From]
  friends = {
    "+13043765973" => "Kelly"
  }
  name = friends[sender] || "Mobile Monkey"
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Hello, #{name}. Thanks for the message."
  end
  twiml.text
end
