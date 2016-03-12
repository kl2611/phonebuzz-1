require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'dotenv'

Dotenv.load

#PHONEBUZZ PHASE 1

# call = @client.calls.create(
#     :url => "http://demo.twilio.com/docs/voice.xml",
#     :to => "+13043765973",
#     :from => "+15005550006") #Magic number
# puts call.sid

# def valid_request?
#   validator = Twilio::Util::RequestValidator.new('0bec4f2cef51865b25caabb53c604683')
#   uri = 'http://localhost:4567/'
#   post_vars = {}
#   signature = env['HTTP_X_TWILIO_SIGNATURE']
#   if validator.validate uri, params, signature
#     puts "Confirmed to have come from Twilio"
#   else
#     puts "NOT VALID"
#   end
# end

# def invalid
#   redirect '/error'
# end

# get 'error' do
#   Twilio::TwiML::Response.new do |r|
#       r.Say 'Invalid input'
#   end.text
# end

# ['/', '/phonebuzz/*'].each do |path|
#   before path do
#     invalid unless valid_request?
#   end
# end

get '/' do
  erb :index
end

get '/phonebuzz' do
    Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/phonebuzz/start", :method => 'get' do |g|
            g.Say 'Enter a number from 1 to 99 followed by the pound sign'
        end
    end.text
end

get '/phonebuzz/start' do
  input = params['Digits'].to_i
  redirect '/phonebuzz' unless (input >= 1 && input <= 99)
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

post '/receive_sms' do
  content_type = 'text/xml'
  response = Twilio::TwiML::Response.new do |r|
    r.Message 'Hey thanks for messaging me!'
  end
  response.to_xml
end

get '/token' do
  capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  capability.allow_client_outgoing 'AP5e447921b4e075c1e5610ce59b820f65'
  capability.generate
end

post '/call' do
client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  call = client.calls.create(
      url: "https://phonebuzz-1.herokuapp.com/phonebuzz",
      to:  "params['numToCall']",
      from: "+13478365066",
      method: "get"
    )
end
