require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# get '/hello-monkey' do
#   Twilio::TwiML::Response.new do |r|
#     r.Say 'Hello Monkey'
#   end.text
# end

enable :sessions

get '/hello' do
    Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/hello/phonebuzz", :method => 'get' do |s|
            s.Say 'Please enter a number followed by the pound sign'
        end
    end.text
end

get '/hello/phonebuzz' do
    input = params['Digits'].to_i
    Twilio::TwiML::Response.new do |r|
        input.times do |i|
            if i % 15 == 0
                r.Say = "fizzbuzz"
            elsif i % 3 == 0
                r.Say "fizz"
            elsif i % 5 == 0
                r.Say "buzz"
            else
                r.Say "#{i}"
            end
        end
    end.text
end
