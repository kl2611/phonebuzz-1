function showFlash(message) {
    $('#flash span').html(message);
    $('#flash').show();
}

$('form button').on('click', function(e) {
    e.preventDefault();

    var delay = $('#delay').val() * 1000;

    var url = '/call';
    setTimeout(function() {
        $.ajax(url, {
            method:'POST',
            dataType:'text',
            data:{
                to:$('#to').val(),
                delay:$('#delay').val()
            },
            success: function(data) {
                showFlash(data);
            },
            error: function(jqxhr) {
                alert('There was an error sending a request to the server :(');
            }
        });
    }, delay);
});
