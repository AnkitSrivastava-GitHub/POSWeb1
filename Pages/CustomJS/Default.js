$(document).ready(function () {
    
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();

    displayClock();
    function displayClock() {
        var display1 = new Date().toLocaleTimeString();
        var display3 = new Date().toLocaleTimeString('en-us');
        var display = new Date().toLocaleTimeString('en-us', { weekday: "long", year: "numeric", month: "short", day: "numeric" });
        //document.getElementById('txtCurrentTime').value = display1;
        $("#txtTodayDate").text(today + " " + display1);
        setTimeout(displayClock, 1000);
    }
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    session = getQueryString('session');
    if (session == 0) {
        swal({
            text: "Session Expired!",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "Okay",
                    value: null,
                    visible: true,
                    className: "btn-success",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) { window.location.href = "/Default.aspx"; });
    }

    $('#btnlogin').click(function () {
        login();
    }).then(function () {

    });
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "../../Default.aspx/CurrencySymbol",
        dataType: "json",
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
$(function () {
    debugger;
    var body = document.getElementsByTagName('body')[0];
    body.onkeypress = function (e) {
        if (e.keyCode === 13) {
            $('#btnlogin').click();
            if ($("#txtusername").val() == '') {
                $("#txtusername").focus();
                return;
            }
            if ($("#txtpassword").val() == '') {
                $("#txtpassword").focus();
            }
        }
    }
});

function openBalancePopup() {
    debugger
    $.ajax({
        type: "POST",
        url: "../../Default.aspx/BalanceStatus",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "No Product Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                var BalanceStatus = '';
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StatusList = $(xml).find("BalanceStatus");
                $.each(StatusList, function () {
                    $("#BalanceStatus").val($(this).find("Status").text());
                    BalanceStatus = $(this).find("Status").text();
                });
                if (BalanceStatus == 'Logout') {
                    $.ajax({
                        type: "POST",
                        url: "../../Default.aspx/BindCurrencyList",
                        data: "{ }",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            if (response.d == 'false') {
                                swal("", "No Currency Details Found!", "warning", { closeOnClickOutside: false });
                            } else if (response.d == "Session") {
                                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                                    window.location.href = "/Default.aspx";
                                });
                            }
                            else {
                                debugger;
                                var xmldoc = $.parseXML(response.d);
                                var xml = $(xmldoc);
                                var CurrencyList = $(xml).find("Table");
                                if (CurrencyList.length > 0) {
                                    $("#tableCurrency tbody tr").remove();
                                    var row = $("#tableCurrency thead tr:first-child").clone(true);
                                    $.each(CurrencyList, function () {
                                        debugger;
                                        $(".CCode", row).html($(this).find("AutoId").text());
                                        $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                                        $(".QTY", row).html('<div class="form-row" style="text-align:center;margin-left: -5px;"><button type="button" id="M" style="width: 170px; background-color:#d887347a;" class="minus-no btn btnMinus" onclick="MinusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" ><i class="fa fa-minus" aria-hidden="true"></i></button><input type="text" autocomplete="off" ondragover="return false" onPaste="return false" onCopy="return false" id="Q' + $(this).find("AutoId").text() + '" maxlength="3" onchange="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeyup="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeypress="return /[0-9]/i.test(event.key)" style="text-align: center; font-size:21px" class="form-control text-center" placeholder="0" /><button type="button" id="P" onclick="PlusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" style="width: 170px;background-color:#d887347a;" class="minus-no btn btnplus" ><i class="fa fa-plus" aria-hidden="true"></i></button></div>');
                                        $(".TotalA", row).html('<span id="T' + $(this).find("AutoId").text() + '">0.00</span>').css('text-align', 'right').css('background-color', '#eee');
                                        $("#tableCurrency").append(row);
                                        row = $("#tableCurrency tbody tr:last-child").clone(true);
                                    });
                                    $("#tableCurrency").show();
                                    $(".LoginTerminal").hide();
                                    $(".OpeningBalance").show();
                                    BindClosingCurrency();
                                }
                            }
                        },
                        failure: function (result) {
                            console.log(result.d);
                        },
                        error: function (result) {
                            console.log(result.d);
                        }
                    });
                    debugger;
                    $('#txtBalance').attr('disabled', true);
                    $("#balanceStatusText").text('Opening Balance:');
                    $("#btnOpeningBack").show();
                    $("#btnOpeningProceed").show();
                    $("#btnClosingBack").hide();
                    $("#btnCloseBalanceProceed").hide();
                    $("#ModalOpenBalance").modal('show');
                }
                else if (BalanceStatus == 'Pending') {
                    $.ajax({
                        type: "POST",
                        url: "../../Default.aspx/BindCurrencyList",
                        data: "{ }",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            if (response.d == 'false') {
                                swal("", "No Currency Details Found!", "warning", { closeOnClickOutside: false });
                            } else if (response.d == "Session") {
                                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                                    window.location.href = "/Default.aspx";
                                });
                            }
                            else {
                                debugger;
                                var xmldoc = $.parseXML(response.d);
                                var xml = $(xmldoc);
                                var CurrencyList = $(xml).find("Table");
                                if (CurrencyList.length > 0) {
                                    $("#tableCurrency tbody tr").remove();
                                    var row = $("#tableCurrency thead tr:first-child").clone(true);
                                    $.each(CurrencyList, function () {
                                        debugger;
                                        $(".CCode", row).html($(this).find("AutoId").text());
                                        $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                                        $(".QTY", row).html('<div class="form-row" style="text-align:center;margin-left: -5px;"><button type="button" id="M" style="width: 170px; background-color:#d887347a;" class="minus-no btn btnMinus" onclick="MinusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" ><i class="fa fa-minus" aria-hidden="true"></i></button><input type="text" autocomplete="off" ondragover="return false" onPaste="return false" onCopy="return false" id="Q' + $(this).find("AutoId").text() + '" maxlength="3" onchange="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeyup="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeypress="return /[0-9]/i.test(event.key)" style="text-align: center; font-size:21px" class="form-control text-center" placeholder="0" /><button type="button" id="P" onclick="PlusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" style="width: 170px;background-color:#d887347a;" class="minus-no btn btnplus" ><i class="fa fa-plus" aria-hidden="true"></i></button></div>');
                                        $(".TotalA", row).html('<span id="T' + $(this).find("AutoId").text() + '">0.00</span>').css('text-align', 'right').css('background-color', '#eee');
                                        $("#tableCurrency").append(row);
                                        row = $("#tableCurrency tbody tr:last-child").clone(true);
                                    });
                                    $(".LoginTerminal").hide();
                                    $(".OpeningBalance").show();
                                    $("#tableCurrency").show();
                                }
                            }
                        },
                        failure: function (result) {
                            console.log(result.d);
                        },
                        error: function (result) {
                            console.log(result.d);
                        }
                    });
                    debugger;
                    $('#txtBalance').attr('disabled', true);
                    $("#balanceStatusText").text('Closing Balance:');
                    $("#btnOpeningBack").hide();
                    $("#btnOpeningProceed").hide();
                    $("#btnClosingBack").show();
                    $("#btnCloseBalanceProceed").show();
                    $("#ModalOpenBalance").modal('show');
                }
                else if (BalanceStatus == 'Break') {
                    ProceedCashier2();
                }
                else if (BalanceStatus == 'Admin') {
                }
                else {

                }
            }
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function BindClosingCurrency() {
    data = {
        Terminal: $('#ddlTerminal').val()
    }
    $.ajax({
        type: "POST",
        url: "../../Default.aspx/BindClosCurrencyList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger
            if (response.d == 'false') {
                swal("", "No Currency Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CloseAmt = $(xml).find("Table");
                var CloseCurrencyList = $(xml).find("Table1");
                if (CloseAmt.length > 0) {
                    $.each(CloseAmt, function () {
                        debugger;
                        $('.OpenBalance').show();
                        $('.ClosingDate').show();
                        $('#lbl_OpenBal').text('Closing Balance:');
                        $('#txtClosingDate').val($(this).find("UpdatedDate").text());
                        $('#txtClosingBalance').val($(this).find("ClosingBalance").text());
                        $('#txtBalance').val($(this).find("ClosingBalance").text());
                    });
                }
                if (CloseCurrencyList.length > 0) {
                    $("#tableCurrency tbody tr").remove();
                    var row = $("#tableCurrency thead tr:first-child").clone(true);
                    $.each(CloseCurrencyList, function () {
                        debugger;
                        var Total = (parseFloat($(this).find("Amount").text()) * parseFloat($(this).find("QTY").text())).toFixed(2);
                        $(".CCode", row).html($(this).find("CurrencyAutoId").text());
                        $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                        $(".QTY", row).html('<div class="form-row" style="text-align:center;margin-left: -5px;"><button type="button" id="M" style="width: 170px; background-color:#d887347a;" class="minus-no btn btnMinus" onclick="MinusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" ><i class="fa fa-minus" aria-hidden="true"></i></button><input type="text" value="' + $(this).find("QTY").text() + '" autocomplete="off" ondragover="return false" onPaste="return false" onCopy="return false" id="Q' + $(this).find("AutoId").text() + '" maxlength="3" onchange="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeyup="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeypress="return /[0-9]/i.test(event.key)" style="text-align: center; font-size:21px" class="form-control text-center" placeholder="0" /><button type="button" id="P" onclick="PlusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" style="width: 170px;background-color:#d887347a;" class="minus-no btn btnplus" ><i class="fa fa-plus" aria-hidden="true"></i></button></div>');
                        $(".TotalA", row).html('<span id="T' + $(this).find("AutoId").text() + '">' + Total + '</span>').css('text-align', 'right').css('background-color', '#eee');
                        $("#tableCurrency").append(row);
                        row = $("#tableCurrency tbody tr:last-child").clone(true);
                    });
                    $("#tableCurrency").show();
                }
            }
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function ProceedOpeningBalanceModal() {
    var validate = 1, j = 0;
    if ($("#txtBalance").val().trim() == '') {
        validate = 0;
        toastr.error('Please Fill ' + $('#balanceStatusText').text() + '!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBalance").focus();
        return false;
    }
    if (validate == 1) {
        Currencydatatable = new Array();
        $("#tableCurrency tbody tr").each(function (index, item) {
            debugger
            Currencydatatable[j] = new Object();
            Currencydatatable[j].CurrencyID = $(item).find('.CCode').text();
            var QT = $(item).find('.QTY input').val();
            if (QT == '') {
                Currencydatatable[j].QTY = '0';
            } else {
                Currencydatatable[j].QTY = QT;
            }
            j++;
        });
        data = {
            Terminal: $('#ddlTerminal').val(),
            ClosingBalance: $("#txtBalance").val().trim()
        }
        $.ajax({
            type: "POST",
            url: "../../Default.aspx/OpeningBalance",
            data: JSON.stringify({ dataValues: JSON.stringify(data), Currencydatatable: JSON.stringify(Currencydatatable) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {

                if (response.d == 'Your previous closing balance is pending!') {
                    swal('', response.d, 'error', { closeOnClickOutside: false }).then(function () {
                        //window.location.href = "/Default.aspx";
                    });

                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    ProceedCashier2().then(function () {
                        BackLogin();
                    });                    
                }
            },
            failure: function (result) {
                console.log(result.d);
            },
            error: function (result) {
                console.log(result.d);
            }
        });
    }
}
function MinusFun(e) {
    debugger
    var id = $(e).next().attr("id");
    var Num = $('#' + id + '').val();
    if (Num == 0 || Num == '') {
        $('#' + id + '').val(0);
    }
    else {
        Num = Num - 1;
        $('#' + id + '').val(Num);
    }
}
function PlusFun(e) {
    debugger
    var id = $(e).prev().attr("id");
    var Num = $('#' + id + '').val();
    if (Num == '') {
        $('#' + id + '').val(1);
    }
    else {
        Num = parseInt(Num) + 1;
        $('#' + id + '').val(Num);
    }
}
function CalCurrency(AutoId, Amount, e) {
    debugger
    if ($(e).attr("id") == "M") {
        var ID = $(e).next().attr("id");
    }
    else {
        var ID = $(e).prev().attr("id");
    }

    if ($('#' + ID + '').val() == '') {
        $('#T' + AutoId + '').text('0.00');
    }
    else {
        var Qty = parseFloat($('#' + ID + '').val());
        var Total = 0;
        Total = parseFloat(Amount) * Qty;
        $('#T' + AutoId + '').text(Total.toFixed(2));
    }
    TotalCurrency();
}

function CalCurrency2(AutoId, Amount, e) {
    debugger

    if ($(e).val() == '') {
        $('#T' + AutoId + '').text('0.00');
    }
    else {
        var Qty = parseFloat($(e).val());
        var Total = 0;
        Total = parseFloat(Amount) * Qty;
        $('#T' + AutoId + '').text(Total.toFixed(2));
    }
    TotalCurrency();
}

function TotalCurrency() {
    debugger
    var TotalAmt = 0;
    $('#tableCurrency tbody tr').each(function () {
        var Total = $(this).find(".TotalA").text();
        TotalAmt += parseFloat(Total);
    });
    $('#txtBalance').val(TotalAmt.toFixed(2));
}

function login() {
    debugger;
    if ($("#txtusername").val() == "") {
        toastr.error('User Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else if ($("#txtpassword").val() == "") {
        toastr.error('Password Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else {
        localStorage.removeItem("messgeTime");
        var UserName = $("#txtusername").val();
        var Password = $("#txtpassword").val();
        $.ajax({
            type: "POST",
            url: "../../Default.aspx/loginUser",
            data: "{'UserName':'" + UserName + "','Password':'" + Password + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
            },
            complete: function () {
            },
            success: function (response) {
                debugger;
                if (response.d == 'Wrong User ID/Password!') {
                    swal("", response.d, "error", { closeOnClickOutside: false });
                }
                else if (response.d == 'Authorised Access Only') {
                    swal("", response.d, "error", { closeOnClickOutside: false });
                }
                else if (response.d == 'Store not found!') {
                    swal("", response.d, "error", { closeOnClickOutside: false });
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var LoginDetails = xml.find("Table");
                    debugger;
                    if ($(LoginDetails).find('EmpTypeNo').text() == '4') {
                        $('#StoreName').text($(LoginDetails).find('CompanyName').text());
                        if ($(LoginDetails).find('AvlTerminalCount').text() == '0' && $(LoginDetails).find('CompanyStatus').text() != '0') {
                            swal('Warning', 'All terminal are currently occupied.', 'warning', { closeOnClickOutside: false })
                        }
                        else if ($(LoginDetails).find('CompanyStatus').text() == '0') {
                            swal('Warning', 'No store found.', 'warning', { closeOnClickOutside: false })
                        }
                        else {
                            BindTerminal();
                            $('#login').hide(400);
                            $('#DivTerminal').show(400);
                        }
                    }
                    else if (parseInt($(LoginDetails).find('EmpStoreCnt').text()) == 1) {
                        ChangeStore($(LoginDetails).find('AssignedStoreId').text());
                    }
                    else {
                        document.location.href = "/Pages/ChangeStore.aspx";
                    }
                }
            },
            error: function (result) {
                swal("", "Error ! Incorrecet Username / Password", "warning", { closeOnClickOutside: false });
            },
            failure: function (result) {
                swal("", "Error ! Access Denied.", "warning", { closeOnClickOutside: false });
            }
        });
    }
    return 0;
}

function BindTerminal() {
    $.ajax({
        type: "POST",
        url: "../../Default.aspx/BindTerminal",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function () {
        },
        complete: function () {
        },
        success: function (response) {
            debugger;
            if (response.d == 'Session') {
                window.location.href = "/Default.aspx";
            }
            else if (response.d == 'false') {
                swal("", response.d, "error", { closeOnClickOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var TerminalList = xml.find("Table");
                var OccupyStatus = xml.find("Table1");
                $("#ddlTerminal option").remove();
                $("#ddlTerminal").append('<option value="0">Select Terminal</option>');
                $.each(TerminalList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                if ($(OccupyStatus).find("AlreadyAssignedStatus").text() == '1') {
                    $("#ddlTerminal").val($(OccupyStatus).find("TerminalAutoId").text());
                    $("#ddlTerminal").attr('disabled', 'disabled');
                    // ProceedCashier2();
                }
                else {
                    $("#ddlTerminal").removeAttr('disabled');
                }
            }
        },
        error: function (result) {
            swal("", result.error, { closeOnClickOutside: false });
        },
        failure: function (result) {
            swal("", result.error, "warning", { closeOnClickOutside: false });
        }
    });
}

function ProceedCashier() {
    SetCurrency();
    $("#txtClosingDate").val('');
    $("#txtClosingBalance").val('0.00');
    $("#txtBalance").val('0.00');
    if ($('#ddlTerminal').val() != "0") {
        openBalancePopup();
    }
    else {
        toastr.error('Please Select Terminal.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
}

function ProceedCashier2() {
    if ($("#ddlTerminal").val() == "0") {
        toastr.error('Please Select Terminal.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    $.ajax({
        type: "POST",
        url: "../../Default.aspx/AssignTerminal",
        data: "{'TerminalId':'" + $("#ddlTerminal").val() + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function () {
        },
        complete: function () {
        },
        success: function (response) {
            debugger;
            if (response.d == 'true') {
                debugger;
                //BackLogin();
                window.location.href = "/Pages/POSScreen.aspx";
            }
            else {
                swal("", response.d, "error", { closeOnClickOutside: false });
            }
        },
        error: function (result) {
            swal("", result.error, { closeOnClickOutside: false });
        },
        failure: function (result) {
            swal("", result.error, "warning", { closeOnClickOutside: false });
        }
    });
}

function BackLogin2() {
    $(".OpeningBalance").hide();
    $(".LoginTerminal").show();
    //$("#ddlTerminal").val(0);
    $('#login').hide(400);
    $('#DivTerminal').show(400);
}

function BackLogin() {
    $(".OpeningBalance").hide();
    $(".LoginTerminal").show();
    $("#ddlTerminal").val(0);
    $('#login').show(400);
    $('#DivTerminal').hide(400);
}

function ChangeStore(StoreId) {
    if (StoreId == 0) {
        document.location.href = "/Pages/ChangeStore.aspx";
    }
    else {
        $.ajax({
            type: "POST",
            url: "/Pages/ChangeStore.aspx/ChangeStore",
            data: "{'CompanyId':'" + StoreId + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No Store Found!", "warning", { closeOnClickOutside: false });
                } else if (response.d == "Session") {
                    location.href = '/';
                }
                else if (response.d == 'true') {
                    window.location.href = '/Pages/DashBoard.aspx'
                }
            },
            failure: function (result) {
                console.log(result.d);
            },
            error: function (result) {
                console.log(result.d);
            }
        });
    }
}
