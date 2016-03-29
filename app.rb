require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'sinatra/activerecord'
require './config/environments'
require './models/post'
require 'dotenv'

set :bind, '0.0.0.0'
set :port, ENV['TWILIO_STARTER_RUBY_PORT'] || 4567

Dotenv.load
use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/phonebuzz', '/phonebuzz/start'

client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

get '/' do
  @calls = client.account.calls.list({
    :status => "completed"
  })

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

  @post = Post.last
  @post.fizzbuzz = input
  @post.save

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

post '/call' do
  client.account.calls.create(
    :from => ENV['TWILIO_NUMBER'],
    :to => params[:to],
    :url => 'http://07fca444.ngrok.io/phonebuzz',
    :method => 'GET'
  )

  @post = Post.new(:phone => params[:to], :delay => params[:delay])
  @post.save

  'Call is inbound!'
end

get '/replay/:phone/:delay/:fizzbuzz' do
  sleep (params['delay'].to_i)

  client.account.calls.create(
    :from => ENV['TWILIO_NUMBER'],
    :to => params['phone'],
    :url => 'http://07fca444.ngrok.io/replay/start',
    :method => 'GET'
  )

  @post = Post.new(:phone => params['phone'], :delay => params['delay'], :fizzbuzz => params['fizzbuzz'])
  @post.save
end

get '/replay/start' do
  @post = Post.last
  input = @post.fizzbuzz
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
