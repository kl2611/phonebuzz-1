require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# get '/hello-monkey' do
#   Twilio::TwiML::Response.new do |r|
#     r.Say 'Hello Monkey'
#   end.text
# end

enable :sessions

get '/sms-quickstart' do
    Twilio::TwiML::Response.new do |r|
        r.Say "Hello Monkey! You will get a text soon"
        r.Sms "Here it is!"
    end.text
end
