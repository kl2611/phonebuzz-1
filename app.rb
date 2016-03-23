require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'sinatra/activerecord'
require './config/environments'
require './models/model'
require './models/post'

TWILIO_ACCOUNT_SID = "AC920d215c2e2e2423c0c410a59fdcb1b0"
TWILIO_AUTH_TOKEN = "38ca49247f7fd660d1967f28e944d7ca"
TWILIO_NUMBER="+13478365066"

set :bind, '0.0.0.0'
set :port, ENV['TWILIO_STARTER_RUBY_PORT'] || 4567

client = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN

get '/' do
  erb :index
end

get '/phonebuzz' do
    response = Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/phonebuzz/start", :method => 'get' do |g|
            g.Say 'Enter a number from 1 to 99 followed by the pound sign'
        end
    end

  #render TwiML (XML) document
  content_type 'text/xml'
  response.text
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

# post '/receive_sms' do
#   content_type = 'text/xml'
#   response = Twilio::TwiML::Response.new do |r|
#     r.Message 'Hey thanks for messaging me!'
#   end
#   response.to_xml
# end

# get '/token' do
#   capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
#   capability.allow_client_outgoing 'AP5e447921b4e075c1e5610ce59b820f65'
#   capability.generate
# end

# get '/sms' do
#   response = Twilio::TwiML::Response.new do |r|
#     r.Message('Thanks for texting')
#   end
#   content_type 'text/xml'
#   response.text
# end

post '/call' do
  client.account.calls.create(
    :from => TWILIO_NUMBER,
    :to => params[:to],
    :url => 'http://ebf8a765.ngrok.io/phonebuzz',
    :method => 'GET'
  )

  'Call is inbound!'
end

post '/submit' do
  @post = Post.new(params[:post])
  if @post.save
    redirect '/posts'
  else
    "Sorry, there was an error!"
  end
end

get '/posts' do
  @posts = Post.all
  erb :posts
end

get '/calls' do
  @calls = client.account.calls.list({
      :status => "completed",
    })

  erb :calls
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end
