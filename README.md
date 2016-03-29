# PhoneBuzz
A Sinatra app using Ruby and TwiML to play FizzBuzz over the phone.

##Setup
To run this project locally, download the files and set three variables in `app.rb`. Replace all characters after the `=` with your own Twilio account credentials.

```ruby
TWILIO_ACCOUNT_SID=ACXXXXXXXXX
TWILIO_AUTH_TOKEN=XXXXXXXXX
TWILIO_NUMBER=+13478365066
```
In terminal, type `ruby app.rb` to run the Sinatra app. In another terminal window, type `ngrok http 4567` and then copy the fowarding url generated with the `ngrok.io` ending. This will expose the local web server to the internet.

Go back to `app.rb` file and underneath `post 'call' do`, there is a `:url` parameter. After the `=>`, replace the existing url with your own ngrok.io url.

##Phase 1: Simple TwiML PhoneBuzz
Direct your Twilio phone number to the url generated by ngrok, and use HTTP GET request type under the Voice section. Call my demo Twilio number at +1 (347) 836-5066 or your Twilio number if you used your own instead. A voice prompt will ask you to input a number between 1-99, followed by the '#' symbol.

##Phase 2: Dialing PhoneBuzz
Enter your phone number in the text field to receive a new call. Since this is a demo account, your number might be whitelisted and not called. Leave the second text field with its default value of 0 seconds.

##Phase 3: Delayed PhoneBuzz
Go to https://phonebuzz-1.herokuapp.com/. Same instructions as in Phase 2 but this time, you can add a custom delay (in seconds) to when the Twilio number will call you.

##Phase 4: Tracking PhoneBuzz
The history section contains the last 10 calls made from this Twilio Number. The table contains a timestamp of when the calls were made, the number called, what the delay was, and the fizzbuzz number entered by the user. There is also an option to replay a call, with the original fizzbuzz number entered. If a call ended before a fizzbuzz number was entered, the user will be directed to enter a new number.
