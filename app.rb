require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# get '/hello' do
#     Twilio::TwiML::Response.new do |r|
#         r.Gather :finishOnKey => "#", :action => "/hello/phonebuzz", :method => 'get' do |s|
#             s.Say 'Please enter a number followed by the pound sign'
#         end
#     end.text
# end

get '/hello' do

  # number = params['Digits'].to_i
  number = 25
  redirect '/hello' unless (number >= 1 && number <= 999)
  Twilio::TwiML::Response.new do |r|
    number.times do |i|
      curr_num = i + 1
      if curr_num % 15 == 0
        r.Say "fizz buzz"
      elsif curr_num % 5 == 0
        r.Say "buzz"
      elsif curr_num % 3 == 0
        r.Say "fizz"
      else
        r.Say "#{curr_num}"
      end
    end
  end.text
end
