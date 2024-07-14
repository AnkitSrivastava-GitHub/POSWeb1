// Function that display value
function dis(val) {
    debugger;
    var Header = $('#Cal_Head').text();
    var DiscType = $("input[name='DiscType']:checked").val();
    
    if (((($("#result").val().trim().length > 5 && DiscType == 'Fixed') || (parseFloat($("#result").val().trim()) > 100 && DiscType == 'Per')) && Header == 'Discount') || (Header != 'Discount' && $("#result").val().trim().length > 5)) {
        
    }
    else { 
        var str = $("#result").val();
        if (str.includes(".") && val == ".") {
            return;
        }
        else {
            document.getElementById("result").value += val
        }
    }
    if ((parseFloat($("#result").val().trim()) > 100 && DiscType == 'Per') && Header == 'Discount') {
        $("#result").val('');
    }
}

function myFunction(event) {
    debugger;

    if ($("#result").val().trim().length > 5) {
        //$("#Result").val($("#Result").val().trim());
    }
    else {
        if (event.key == '0' || event.key == '1'
            || event.key == '2' || event.key == '3'
            || event.key == '4' || event.key == '5'
            || event.key == '6' || event.key == '7'
            || event.key == '8' || event.key == '9'
            || event.key == '+' || event.key == '-'
            || event.key == '*' || event.key == '/')
            document.getElementById("result").value += event.key;
    }
}

var cal = document.getElementById("calcu");
cal.onkeyup = function (event) {
    if (event.keyCode === 13) {
        console.log("Enter");
        let x = document.getElementById("result").value
        console.log(x);
        solve();
    }
}

$("#result").keypress(function (e) {
    debugger;
    // Check if the value of the input is valid
    if (!valid)
        e.preventDefault();
});
//$('#result').keyup(function () {
//    var $th = $(this);
//    $th.val($th.val().replace(/[^a-zA-Z0-9]/g, function (str) { alert('You typed " ' + str + ' ".\n\nPlease use only letters and numbers.'); return ''; }));
//});

// Function that evaluates the digit and return result
function solve() {
    let x = document.getElementById("result").value
    let y = math.evaluate(x)
    document.getElementById("result").value = y
}

// Function that clear the display
function clr() {
    document.getElementById("result").value = ""
}