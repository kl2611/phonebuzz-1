# PhoneBuzz
A Sinatra app using Ruby and TwiML to play FizzBuzz over the phone.

##Setup
If you want to run this project locally, download the files and set three variables in `app.rb`. Replace all characters after the `=` with your own Twilio account credentials.

```ruby
TWILIO_ACCOUNT_SID=ACXXXXXXXXX
TWILIO_AUTH_TOKEN=XXXXXXXXX
TWILIO_NUMBER=+13478365066
```

##Phase 1: Simple TwiML PhoneBuzz
Direct your Twilio phone number to https://phonebuzz-1.herokuapp.com/phonebuzz, and use HTTP GET request type. Call my demo Twilio number at +1 (347) 836-5066. A voice prompt will ask you to input a number between 1-99, followed by the '#' symbol.

##Phase 2: Dialing PhoneBuzz
Go to https://phonebuzz-1.herokuapp.com/. Enter your phone number in the text field to receive a new call. Since this is a demo account, your number might be whitelisted and not called. Leave the second text field with its default value of 0 seconds.

##Phase 3: Delayed PhoneBuzz
Go to https://phonebuzz-1.herokuapp.com/. Same instructions as in Phase 2 but this time, you can add a custom delay (in seconds) to when the Twilio number will call you.

##Phase 4: Tracking PhoneBuzz
The history section contains the last 10 calls made from this Twilio Number. The table contains a timestamp of when the calls were made, the number called, what the delay was, and the fizzbuzz number entered by the user. There is also an option to replay a call, with the original fizzbuzz number entered. If a call ended before a fizzbuzz number was entered, the user will be directed to enter a new number.
