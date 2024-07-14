
function goBack() {
    window.history.back();
}
function preventBackspace(e) {
    var evt = e || window.event;
    if (evt) {
        var keyCode = evt.charCode || evt.keyCode;
        if (keyCode === 8) {
            if (evt.preventDefault) {
                evt.preventDefault();
            } else {
                evt.returnValue = false;
            }
        }
    }
}
function isNumberKey(evt) {
    debugger;
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}
function isNumberDecimalKey(evt, obj) {

    var charCode = (evt.which) ? evt.which : event.keyCode
    var value = obj.value;
    var dotcontains = value.indexOf(".") != -1;
    if (dotcontains)
        if (charCode == 46) return false;
    if (charCode == 46) return true;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}
function alpha(e) {
    debugger;
    var k;
    document.all ? k = e.keyCode : k = e.which;
    /*return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || (k >= 48 && k <= 57));*/
    if (k >= 48 && k <= 57) {
        return true;
    }
    else {
        return false;
    };
}

function ConvertToDecimat(evt) {
    debugger;
    var id = evt.getAttribute('id');
    var val = $('#' + id + '').val();
    if (val != undefined && val != "") {
        val = parseFloat(val).toFixed(2);
        $('#' + id + '').val(val);
    }
}
function ConvertToDecimatPer(evt) {
    var id = evt.getAttribute('id');
    var val = $('#' + id + '').val();
    if (val != undefined && val != "") {
        val = parseFloat(val).toFixed(3);
        if (val <= 100.00) {
            $('#' + id + '').val(val);
        }
        else {
            $('#' + id + '').val('0.000');
            swal("", "Percentage can't be greater than 100%", "warning");
        }

    }
}
function PreventOnPaste(e) {
    debugger;
    var data = $(e).val();
    //replace the special characters to '' 
    var dataFull = isNaN(parseInt(data)) ? '' : data;
    //set the new value of the input text without special characters
    $(e).val(dataFull);
}
function numberonly(e) {
    debugger;
    var charCode = (e.which) ? e.which : event.keyCode
    if (String.fromCharCode(charCode).match(/[^0-9]/g))
        return false;
    return true;
};
//function isNumberDecimal(evt, ev) {
//    var value = Number(ev.value);
//    var res = ev.value.split(".");
//    if (res.length == 1 || res[1].length < 3) {
//        value = value.toFixed(2);
//    }
//    if (ev.value != "") {
//        ev.value = String(value);
//    }
//    //if (res[1].length > 2) {
//    //    swal("Error!", "After decimal can not be entered more than 2 digit.", "error").then(function () {
//    //        $(ev).focus();
//    //    });

//    //}
//    var CountNum = ev.value.toString().split('.')[1] || '';
//    if (CountNum.length > 2) {
//        swal("Error!", "After decimal can not be entered more than 2 digit.", "error").then(function () {
//            $(ev).focus();
//        });
//    }
//}

function Capitalize(id) {
    var txt = document.getElementById(id);
    txt.value = txt.value.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
}
function uppercase(id) {
    var txt = document.getElementById(id);
    txt.value = txt.value.replace(/\w\S*/g, function (txt) { return txt.substr(0).toUpperCase(); });
}
function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}
function isNumberDecimalKey(evt, obj) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    var value = obj.value;

    var dotcontains = value.indexOf(".") != -1;
    if (dotcontains)
        if (charCode == 46) return false;
    if (charCode == 46) return true;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}


function isWorkinghourKey(evt, obj) {

    var charCode = (evt.which) ? evt.which : event.keyCode
    var value = obj.value;
    var dotcontains = value.indexOf(":") != -1;
    if (dotcontains)
        if (charCode == 58) return false;
    if (charCode == 58) return true;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

var format = 'IN';
function dateformat(timestamp) {
    var dateVal = "/Date(" + timestamp + ")/";
    var date = new Date(parseFloat(dateVal.substr(6)));
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    var hh = date.getHours();
    var mm = date.getMinutes();
    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;
    if (format == "IN") {
        if (hh > 0) {
            var fulldate = day + "/" + month + "/" + year + ' ' + hh + ':' + (mm > 9 ? mm : '0' + mm);
        }
        else {
            var fulldate = day + "/" + month + "/" + year;
        }


    }
    if (format == "US") {

        var fulldate = month + "/" + day + "/" + year;
    }
    return fulldate;
}
function exDate(date) {
    var billDate = date.split('/');
    return billDate[1] + "/" + billDate[0] + "/" + billDate[2];
}
function goBack() {
    window.history.back();
}

//----------------------------------

var iWords = ['Zero', ' One', ' Two', ' Three', ' Four', ' Five', ' Six', ' Seven', ' Eight', ' Nine'];
var ePlace = ['Ten', ' Eleven', ' Twelve', ' Thirteen', ' Fourteen', ' Fifteen', ' Sixteen', ' Seventeen', ' Eighteen', ' Nineteen'];
var tensPlace = ['', ' Ten', ' Twenty', ' Thirty', ' Forty', ' Fifty', ' Sixty', ' Seventy', ' Eighty', ' Ninety'];
var inWords = [];

var numReversed, inWords, actnumber, i, j;

function tensComplication() {
    'use strict';
    if (actnumber[i] === 0) {
        inWords[j] = '';
    } else if (actnumber[i] === 1) {
        inWords[j] = ePlace[actnumber[i - 1]];
    } else {
        inWords[j] = tensPlace[actnumber[i]];
    }
}

function convertPriceToWords(rupees) {

    'use strict';
    var junkVal = rupees;
    junkVal = Math.floor(junkVal);
    var obStr = junkVal.toString();
    numReversed = obStr.split('');
    actnumber = numReversed.reverse();

    if (Number(junkVal) >= 0) {
        //do nothing
    } else {
        window.alert('wrong Number cannot be converted');
        return false;
    }
    if (Number(junkVal) === 0) {
        document.getElementById('container').innerHTML = obStr + '' + 'Rupees Zero Only';
        return false;
    }
    if (actnumber.length > 9) {
        window.alert('Oops!!!! the Number is too big to covertes');
        return false;
    }



    var iWordsLength = numReversed.length;
    var finalWord = '';
    j = 0;
    for (i = 0; i < iWordsLength; i++) {
        switch (i) {
            case 0:
                if (actnumber[i] === '0' || actnumber[i + 1] === '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[actnumber[i]];
                }
                inWords[j] = inWords[j] + ' Only';
                break;
            case 1:
                tensComplication();
                break;
            case 2:
                if (actnumber[i] === '0') {
                    inWords[j] = '';
                } else if (actnumber[i - 1] !== '0' && actnumber[i - 2] !== '0') {
                    inWords[j] = iWords[actnumber[i]] + ' Hundred and';
                } else {
                    inWords[j] = iWords[actnumber[i]] + ' Hundred';
                }
                break;
            case 3:
                if (actnumber[i] === '0' || actnumber[i + 1] === '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[actnumber[i]];
                }
                if (actnumber[i + 1] !== '0' || actnumber[i] > '0') {
                    inWords[j] = inWords[j] + ' Thousand';
                }
                break;
            case 4:
                tensComplication();
                break;
            case 5:
                if (actnumber[i] === '0' || actnumber[i + 1] === '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[actnumber[i]];
                }
                if (actnumber[i + 1] !== '0' || actnumber[i] > '0') {
                    inWords[j] = inWords[j] + ' Lakh';
                }
                break;
            case 6:
                tensComplication();
                break;
            case 7:
                if (actnumber[i] === '0' || actnumber[i + 1] === '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[actnumber[i]];
                }
                inWords[j] = inWords[j] + ' Crore';
                break;
            case 8:
                tensComplication();
                break;
            default:
                break;
        }
        j++;
    }


    inWords.reverse();
    for (i = 0; i < inWords.length; i++) {
        finalWord += inWords[i];
    }
    return finalWord;
}

function calHours(endTime, startTime) {
    if (endTime != '') {
        var endVal = "/Date(" + endTime + ")/";
        var endDate = new Date(parseFloat(endVal.substr(6)));
        var startVal = "/Date(" + startTime + ")/";
        var startDate = new Date(parseFloat(startVal.substr(6)));
        var diff = (endDate - startDate);

        var seconds = Math.floor(diff / 1000); //ignore any left over units smaller than a second
        var minutes = Math.floor(seconds / 60);
        seconds = seconds % 60;
        var hours = Math.floor(minutes / 60);
        minutes = minutes % 60;
        return hours + ":" + minutes;
    }
    else {
        return '0'
    }
}

function checkRequiredField() {
    var boolcheck = true;
    $('.req').each(function () {
        if ($(this).val().trim() == '' || $(this).val().trim() == '0' || $(this).val().trim() == '0.00') {
            boolcheck = false;
            $(this).addClass('border-warning');
        } else {
            $(this).removeClass('border-warning');
        }
    });
    $('.ddlreq').each(function () {
        if ($(this).val().trim() == '' || $(this).val().trim() == '0' || $(this).val().trim() == 'Select' || $(this).val().trim() == null) {
            boolcheck = false;
            $(this).addClass('border-warning');
        } else {
            $(this).removeClass('border-warning');
        }
    });
    $('.ddlreqs').each(function () {
        if ($(this).val() == '' || $(this).val() == '0' || $(this).val() == 'undefined' || $(this).val() == null || $(this).val() == 'Select') {
            boolcheck = false;
            $(this).closest('div').find('.select2-selection--single').attr('style', 'border:1px solid #FF9149  !important');
        } else {
            $(this).removeClass('border-warning');
            $(this).closest('div').find('.select2-selection--single').removeAttr('style');
        }
    });
    return boolcheck;
}

function isNumberDecimalKeyAmount(evt, obj) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    var value = obj.value;

    var dotcontains = value.indexOf(".") != -1;
    if (dotcontains)
        if (charCode == 46) return false;
    if (charCode == 46) return true;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }

    var CountNum = value.toString().split('.')[1] || '';
    if (CountNum.length > 1) {
        swal("Error!", "After decimal can not be entered more than 2 digit.", "error").then(function () {
            $(ev).focus();
        });
    }
    return true;
}

function NotFirstLetterSpecial(obj) {
    debugger;
    var rgx = "^[a-zA-Z0-9]*$";
    var str = $(obj).val();
    var str = str.split("");
    if (str[0].match(rgx) == null) {
        $(obj).val('');
    }
}

// For On Change Event
function ImproveDecimal(evt, obj) {
    debugger;
    //if (obj.value.includes(".")) {
    //    $(obj).val(parseFloat($(obj).val()).toFixed(2));
    //}
    var Amt = Number($(obj).val());
    var CountNum = Amt.toString().split('.')[1] || '';

    if (CountNum.length > 2) {
        Amt = Amt.toString().substring(0, Amt.toString().indexOf(".") + 3);
        $(obj).val(Amt)
    } else {
        $(obj).val(Amt.toFixed(2));

    }
}
//For On Keypress
function isDecimal52Keyevent(evt, obj) {

    var reg = /^\d{0,5}(\.\d{0,1})?$/;
    //if (reg.test(obj.value)) {
    //    return true
    //}
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 46)
        return false;
    if (evt.key != "." && obj.value.length == 5 && obj.value.indexOf(".") == -1) {

        return false;
    }


    if (obj.value.includes(".")) {
        if (evt.key == ".")
            return false;

    }

    if (obj.value.match(reg) == null) {

        return false
    }
    else {

        return true;
    }


}

function GetStringWithoutMultipleComma(Data) {
    var result = Data.replace(/,+/g, ",");
    result = result.replace(/\.+/g, ".");
    return result;
}


function IsValidInteger(e) {
    if ($(e).val().trim() != '' && (Math.floor($(e).val().trim()) == $(e).val().trim() && $.isNumeric($(e).val().trim()))) {
        
    }
    else {
        $(e).val(0)
        $(e).focus();
    }
}


//function IsValidInteger(e) {
//    var trimmedValue = $(e).val().trim();

//    if (trimmedValue === '') {
//        // Handle empty input (if needed)
//        alert('Please enter a value.');
//        $(e).focus();
//        return false;
//    }

//    var integerValue = parseInt(trimmedValue, 10);

//    if (isNaN(integerValue) || integerValue !== parseFloat(trimmedValue)) {
//        // Not a valid integer
//        alert('Please enter a valid integer.');
//        $(e).focus();
//        return false;
//    }

//    // Valid integer
//    return true;
//}
function IsValidDecimal(e) {
    if ($(e).val().trim() == '' || isNaN(parseFloat($(e).val().trim()))) {
        $(e).val('0.00')
        $(e).focus();
    }
}