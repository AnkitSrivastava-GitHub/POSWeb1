$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    AutoId = getQueryString('dt');
    if (AutoId != null) {
        Print_SafeCash(AutoId);
    }
    else {
        window.location.href = '/Default.aspx'
    }
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/CouponMaster.aspx/CurrencySymbol",
        dataType: "json",
        async: false,
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            debugger
            if (response.d != '') {
                CSymbol = response.d;
                $('.symbol').text(response.d);
            }
            else {
                window.location.href = '/Default.aspx'
            }
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function Print_SafeCash(AutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/Print_SafeCash",
        data: "{'AutoId':'" + AutoId + "'}",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: OnSuceess,
        error: function (response) {
            console.log(response.d)
        },
        failure: function () {
            console.log(response.d)
        },
    });
};
function OnSuceess(response) {
    debugger
    var html = '';
    if (response.d == "Session") {
        window.location.href = "/";
        return;
    }
    else if (response.d == "false") {
        window.location.href = "/";
        return;
    }
    else {
        debugger;        
        var xmldoc = $.parseXML(response.d);
        var xml = $(xmldoc);
        var SafeCashList = xml.find("Table");
        $.each(SafeCashList, function () {
            $('#lblComName').text($(this).find("CompanyName").text());
            $('#lblAddress1').text($(this).find("BillingAddress").text());
            $('#lblAddress2').text($(this).find("Address2").text());

            $('#spnInvoiceDate').text($(this).find("CreatedDate").text());
            if ($(this).find("TerminalName").text() != '') {
                $('#spnTerminal').text($(this).find("TerminalName").text());
            }
            else {
                $('#Terminal').hide();
            }
            $('#spnSafeCashAutoId').text($(this).find("AutoId").text());
            $('#spnUserName').text($(this).find("UserName").text());
            $('#spnDAmt').text(CSymbol + $(this).find("Amount").text()); 
            $('#spnReamark').text($(this).find("Remark").text());
            if ($(this).find("Mode").text() == '1') {
                $('#spnSafeMode').text('Deposit');
                $('#spnSafeMode1').text('Deposit');
                $('#spnSafeMode2').text('Deposit');
            }
            else {
                $('#spnSafeMode').text('Withdraw');
                $('#spnSafeMode1').text('Withdraw');
                $('#spnSafeMode2').text('Withdraw');
            }
        });
    }
    $('#dv_print').show();
    window.print();
}