require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

get '/hello' do
    Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/hello/phonebuzz", :method => 'get' do |s|
            s.Say 'Please enter a number followed by the pound sign'
        end
    end.text
end

get '/hello/phonebuzz' do
    input = params['Digits'].to_i
    redirect '/hello' unless (input >= 1 && input <= 999)
    Twilio::TwiML::Response.new do |r|
        input.times do |i|
            current = i +
            if current % 15 == 0
                r.Say = "fizzbuzz"
            elsif current % 3 == 0
                r.Say "fizz"
            elsif current % 5 == 0
                r.Say "buzz"
            else
                r.Say "#{current}"
            end
        end
    end.text
end
