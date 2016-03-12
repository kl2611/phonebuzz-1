$(document).ready(function() {
  form.init();
});

form = {
  messageToUser: null,
  phoneInput: null,
  twilioAccountNum: 'AC9493d6fa9f0617ca80fea8f92caac281',

  init: function() {
    this.messageToUser = $('.message-to-user');
    this.phoneInput = $('.phone-num-form input[type="tel"]');
    $('.phone-num-form input[type="submit"]').click(form.handleSubmit);
  },

  handleSubmit: function(e) {
    e.preventDefault();
    form.showActivelyValidating();
    var input = form.phoneInput.val();
    form.validate(input);
  },

  showActivelyValidating: function() {
    form.messageToUser.removeClass('invalid');
    form.messageToUser.removeClass('valid');
    form.messageToUser.addClass('validating');
    form.messageToUser.text('Validating...');
  },

  validate: function(input) {
    var numbers = this.getNumbersFromInput(input);
    var numString = numbers.join('');
    if (numString.length == 10) {
      form.isValid(numString);
    } else {
      form.isInvalid();
    }
  },

  getNumbersFromInput: function(input) {
    var numbers = $.map(input.split(''), function(n) {
      n = (parseInt(n, 10));
      if (isNaN(n)) {
        return '';
      } else {
        return n + ''; // convert back to string
      }
    });
    return numbers;
  },

  isValid: function(numString) {
    this.removeInputText();
    this.messageToUser.removeClass('validating');
    this.messageToUser.addClass('valid');
    this.messageToUser.text('Thanks! You\'ll receive a phone call shortly.');
    this.submitNumber('+1' + numString);
  },

  isInvalid: function() {
    this.removeInputText();
    this.messageToUser.removeClass('validating');
    this.messageToUser.addClass('invalid');
    this.messageToUser.text('Sorry, that wasn\'t valid. Please enter a ten-digit phone number.');
  },

  removeInputText: function() {
    this.phoneInput.val('');
  },

  submitNumber: function(number) {
    $.ajax({
      type: "POST",
      url: "/call",
      data: {
        numToCall: number
      }
    })
    .fail(form.alertUserOfAJAXFail);
  },

  alertUserOfAJAXFail: function() {
    form.messageToUser.removeClass('valid');
    form.messageToUser.addClass('invalid');
    form.messageToUser.text('Oops! Your number was valid, but we couldn\'t set up your call. Please try again later.')
  }
};
