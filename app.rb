require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

#PHONEBUZZ PHASE 1

get '/' do
    Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/phonebuzz", :method => 'get' do |g|
            g.Say 'Enter a number from 1 to 99 followed by the pound sign'
        end
    end.text
end

get '/phonebuzz' do
  input = params['Digits'].to_i
  redirect '/' unless (input >= 1 && input <= 99)
  Twilio::TwiML::Response.new do |r|
    input.times do |i|
      count = i + 1
      if count % 15 == 0
        r.Say "fizz buzz"
      elsif count % 5 == 0
        r.Say "buzz"
      elsif count % 3 == 0
        r.Say "fizz"
      else
        r.Say "#{count}"
      end
    end
  end.text
end


