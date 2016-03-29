require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'sinatra/activerecord'
require './config/environments'
require './models/post'

TWILIO_ACCOUNT_SID = "AC920d215c2e2e2423c0c410a59fdcb1b0"
TWILIO_AUTH_TOKEN = "38ca49247f7fd660d1967f28e944d7ca"
TWILIO_NUMBER="+13478365066"

set :bind, '0.0.0.0'
set :port, ENV['TWILIO_STARTER_RUBY_PORT'] || 4567

client = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN

get '/' do
  client = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
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
    :from => TWILIO_NUMBER,
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
    :from => TWILIO_NUMBER,
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

get '/calls' do
  @calls = client.account.calls.list({
      :status => "completed"
    })

  erb :calls
end

