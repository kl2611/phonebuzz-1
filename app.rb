require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'sinatra/activerecord'
require './config/environments'
require './models/post'
require 'dotenv'

Dotenv.load
#This validates the X-Twilio-Signature header so only Twilio numbers can interact with these URLs
use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/phase1', '/phase1/start', '/phonebuzz', '/phonebuzz/start'

client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

get '/' do
  @calls = client.account.calls.list({
    :status => "completed"
  })

  erb :index
end

get '/phase1' do
    response = Twilio::TwiML::Response.new do |r|
        r.Gather :finishOnKey => "#", :action => "/phase1/start", :method => 'get' do |g|
            g.Say 'Enter a number from 1 to 99 followed by the pound sign'
        end
    end

  #render TwiML (XML) document
  content_type 'text/xml'
  response.text
end

get '/phase1/start' do
  input = params['Digits'].to_i
  redirect '/phase1' unless (input >= 1 && input <= 99)

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
    :url => 'https://phonebuzz-1.herokuapp.com/phonebuzz',
    :method => 'GET'
  )

  @post = Post.new(:phone => params[:to], :delay => params[:delay], :fizzbuzz => 0)
  @post.save

  'Call is inbound!'
end

get '/replay/:phone/:delay/:fizzbuzz' do
  sleep (params['delay'].to_i)

  client.account.calls.create(
    :from => ENV['TWILIO_NUMBER'],
    :to => params['phone'],
    :url => 'https://phonebuzz-1.herokuapp.com/replay/start',
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
