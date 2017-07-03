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

var initialize_game = function(attempts_var, hints_var){
    $.ajax({
        type: "POST",
        url: '/playing',
        data: {attempts: attempts_var,
               hints: hints_var},
        success: function(data) {
            console.log(data)
            $('.terminal-div').empty();
            $('.terminal-div').append(data);
            //$('#check-code').click(check_guess);
            $('#guess').bind('keypress keydown keyup', function(e){
                if(e.keyCode == 13) { e.preventDefault(); }
            });
            $('#guess').focus(function() { $(this).val('') });
        }
    });
};

var check_guess = function () {
    var guess = $('#guess').val();
    if(/([1-6]){4}/.test(guess)) {
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
    else {
        $('#answer-render').empty();
        $('#answer-render').append('Please enter only 4 numbers from 1 to 6 (e.g. 1234)');
    }
}

var hint = function () {
    if($('#hints-render').html() == 0) {
        $('#answer-render').empty();
        $('#answer-render').append('Sorry, but you don\'t have hints enough :(');
        return;
    }
    $.ajax({
        type: "GET",
        dataType: "json",
        url: '/hint',
        success: function(data) {
            $('#answer-render').empty();
            $('#answer-render').append('Your hint is: ' + data.hint);
            $('#hints-render').empty();
            $('#hints-render').append(data.hints);
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
