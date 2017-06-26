/**
 * Created by kh0ma on 25.06.17.
 */

var input = $('#main-input');

var bad_command = "Bad command. Please enter '/start' for start a game"



input.focus();
$('body').on('click', function(e){
    input.focus();
});

input.bind('keypress keydown keyup', function(e){
    if(e.keyCode == 13) { e.preventDefault(); }
});

input.keyup(function(e){
    e.preventDefault();
    if(e.keyCode == 13){
        var command = $('#main-input').val();
        console.log(command);
        render(command);
        if(command == '/start') {
            start_game()
        }
        else {
            render(bad_command);
        }
        $('#main-input').val('');
    }
});

var start_game = function(){
    $.ajax({
        type: "GET",
        url: '/attempts',
        data: null,
        success: function(data) {
            console.log(data)
            $('.terminal-div').empty();
            $('.terminal-div').append(data);
        }
    });
};

var set_attempts = function(attempts_var){
    $.ajax({
        type: "POST",
        url: '/playing',
        data: {attempts: attempts_var},
        success: function(data) {
            console.log(data)
            $('.terminal-div').empty();
            $('.terminal-div').append(data);
            $('#check-code').click(check_guess);
            $('#guess').bind('keypress keydown keyup', function(e){
                if(e.keyCode == 13) { e.preventDefault(); }
            });
            $('#guess').focus(function() { $(this).val('') });
        }
    });
};

var check_guess = function () {
    var guess = $('#guess').val();
    $.ajax({
        type: "GET",
        dataType: "json",
        url: '/check',
        data: {guess: guess},
        success: function(data) {
            if(data.answer=='++++' || data.attempts==0) {
                play_again(data.answer=='++++');
            }
            $('#answer-render').empty();
            $('#answer-render').append('The answer is: '+data.answer);
            $('#attempts-render').empty();
            $('#attempts-render').append(data.attempts);
        }
    });
}

var play_again = function (win) {
    $.ajax({
        type: "GET",
        url: '/play_again',
        success: function(data) {
            $('.terminal-div').empty();
            $('.terminal-div').append(data);
            var message = win? 'Congratulations. You win ;)' : 'Sorry. But you lose :('
            $('#game-message').append(message)
        }
    });
}

var render = function (message) {
    $('#terminal-bash').before('<p>' + message + '</p>');
    if($('.terminal').children('p').length > 20) $('.terminal').children('p')[0].remove();
}
