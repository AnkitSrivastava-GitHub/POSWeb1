$(window).load(function () {
    //this.disabled = true; this.value = 'Submitting...';
    SetCurrency();
    function preventBack() {
        window.history.forward();
    }

    $('#form1').keypress(function (e) {
        if (e.which == 13) {
            e.preventDefault();
            //do something    
        }
    });
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });

    $("#txtBarcode").on("keypress", function (e) {
        if (e.key == 'Enter') {
            readBarcode();
        }
    });
    /*},0.2);*/
    //function Check() {
    CheckStore();
    //    setTimeout(Check, 10000);
    //}
    $(document).on('paste', '#txtBarcode', function (e) {
        e.preventDefault();
        var withoutSpaces = e.originalEvent.clipboardData.getData('Text');
        withoutSpaces = withoutSpaces.replace(/\s+/g, '');
        $(this).val(withoutSpaces);
    });
    openBalancePopup();
    $('#loading').show();

    //SearchCustomer(1);
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
    });

    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $("#txtTodayDate").text(today);
    $("#txtInvoDate").val(today);
    $(".date").val(today);
    $("#texDate").val(today);
    var old_goToToday = $.datepicker._gotoToday
    //for woring of Today button in date picker
    $('#txtDate').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        min: [month, today, now.getFullYear()]
    });

    $('#txtDOB').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });
    $.datepicker._gotoToday = function (id) {
        var target = $(id);
        var inst = this._getInst(target[0]);
        if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
            inst.selectedDay = inst.currentDay;
            inst.drawMonth = inst.selectedMonth = inst.currentMonth;
            inst.drawYear = inst.selectedYear = inst.currentYear;
        }
        else {
            var date = new Date();
            inst.selectedDay = date.getDate();
            inst.drawMonth = inst.selectedMonth = date.getMonth();
            inst.drawYear = inst.selectedYear = date.getFullYear();
            // the below two lines are new
            this._setDateDatepicker(target, date);
            this._selectDate(id, this._getDateDatepicker(target));
        }
        this._notifyChange(inst);
        this._adjustDate(target);
    }
    //end 
    displayClock();
    $("#txtTime").val(formatAMPM(new Date));
    $('#txtTime').pickatime({
        interval: 5
    });
    function displayClock() {
        var display1 = new Date().toLocaleTimeString();
        var display3 = new Date().toLocaleTimeString('en-us');
        var display = new Date().toLocaleTimeString('en-us', { weekday: "long", year: "numeric", month: "short", day: "numeric" });
        document.getElementById('spnTimer').innerHTML = display;
        $("#txtTodayDate").text(today + " " + display1);
        document.getElementById('spnTimer2').value = today + ' ' + display3;
        setTimeout(displayClock, 1000);
    }
    getComName();
    $("#tblProductDetail").text('');
    $('#ddlCreatedFrom').select2();
    $('#loading').hide();
    bindDropdown();
    bindMenuScreen();
    BindScreenProduct(1);
    GetCartOnLoad();
    GetUserTypeId();
    CountProductAndQuantity();

    FocusOnBarCode();

});

//function EnableButton() {
//    setTimeout('$("button").removeAttr("disabled");', 15000);
//}

var CSymbol = "";

function SetCurrency() {

    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/CurrencySymbol",
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

            if (response.d != '') {
                debugger;
                CSymbol = response.d;
                $('.symbol').text(response.d);
                calc_total();
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
function test() {
    alert('jghyter')
}

function RefreshCal() {
    if (parseFloat($('#result').val().trim()) > 100) {
        $('#result').val('');
    }
}
function FocusOnBarCode() {
    $('#txtBarcode').val('');
    $('#txtBarcode').focus();
}

function CloseDraft() {
    $('#btnDraftUpdate').hide();
    $('#btnDraft').show();
    $("#hdnDraftId").val('');
    $("#txtDraftName").val('');
    $('#hdnDraftName').val('');
    FocusOnBarCode();
}
function CheckStore() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/CheckStore",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

            if (response.d == 'false') {
                swal("", "No Product Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = $(xml).find("Table");
                if (StateList.length > 0) {

                }
                else {
                    swal('', "Session Expired!", 'warning', { closeOnClickOutside: false }).then(function () {

                        window.location.href = "/Default.aspx";
                    });
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
function formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
}
function openBalancePopup() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BalanceStatus2",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

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
                if (BalanceStatus == 'Break') {
                    swal('', "Back from break!", 'warning', { closeOnClickOutside: false }).then(function () {

                        FocusOnBarCode();
                    });
                }
                else if (BalanceStatus == 'Admin') {
                }
                else if (BalanceStatus == 'PageLoadMoreThanOnce') {
                    /*  swal('', response.d, 'warning', { closeOnClickOutside: false });*/
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
function BackfromClosingBalanceModal() {
    $("#ModalOpenBalance").modal('hide');
}

function BackfromOpeningBalanceModal() {
    window.location.href = "/Default.aspx";
}

function ProceedClosingBalanceModal() {

    var validate = 1, TxtBal = 0;
    if ($("#txtBalance").val().trim() == '' || parseFloat($("#txtBalance").val().trim()) == 0) {
        TxtBal = 0.00;
    }
    else {
        TxtBal = $("#txtBalance").val().trim();
    }
    var j = 0;
    if (validate == 1) {
        Currencydatatable = new Array();
        $("#tableCurrency tbody tr").each(function (index, item) {

            Currencydatatable[j] = new Object();
            Currencydatatable[j].CurrencyID = $(item).find('.CCode').text();
            var QT = $(item).find('.QTY input').val();
            if (QT == '') {
                Currencydatatable[j].QTY = '0';
            } else {
                Currencydatatable[j].QTY = QT;
            }
            j++;
        });//"{'ClosingBalance':'" + $("#txtBalance").val().trim() + "',
        data = {
            ClosingBalance: TxtBal,
            CurrentBalStatus: $("#CurrentBalStatus").val().trim(),
            CurrentBalance: (parseFloat($("#CurrentBaltxt").val()).toFixed(2)).replace('-', '')
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/ClosingBalance",
            data: JSON.stringify({ dataValues: JSON.stringify(data), Currencydatatable: JSON.stringify(Currencydatatable) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {

                if (response.d == 'true') {
                    $("#ModalOpenBalance").modal('hide');
                    swal('', 'Shift ended successfully!', 'success', { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == "Session") {
                    swal('', 'Session Expired!', 'success', { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    swal('', response.d, 'warning', { closeOnClickOutside: false });
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

function bindDropdown() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindDropdown",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Product Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");
                var CustomerList = xml.find("Table1");
                var RewardReedemValidation = xml.find("Table2");

                $("#hdnMinOrderAmtToReedemReward").val($(RewardReedemValidation).find("MinOrderAmt").text());
                $("#hdnReedemRewardStatus").val($(RewardReedemValidation).find("Status").text());
                $("#hdnCustomerId").val($(CustomerList).find("AutoId").text());
                $("#ddlCustomer").val($(CustomerList).find("Name").text());
                $("#txtState option").remove();
                $("#txtState").append('<option value="0">Select State</option>');
                $.each(StateList, function () {
                    $("#txtState").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("State1").text()));
                });
                $("#txtState").select2();
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

function bindDepartment() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindDepartment",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Department Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var DepartmentList = xml.find("Table");
                $("#ddlDepartment option").remove();
                $("#ddlDepartment").append('<option value="0">Select Department</option>');
                $.each(DepartmentList, function () {
                    $("#ddlDepartment").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text()));
                });
                $("#ddlDepartment").select2().next().css('width', '250px');
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

function bindScreenDDL() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindScreen",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Screen Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ScreenList = xml.find("Table");
                $("#ddlScreen option").remove();
                //$("#ddlScreen").append('<option value="0">Select Screen</option>');
                $.each(ScreenList, function () {
                    $("#ddlScreen").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("Name").text()));
                });
                $("#ddlScreen").select2().next().css('width', '250px');
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

function bindMenuScreen() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindScreen",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Screen Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                $("#ScreenList li").remove();
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ScreenList = xml.find("Table");
                var html = "";
                $.each(ScreenList, function () {
                    if ($(this).find("Name").text() == 'Home Screen') {
                        html += '<li>';
                        html += '<input class="Active" type = "button" onclick="BindScreenProduct(' + $(this).find("AutoId").text() + ')" id="' + $(this).find("AutoId").text() + '" value = "' + $(this).find("Name").text() + '" /></li >';
                        html += '</li>';
                    }
                });
                $.each(ScreenList, function () {
                    if ($(this).find("Name").text() != 'Home Screen') {
                        html += '<li>';
                        html += '<input class="" type = "button" onclick="BindScreenProduct(' + $(this).find("AutoId").text() + ')" id="' + $(this).find("AutoId").text() + '" value = "' + $(this).find("Name").text() + '" /></li >';
                        html += '</li>';
                    }
                    if ($(this).find("Name").text() == 'Lottery') {
                        //$("#Lotterylbl").show();
                    }
                });
                $("#ScreenList").append(html);
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
function getComName() {

    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/getComName",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

            if (response.d == "false") {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else if (response.d == "Session") {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {

                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ComUserDetails = xml.find("Table");
                if (ComUserDetails.length > 0) {
                    $("#spnCompany").text($(ComUserDetails).find('CompanyName').text() + ' - ' + $(ComUserDetails).find('TerminalName').text());
                    $("#spnUserName").text($(ComUserDetails).find('EmployeeName').text());
                    $("#spnUserName2").val($(ComUserDetails).find('EmployeeName').text());
                }
            }
        },
        failure: function (result) {
            $('#loading').hide();
            console.log(result.d);
        },
        error: function (result) {
            $('#loading').hide();
            console.log(result.d);
        }
    });
}

function BindScreenProduct(Fav) {
    debugger;
    $('#txtSearchProduct').val('');
    //if (Fav == 0) {
    //    $('.Active').removeClass('Active');
    //    $('#' + Fav + '').addClass('Active');
    //}
    //else {
    //    $('.Active').removeClass('Active');
    //    $('#' + Fav + '').addClass('Active');
    //}
    $('#loading').show();
    data = {
        ScreenId: Fav
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BindScreenProduct",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == "false") {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else if (response.d == "Session") {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Product = xml.find("Table");
                var ScreenId = xml.find("Table1");
                $("#ProductList").html('');

                var html = '';
                //if (Fav == 2) {
                //    html += '<button type="button" onclick="OpenLottoPaout()" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 85px;color:white !important;background-color:red !important">';
                //    html += 'Lottery Payout</button>';

                //    html += '<button type="button" onclick="OpenLottoSale()" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 85px;color:white !important;background-color:#F1EB90 !important">';
                //    html += 'Lottery Sale</button>';
                //}
                $.each(ScreenId, function () {
                    if ($(this).find('ScreenName').text() == 'Lottery') {
                        html += '<button type="button" onclick="OpenLottoPaout()" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 85px;color:white !important;background-color:red !important;line-height: 1;">';
                        html += 'Lottery Payout</button>';

                        html += '<button type="button" onclick="OpenLottoSale()" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 85px;color:white !important;background-color:#F1EB90 !important;line-height: 1;">';
                        html += 'Lottery Sale</button>';
                    }
                    if (Fav == 0) {
                        $('.Active').removeClass('Active');
                        $('#' + $(this).find('ScreenId').text() + '').addClass('Active');
                    }
                    else {
                        $('.Active').removeClass('Active');
                        $('#' + $(this).find('ScreenId').text() + '').addClass('Active');
                    }

                });
                if (Product.length > 0) {
                    var Barcode = '', ProductAutoID, SKUCount, SKUAutoId, BG_ColorCode = '', Age = 0, TEXT_ColorCode = '';
                    $.each(Product, function () {

                        Barcode = $(this).find('Barcode').text();
                        ProductAutoID = $(this).find('AutoId').text();
                        SKUCount = $(this).find('SKUCount').text();
                        SKUAutoId = $(this).find('SKUAutoId').text();
                        BG_ColorCode = $(this).find('BG_ColorCode').text();
                        TEXT_ColorCode = $(this).find('TEXT_ColorCode').text();
                        Age = $(this).find('Age').text();
                        SKUQuantity = $(this).find('Quantity').text();
                        html += '<button type="button" onclick="getProduct(\'' + Barcode + '\',' + ProductAutoID + ',' + SKUCount + ',' + SKUAutoId + ',' + SKUQuantity + ',' + Age + ',this)" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 84px;color:' + TEXT_ColorCode + ' !important;background-color:' + BG_ColorCode + ' !important;line-height: 1;">';
                        html += $(this).find('ProductName').text() + '</button>';
                    });
                    $("#ProductList").append(html);
                    $('#loading').hide();
                }
                else {
                    if (html != '') {

                    }
                    else {
                        var html = '';
                        html += '<p style="margin-top: 10px;font-size:18px">No Product Available.</p>';
                    }
                    $("#ProductList").append(html);
                }
                $('#loading').hide();
            }
        },
        failure: function (result) {
            $('#loading').hide();
            console.log(result.d);
        },
        error: function (result) {
            $('#loading').hide();
            console.log(result.d);
        }
    });
}
function BindProductList(Fav) {
    $('#loading').show();
    $('.Active').removeClass('Active');
    $('#1').addClass('Active');
    var Product = "";

    if ($('#txtSearchProduct').val().trim() == '') {

        BindScreenProduct(1);
        return;
    }
    if ($('#txtSearchProduct').val().trim().length > 0) {
        Product = $('#txtSearchProduct').val().trim();
    }
    else {
        Fav = 1;
    }
    if (Fav == 1) {
        Product = "";
        $('#txtSearchProduct').val('');
    }
    $('#loading').show();
    data = {
        ProductName: $('#txtSearchProduct').val().trim(),
        Fav: Fav
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BindProductList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        //async: false,
        success: function (response) {
            if (response.d == "false") {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else if (response.d == "Session") {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Product = xml.find("Table");
                var CompanyDetail = xml.find("Table1");
                $("#ProductList").html('');
                if (Product.length > 0) {
                    var html = '', Barcode = '', Age = 0, ProductAutoID, SKUCount, SKUAutoId, BG_ColorCode = '', TEXT_ColorCode = '';
                    $.each(Product, function () {

                        Barcode = $(this).find('Barcode').text();
                        ProductAutoID = $(this).find('AutoId').text();
                        SKUCount = $(this).find('SKUCount').text();
                        SKUAutoId = $(this).find('SKUAutoId').text();
                        BG_ColorCode = $(this).find('BG_ColorCode').text();
                        TEXT_ColorCode = $(this).find('TEXT_ColorCode').text();
                        Age = $(this).find('Age').text();
                        SKUQuantity = $(this).find('Quantity').text();
                        SKUName = $(this).find('ProductName').text();
                        html += '<button type="button" onclick="getProduct(\'' + Barcode + '\',' + ProductAutoID + ',' + SKUCount + ',' + SKUAutoId + ',' + SKUQuantity + ',' + Age + ',this)" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 85px;color:' + TEXT_ColorCode + ' !important;background-color:' + BG_ColorCode + ' !important;line-height: 1;">';
                        html += SKUName + '</button>';
                    });
                    $("#ProductList").append(html);

                }
                else {
                    var html = '';
                    html += '<p style="margin-top: 10px;font-size:18px;">No Product Available.</p>';
                    $("#ProductList").append(html);
                }
                $('#loading').hide();
            }
        },
        failure: function (result) {
            $('#loading').hide();
            console.log(result.d);
        },
        error: function (result) {
            $('#loading').hide();
            console.log(result.d);
        }
    });
}

$("#btnCancel").click(function () {
    $("#GenerateInvoice").modal('hide');
});

$("input[type=text]").focus(function () {
    $(this).select();
});

$("#txtReceiveAmount").focus(function () {
    $("#txtReceiveAmount").val($("#txtTotalAmount").val());
    $("#txtReturnAmount").val('0.00');
    $(this).select();
});

$("textarea").focus(function () {
    $(this).select();
});

//function readBarcodeOnPaste() {
//    $("#txtBarcode").change();
//}

function readBarcodeOnPaste(e) {
    debugger;
    var text = e.value;
    $("#txtBarcode").val(text.trim()).change();
}

function readBarcode() {
    $("#ProductVarientModal").modal('hide');
    debugger;
    //$("#txtBarcode").blur();
    var Barcode = $("#txtBarcode").val().trim();
    //var Barcode = barcode;
    if (Barcode != '') {
        var data = {
            Barcode: Barcode,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/BindSKUByBarcode",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'false') {
                    $("#txtBarcode").val('');
                    $("#txtBarcode").focus();
                    swal("", "No Barcode Found!", "warning", { closeOnClickOutside: false }).then(function () {
                        $("#ProductVarientModal").modal('hide');
                        $("#txtBarcode").focus();
                    });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        location.href = '/Default.aspx';
                    });
                }
                else {
                    $("#txtBarcode").val('');
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SKU = xml.find("Table");
                    getProduct($(SKU).find('Barcode').text(), $(SKU).find('AutoId').text(), $(SKU).find('SKUCount').text(), $(SKU).find('SKUAutoId').text(), 1, $(SKU).find('Age').text());
                }
            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
            }
        })
    }
    else {
        debugger;
        swal('Warning!', 'Please enter Barcode.', 'warning', { closeOnClickOutside: false });
    }
}
function GetCartOnLoad() {
    debugger;
    $('#Lotterylbl').hide();

    var OrderNo = localStorage.getItem("OrderNo");
    var OrderId = localStorage.getItem("OrderId");
    if ((OrderNo || 0) != 0) {
        var data = {
            CustomerId: 0,
            OrderNo: OrderNo,
            OrderId: OrderId
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/GetCart",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                debugger;
                if (response.d == 'false') {
                    swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                }
                else if (response.d == "Order Details Not Found.") {
                    //swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    //    window.location.href = "/Default.aspx";
                    //});
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    debugger;
                    var JsonObj = $.parseJSON(response.d);
                    $('#Lotterylbl').hide();
                    if (JsonObj.length > 0) {
                        $('#txt_PayNow').removeAttr('disabled');
                        AddInCart(JsonObj);
                    }
                    if ($("#tblProductDetail .product-addlist").length > 0) {
                        $('#txt_PayNow').removeAttr('disabled');
                    }
                    else {
                        $('#txt_PayNow').attr('disabled', 'disabled');
                    }

                }
            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
            }
        });
    }
}
function GetCart() {
    debugger;
    var OrderNo = localStorage.getItem("OrderNo");
    var OrderId = localStorage.getItem("OrderId");
    var data = {
        CustomerId: $("#hdnCustomerId").val(),
        OrderNo: OrderNo,
        OrderId: OrderId
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/GetCart",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "Product not found!", "warning", { closeOnClickOutside: false });
            }
            else if (response.d == "Order Details Not Found.") {
                //swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                //    window.location.href = "/Default.aspx";
                //});
            }
            else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                debugger;
                var JsonObj = $.parseJSON(response.d);
                if (JsonObj.length > 0) {
                    AddInCart(JsonObj);
                }
                if ($("#tblProductDetail .product-addlist").length > 0) {
                    $('#txt_PayNow').removeAttr('disabled');
                }
                else {
                    $('#txt_PayNow').attr('disabled', 'disabled');
                }
            }
        },
        failure: function (result) {
            console.log(JSON.parse(result.responseText).d);
        },
        error: function (result) {
            console.log(JSON.parse(result.responseText).d);
        }
    });
}

function getProduct(Barcode, ProductAutoId, SKUCount, SKUAutoId, SKUQuantity, Age, e, CartItemId) {
    debugger;
    if (SKUCount == 1) {
        qty = SKUQuantity;
        //SKUName = $(e).text();
        SKUName = '';
        if (CartItemId == null || CartItemId == undefined) {
            CartItemId = 0;
        }

        $('#tblProductDetail .product-addlist').each(function () {
            SKUId = $(this).find('.hdnSKUId').val();
            debugger;
            if (SKUId == SKUAutoId) {
                debugger;
                qty = parseInt($(this).find('.quantity').val());
                qty = parseInt(qty) + parseInt(SKUQuantity);
                CartItemId = parseInt($(this).find('.hdnCartItemId').val());
            }
        });
        var SKUAmt = 0, GiftCardCode = '';
        if (qty > 0) {
            var data = {
                CustomerId: $("#hdnCustomerId").val(),
                SKUAutoId: Barcode.trim(),
                OrderNo: $("#hdnOrderNo").val(),
                OrderId: $("#hdnOrderId").val() || 0,
                Quantity: qty,
                SKUName: SKUName,
                SKUAmt: SKUAmt,
                GiftCardCode: GiftCardCode,
                CartItemId: CartItemId,
                Age: Age
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/AddToCart",
                data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    debugger;
                    if (response.d == 'false') {
                        swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        debugger;
                        var JsonObj = $.parseJSON(response.d);
                        if (JsonObj.length > 0) {
                            AddInCart(JsonObj);
                            $("#txtBarcode").focus();
                        }
                        if ($("#tblProductDetail .product-addlist").length > 0) {
                            $('#txt_PayNow').removeAttr('disabled');
                        }
                        else {
                            $('#txt_PayNow').attr('disabled', 'disabled');
                        }
                    }
                },
                failure: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                }
            });
        }
    }
    else {
        var data = {
            ProductAutoId: ProductAutoId,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/BindSKUByProduct",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No Product Found!", "warning", { closeOnClickOutside: false });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SKU = xml.find("Table");
                    var ProductName = xml.find("Table1");
                    if (ProductName.length > 0) {
                        $("#productName").text($(ProductName).find('ProductName').text());
                    }
                    else {
                        $("#productName").text('Choose Varient');
                    }
                    var html = "";
                    var productname = "", BG_ColorCode = "";
                    if (SKU.length > 0) {
                        $.each(SKU, function () {
                            Barcode = $(this).find('Barcode').text();
                            BG_ColorCode = $(this).find('BG_ColorCode').text();
                            TEXT_ColorCode = $(this).find('TEXT_ColorCode').text();
                            ProductAutoID = $(this).find('ProductAutoID').text();
                            SKUCount = 1;
                            SKUAutoId = $(this).find('SKUAutoId').text();
                            SKUQuantity = 1;
                            Age = $(this).find('Age').text();

                            if ($(this).find('skutype').text() == "0") {
                                productname = $(this).find('SKUName').text()
                            }
                            else {
                                productname = $(this).find('PackingName').text();
                            }

                            html += '<button type="button" onclick="getProduct(\'' + Barcode + '\',' + ProductAutoID + ',' + SKUCount + ',' + SKUAutoId + ',' + SKUQuantity + ',' + Age + ')" class="btn btn-sm btn-primary Category sameHightCategory" style="height: 95px; text-overflow: ellipsis; width: 199px; padding: 10px 5px;color:' + TEXT_ColorCode + ' !important;background-color:' + BG_ColorCode + ' !important;line-height: 1;"><span style="width: 100%; height: 100px; position: relative; top: -3px; font-size: 18px"><b>' + productname + '</b></span ></button >'
                        });
                        $("#DivProductVarient").html(html);
                        $('#ProductVarientModal').modal('show');
                        $('#loading').hide();
                    }

                }
            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
            }
        });
    }
    //FocusOnBarCode();
}
function PlusMinusProduct(SKUName, SKUId, Qty, Type, CartItemId) {
    debugger;
    if (Type == 1) {
        qty = Qty + 1;
    }
    else if (Type == 0) {
        qty = Qty - 1;
    }
    if (qty > 0) {
        var data = {
            CustomerId: $("#hdnCustomerId").val(),
            SKUAutoId: SKUId,
            OrderNo: $("#hdnOrderNo").val(),
            OrderId: $("#hdnOrderId").val() || 0,
            Quantity: qty,
            SKUName: '',
            SKUAmt: 0,
            GiftCardCode: '',
            CartItemId: CartItemId,
            Age: 0
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/AddToCart",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                debugger;
                if (response.d == 'false') {
                    swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    debugger;
                    var JsonObj = $.parseJSON(response.d);
                    if (JsonObj.length > 0) {
                        AddInCart(JsonObj);
                    }
                    if ($("#tblProductDetail .product-addlist").length > 0) {
                        $('#txt_PayNow').removeAttr('disabled');
                    }
                    else {
                        $('#txt_PayNow').attr('disabled', 'disabled');
                    }
                }
            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
            }
        });
    }

    FocusOnBarCode();
}

function DeleteProduct(SKUId, qty, CartItemId) {
    debugger;
    var data = {
        CustomerId: $("#hdnCustomerId").val(),
        SKUAutoId: SKUId,
        OrderNo: $("#hdnOrderNo").val(),
        OrderId: $("#hdnOrderId").val() || 0,
        Quantity: qty,
        SKUName: '',
        SKUAmt: 0,
        GiftCardCode: '',
        CartItemId: CartItemId,
        Age: 0
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/AddToCart",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "Product not found!", "warning", { closeOnClickOutside: false });
            }
            else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                debugger;
                var JsonObj = $.parseJSON(response.d);
                if (JsonObj.length > 0) {
                    AddInCart(JsonObj);
                }
                if ($("#tblProductDetail .product-addlist").length > 0) {
                    $('#txt_PayNow').removeAttr('disabled');
                }
                else {
                    $('#txt_PayNow').attr('disabled', 'disabled');
                }
            }
        },
        failure: function (result) {
            console.log(JSON.parse(result.responseText).d);
        },
        error: function (result) {
            console.log(JSON.parse(result.responseText).d);
        }
    });
    /*}*/
    //var data = {
    //    CustomerId: $("#hdnCustomerId").val(),
    //    CartItemId: CartItemId,
    //    OrderNo: $("#hdnOrderNo").val(),
    //    OrderId: $("#hdnOrderId").val() || 0
    //}
    //$.ajax({
    //    type: "POST",
    //    url: "/Pages/POS.asmx/DeleteProductFromCart",
    //    data: JSON.stringify({ dataValues: JSON.stringify(data) }),
    //    contentType: "application/json; charset=utf-8",
    //    dataType: "json",
    //    async: false,
    //    success: function (response) {
    //        debugger;
    //        if (response.d == 'false') {
    //            swal("", "Product not found!", "warning", { closeOnClickOutside: false });
    //        }
    //        else if (response.d == "Session") {
    //            swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
    //                window.location.href = "/Default.aspx";
    //            });
    //        }
    //        else {
    //            debugger;
    //            var JsonObj = $.parseJSON(response.d);

    //            AddInCart(JsonObj);
    //        }
    //    },
    //    failure: function (result) {
    //        console.log(JSON.parse(result.responseText).d);
    //    },
    //    error: function (result) {
    //        console.log(JSON.parse(result.responseText).d);
    //    }
    //});
    FocusOnBarCode();
}

function BindProductTable(ProductDetail, itemDetail) {

    if ($("#tblProductDetail").length > 0) {
        var SKUId = 0, Quantity = 0, UnitPrice = 0, Tax = 0, i = 0;
        $('#tblProductDetail .product-addlist').each(function () {
            SKUId = $(this).find('.hdnSKUId').val();
            if (SKUId == $(ProductDetail).find("SKUId").text()) {
                debugger;
                $(this).find('.hdnSchemeId').val($(ProductDetail).find("SchemeId").text());

                if (parseFloat($(ProductDetail).find("UnitPrice").text()) != parseFloat($(ProductDetail).find("SKUSubTotal").text())) {
                    $(this).find('.original-price').text(CSymbol + parseFloat($(ProductDetail).find("UnitPrice").text()).toFixed(2));
                    $(this).find('.original-price').show();
                }
                else {
                    $(this).find('.original-price').val('');
                    $(this).find('.original-price').hide();
                }

                $(this).find('.spnUnitPrice').text($(ProductDetail).find("SKUSubTotal").text());
                $(this).find('.quantity').val($(ProductDetail).find("Quantity").text());
                $(this).find('.spntax').text($(ProductDetail).find("Tax").text());
                $(this).find('.SKUName').html(($(ProductDetail).find("SKUName").text()));
                i += 1;
            }
        });
        if (i == 0) {
            CreateTable(ProductDetail, itemDetail);
        }
    }
    else {
        CreateTable(ProductDetail, itemDetail);
    }
    calc_total();
    $("#txtBarcode").val('');
}

function errorImg(input) {
    $(input).attr('src', '../Images/ProductImages/product.png');
}

function deleterow(e, SKUName, SKUId, Qty, CartItemId) {
    var span = document.createElement("span");
    span.innerHTML = "You want to remove<br/> " + SKUName.split("</br>")[0];
    swal({
        title: "Are you sure?",
        content: span,
        allowOutsideClick: "false",
        icon: "warning",
        buttons: {
            cancel: {
                text: "No, Cancel",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes, Proceed",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            debugger;
            DeleteProduct(SKUId, Qty, CartItemId);
        }
        else {
            //debugger;
            //ResetBulk();
            //MasterBindProductList(1);
        }
    });
}

function deleteDraftItem(OrderNo) {
    swal({
        title: "Are you sure?",
        text: "You want to delete draft Product.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No, Cancel",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes, Delete it",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            var ONo = localStorage.getItem("OrderNo");
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/deleteDraftItem",
                data: "{'OrderNo':'" + OrderNo + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == 'true') {
                        BindOrderDraftLogList();
                        if (ONo == OrderNo) {
                            localStorage.clear();
                            $("#hdnOrderId").val('');
                            $("#hdnOrderNo").val('');
                            $("#tblProductDetail").html('');
                            EmptyProductList();
                        }
                        swal("Success!", "Draft order deleted successfully", "success", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                        $('#loading').hide();
                    }
                },
                failure: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                }
            });
        }
    });
}

function CreateTrnsTable(ClassName, PayMethod, PayAmt) {
    var DisplayRow = 'default';
    if (PayMethod == 'Cash' && PayAmt == 0) {
        DisplayRow = 'none';
    }
    $("#tblTransaction").find('.' + ClassName + '').remove();
    var html = '';
    html += '<tr style = "text-align: center;display:' + DisplayRow + '" class="' + ClassName + '">';
    html += '<td colspan="2" class="PaymentBy">' + PayMethod + '</td>';
    if (PayAmt < 0) {
        html += '<td colspan="1" class="PaymentAmt">-' + CSymbol + parseFloat(PayAmt * (-1)).toFixed(2) + '</td>';
    }
    else {
        html += '<td colspan="1" class="PaymentAmt">' + CSymbol + parseFloat(PayAmt).toFixed(2) + '</td>';
    }
    html += '<td colspan="1"><a onclick="DeleteTrnsRow(this)" style="color:red;cursor: pointer;">Remove</a></td>';
    html += '</tr>';
    $("#tblTransaction").append(html);
    $("#tblTransaction").show;
}

function DeleteTrnsRow(evt) {

    if ($(evt).parent().parent().find('.PaymentBy').text().trim() == 'Coupon') {
        $('.Gift').hide();
        CouponAmt = 0;
        CouponNo = '';
        MinCouponOrderAmt = 0;
    }
    else if ($(evt).parent().parent().find('.PaymentBy').text().trim() == 'Gift Card') {
        //G
        DeleteGiftCardLog();
    }
    else if ($(evt).parent().parent().find('.PaymentBy').text().trim() == 'Reward points') {
        RoyaltyAmount = 0;
        UsedRoyaltyPoints = 0;
    }
    else if ($(evt).parent().parent().find('.PaymentBy').text().trim() == 'Cash') {
        PayButton = '';
        GivenCash = 0;
    }
    else if ($(evt).parent().parent().find('.PaymentBy').text().trim() == 'Credit Card') {
        PayMentMethod = '';
    }
    $(evt).closest('tr').remove();
    calc_total();
}

function DeleteGiftCardLog() {
    GiftCardAmt = 0;
    GiftCardNo = '';
    GiftCardLeftAmt = 0;
    GiftCardAppliedStatus = 0;
    TempGiftCardAmt = 0;
    TempGiftCardLeftAmt = 0;
    TempGiftCardUsedAmt = 0;
    PushGiftCardMessage = 0;
    $("#DivGiftCard").hide();
    $("#tblTransaction").find('.GiftCard').remove();
    $("#lblGiftCardAmt").text(parseFloat(0).toFixed(2));
    $("#lblGiftCardAmt1").text(CSymbol + parseFloat(0).toFixed(2));
}

var PayMentMethod = '';
function calc_total() {
    debugger;
    var sum = 0, t_Tax = 0, Grand_Total = 0, LottoPayoutAmt = 0, Ldiscount = 0, LeftAmount = 0, GOrdertotal = 0, TotalLotterySale = 0;
    $('#tblProductDetail .product-addlist').each(function () {
        Quantity = $(this).find('.quantity').val();
        UnitPrice = $(this).find('.spnUnitPrice').text().replace(CSymbol, '');
        if ($(this).find('.SKUName').text() == 'Lottery Payout') {
            LottoPayoutAmt = LottoPayoutAmt + (parseFloat(Quantity) * parseFloat(UnitPrice));
        }
        //else if (($(this).find('.SKUName').text().trim()).includes('Lottery') && $(this).find('.SKUName').text().trim() != 'Lottery Payout') {
        //    TotalLotterySale = TotalLotterySale + (parseFloat(Quantity) * parseFloat(UnitPrice));
        //}
        else {
            sum = sum + (parseFloat(Quantity) * parseFloat(UnitPrice));
        }

        if (($(this).find('.SKUName').text().trim()).includes('Lottery') && $(this).find('.SKUName').text().trim() != 'Lottery Payout') {
            TotalLotterySale = TotalLotterySale + (parseFloat(Quantity) * parseFloat(UnitPrice));
        }
        //t_Tax = t_Tax + (parseFloat($(this).find('.spntax').text()) * Quantity);
        t_Tax = t_Tax + (parseFloat($(this).find('.spntax').text()));
    });
    debugger;
    //$('#lblsubtotal').text(parseFloat(sum - LottoPayoutAmt).toFixed(2));
    $('#lblsubtotal').text(parseFloat(sum - TotalLotterySale).toFixed(2));
    $('#lblsubtotal1').text((CSymbol + $('#lblsubtotal').text()).replace(CSymbol + '-', '-' + CSymbol));
    $('#lbltax').text(parseFloat(t_Tax).toFixed(2));

    Ldiscount = parseFloat($('#lbldiscount').text()).toFixed(2);

    if (parseFloat(parseFloat(parseFloat(Grand_Total).toFixed(2))) < parseFloat(Ldiscount) && parseFloat(Ldiscount) <= 0) {
        Ldiscount = 0
        $('#lbldiscount').text('0.00');
        $('#lbldiscount1').text(CSymbol + '0.00');
        swal('', 'Discount is not applicable!', 'warning', { closeOnClickOutside: false });
    }
    debugger;
    //Grand_Total = parseFloat((sum + t_Tax) - (parseFloat(Ldiscount))).toFixed(2);
    Grand_Total = parseFloat((sum + t_Tax) - (parseFloat(Ldiscount)) - parseFloat(LottoPayoutAmt)).toFixed(2);
    $('#lblgrandtotal').text(parseFloat(Grand_Total).toFixed(2));
    $('#lblgrandtotal1').text((CSymbol + parseFloat(Grand_Total).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    if (Grand_Total < 0) {
        $('#lblOdrTotal').css('color', 'red');
        $('#lblgrandtotal1').css('color', 'red');
    }
    else {
        $('#lblOdrTotal').css('color', 'green');
        $('#lblgrandtotal1').css('color', 'green');
    }
    $('#lblLottoPayout').text(parseFloat(LottoPayoutAmt).toFixed(2));

    GOrdertotal = parseFloat(Grand_Total);
    $("#PayGOrdertotal").val(parseFloat(Grand_Total).toFixed(2));

    Grand_Total = Grand_Total - TotalLotterySale + LottoPayoutAmt;

    if (CouponNo != '' && (parseFloat(Grand_Total) < parseFloat(MinCouponOrderAmt))) {
        swal('Warning!', 'Coupon is not applicable.', 'warning', { closeOnClickOutside: false }).then(function () {
            RemoveGift();
        });
    }
    else if (CouponNo != '') {
        if (parseFloat(CouponAmt) < parseFloat(Grand_Total)) {
            Grand_Total = parseFloat(Grand_Total) - parseFloat(CouponAmt);

            CreateTrnsTable('CouponTr', 'Coupon', CouponAmt);
        }
        else if (parseFloat(CouponAmt) >= parseFloat(Grand_Total)) {
            CreateTrnsTable('CouponTr', 'Coupon', Grand_Total);
            Grand_Total = 0;
            if (TotalLotterySale == 0 && LottoPayoutAmt == 0) {
                PayMentMethod = 'Coupon';
            }
        }
    }
    else {
        RemoveGift();
    }

    TempGiftCardLeftAmt = 0, TempGiftCardUsed = 0;
    if (Grand_Total > 0) {
        if (GiftCardNo != '' && (parseFloat(Grand_Total) > parseFloat(GiftCardLeftAmt))) {
            debugger;
            Grand_Total = Grand_Total - GiftCardLeftAmt;
            TempGiftCardUsedAmt = GiftCardLeftAmt;
            TempGiftCardLeftAmt = 0;
            //$("#DivGiftCard").show();
            $("#lblGiftCardAmt").text(parseFloat(TempGiftCardUsedAmt).toFixed(2));
            $("#lblGiftCardAmt1").text('-' + CSymbol + parseFloat(TempGiftCardUsedAmt).toFixed(2));

            CreateTrnsTable('GiftCard', 'Gift Card', TempGiftCardUsedAmt);
        }
        else if (GiftCardNo != '' && (parseFloat(Grand_Total) <= parseFloat(GiftCardLeftAmt))) {
            debugger;
            TempGiftCardLeftAmt = GiftCardLeftAmt - Grand_Total;
            TempGiftCardUsedAmt = Grand_Total;
            Grand_Total = 0;
            if (TotalLotterySale == 0) {

                PayMentMethod = 'Gift Card';
            }
            //$("#DivGiftCard").show();
            $("#lblGiftCardAmt").text(parseFloat(TempGiftCardUsedAmt).toFixed(2));
            $("#lblGiftCardAmt1").text('-' + CSymbol + parseFloat(TempGiftCardUsedAmt).toFixed(2));
            //$("#tblTransaction tr").each(function () {
            //    if ($(this).attr('class')=='GiftCard') {
            //        GiftCardRowCnt++;
            //    }
            //});
            //if ($("#tblTransaction .GiftCard").length == 0 || PushGiftCardMessage == 0) {
            if (PushGiftCardMessage == 0) {
                PushGiftCardMessage = 1;
                var Temptext = 'Gift Card Left Amount is ' + CSymbol + parseFloat(TempGiftCardLeftAmt).toFixed(2) + '.';
                swal('Success!', Temptext, 'success', { closeOnClickOutside: false });
            }
            CreateTrnsTable('GiftCard', 'Gift Card', TempGiftCardUsedAmt);
        }
    }
    else {
        if ($("#tblTransaction .GiftCard").length > 0) {
            var Temptext = 'Gift Card removed.';
            swal('Success!', Temptext, 'success', { closeOnClickOutside: false });
        }
        //$("#tblTransaction").find('.GiftCard').remove();
        DeleteGiftCardLog();
    }

    if (parseFloat(parseFloat(RoyaltyAmount).toFixed(2)) > 0 && parseFloat(parseFloat(Grand_Total).toFixed(2)) > 0) {
        if (Grand_Total > RoyaltyAmount) {
            CreateTrnsTable('HappPointsPayment', 'Reward points', RoyaltyAmount);
            Grand_Total = Grand_Total - RoyaltyAmount;
        }
        else if (parseFloat(parseFloat(Grand_Total).toFixed(2)) <= parseFloat(parseFloat(RoyaltyAmount).toFixed(2))) {
            CreateTrnsTable('HappPointsPayment', 'Reward points', Grand_Total);
            RoyaltyAmount = Grand_Total;
            Grand_Total = 0;
            if (TotalLotterySale == 0 && LottoPayoutAmt == 0) {
                PayMentMethod = 'Royaltypoints';
            }
        }
    }
    else if (parseFloat(parseFloat(RoyaltyAmount).toFixed(2)) > 0 && parseFloat(parseFloat(Grand_Total).toFixed(2)) <= 0) {
        RoyaltyAmount = 0;
        $("#tblTransaction").find('.HappPointsPayment').remove();
        /*swal('Warning!', 'Reward Points not applicable.', 'warning', { closeOnClickOutside: false });*/
    }
    else {
        $("#tblTransaction").find('.HappPointsPayment').remove();
        RoyaltyAmount = 0;
    }

    Grand_Total = Grand_Total + TotalLotterySale - LottoPayoutAmt;

    if ((Grand_Total != 0 && GivenCash > 0) || PayButton == 'Exact') {

        if (parseFloat(parseFloat(GivenCash).toFixed(2)) < parseFloat(parseFloat(Grand_Total).toFixed(2))) {
            Grand_Total = parseFloat(parseFloat(Grand_Total).toFixed(2)) - (isNaN(GivenCash) ? 0 : GivenCash);
            LeftAmount = 0;
            CreateTrnsTable('CashPayment', 'Cash', GivenCash);
        }
        else if (parseFloat(parseFloat(GivenCash).toFixed(2)) >= parseFloat(parseFloat(Grand_Total).toFixed(2))) {

            LeftAmount = parseFloat(parseFloat(GivenCash).toFixed(2)) - parseFloat(parseFloat(Grand_Total).toFixed(2));
            CreateTrnsTable('CashPayment', 'Cash', Grand_Total);
            Grand_Total = 0;
            PayMentMethod = 'Cash';
        }
    }

    else if (parseFloat(parseFloat(GivenCash).toFixed(2)) < 0) {
        Grand_Total = 0;
        PayMentMethod = 'Cash';
    }
    else {

        GivenCash = 0;
        $("#tblTransaction").find('.CashPayment').remove();
    }

    if (PayMentMethod.trim() == 'Credit Card' && CardType != 0) {
        CreateTrnsTable('CreditCard', 'Credit Card', Grand_Total)
        Grand_Total = 0;
        PayMentMethod = 'Credit Card';
    }
    else {
        $("#tblTransaction").find('.CreditCard').remove();
        //PayMentMethod = '';
        CardType = 0;
    }

    if (parseFloat(parseFloat(GivenCash).toFixed(2)) < 0) {

    }
    else {
        var tempCal = GOrdertotal - Grand_Total;
        //Grand_Total = Grand_Total - LottoPayoutAmt;
    }


    if (parseFloat(parseFloat(Grand_Total).toFixed(2)) <= 0) {
        $('.LotteryB').attr('disabled', 'disabled');
        $("#btnCreditCard").attr("disabled", "disabled");

        /*$("#LeftAmt").val(parseFloat(Grand_Total).toFixed(2));*/
    }
    else {
        debugger;
        $("#btnCreditCard").removeAttr("disabled");
        $('.LotteryB').removeAttr('disabled', 'disabled');
        if (Grand_Total - TotalLotterySale + LottoPayoutAmt <= 0) {
            $('#btnApplyCoupon').attr('disabled', 'disabled');
            $('#btnApplyGift').attr('disabled', 'disabled');
        }
        //else {
        //    $('#btnApplyCoupon').removeAttr('disabled');
        //    $('#btnApplyGift').removeAttr('disabled');
        //}
        if ((Grand_Total - TotalLotterySale + LottoPayoutAmt <= 0) || ((parseFloat($("#PayGOrdertotal").val()) + LottoPayoutAmt - TotalLotterySale) < parseFloat($('#hdnMinOrderAmtToReedemReward').val())) || $('#hdnMinOrderAmtToReedemReward').val().trim() == 'Inactive') {
            $('#btnRewardReedem').attr('disabled', 'disabled');
        }
        //else {
        //    $('btnRewardReedem').attr('disabled','disabled');
        //}
    }

    if (parseFloat(parseFloat(Grand_Total).toFixed(2)) < 0) {
        //$('#PaidAmt').val(isNaN(parseFloat(GivenCash).toFixed(2)) ? 0 : parseFloat(GivenCash).toFixed(2));
        $('#LeftAmt').val(parseFloat(-Grand_Total).toFixed(2));
        //$('#txtTransactionAmt').val(parseFloat(-Grand_Total).toFixed(2));
    }
    else {
        $('#PaidAmt').val(isNaN(parseFloat(tempCal).toFixed(2)) ? 0 : parseFloat(tempCal).toFixed(2));
        $('#LeftAmt').val(isNaN(parseFloat(-Grand_Total + LeftAmount).toFixed(2)) ? 0 : parseFloat(-Grand_Total + LeftAmount).toFixed(2));
        //$('#LeftAmt').val(isNaN(parseFloat(LeftAmount).toFixed(2)) ? 0 : parseFloat(LeftAmount).toFixed(2));
        $('#txtTransactionAmt').val(isNaN(parseFloat(Grand_Total).toFixed(2)) ? 0 : parseFloat(Grand_Total).toFixed(2));
    }

    //$('#lblgrandtotal1').text(('$' + parseFloat(Grand_Total).toFixed(2)).replace('$-', '-$'));

    $('#btnExactCash').attr('onclick', 'PayExact(' + parseFloat(Grand_Total + GivenCash).toFixed(2) + ')');
    $('#btnExactCash').text((CSymbol + parseFloat(Grand_Total).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    if (parseFloat(parseFloat(Grand_Total).toFixed(2)) >= 0) {
        $('#PayGtotal').val(parseFloat(Grand_Total).toFixed(2));
    }
    else {
        $('#PayGtotal').val('0.00');
    }
    //if (parseFloat(Grand_Total) < 0) {
    //    $('#LeftAmt').val(parseFloat(-Grand_Total).toFixed(2));
    //}
    //Cal_Cash(0);

    if (parseFloat($('#LeftAmt').val()) == 0) {
        document.getElementById("LeftAmt").style.color = "black";
    }
    else if (parseFloat($('#LeftAmt').val()) > 0) {
        document.getElementById("LeftAmt").style.color = "#007c10";
    }
    else {
        document.getElementById("LeftAmt").style.color = "#ff0000";
    }

    CountProductAndQuantity();

    if (Grand_Total == 0 && PayMentMethod != '') {
        $('#btnExactCash').attr('disabled', 'disabled');
        if (PayMentMethod == 'Credit Card') {
            FinalPay(PayMentMethod, Grand_Total, LeftAmount);
        }
        else {
            $("#btnTransactionProceed").attr('onclick', 'FinalPay(\'' + PayMentMethod + '\',' + Grand_Total + ',' + LeftAmount + ')');
            $("#btnTransactionProceed").removeAttr('disabled');
        }
    }
    //For 0 order total
    else if (Grand_Total == 0 && PayMentMethod == '' && $('#tblProductDetail .product-addlist').length > 0) {
        CreateTrnsTable('CashPayment', 'Cash', Grand_Total);
        $('#btnExactCash').attr('disabled', 'disabled');
        $("#btnTransactionProceed").attr('onclick', 'FinalPay(\'' + 'Cash' + '\',' + Grand_Total + ',' + LeftAmount + ')');
        $("#btnTransactionProceed").removeAttr('disabled');
    }
    else {
        $('#btnExactCash').removeAttr('disabled');
        $("#btnTransactionProceed").attr('onclick', 'FinalPay(None,0,0)');
        $("#btnTransactionProceed").attr('disabled', 'disabled');
    }
}

function PayExact(Val) {
    PayButton = 'Exact';
    Cal_Cash(Val);
}

var GivenCash = 0, LeftAmt = 0, PayButton = '';
function Cal_Cash(value) {

    var PayGrandTotal = 0, temp = 0, rowCount = 0;
    $('#PaidAmt').attr('readonly', 'readonly');
    PayGrandTotal = isNaN(parseFloat($('#lblgrandtotal').text())) ? 0 : parseFloat($('#lblgrandtotal').text());
    rowCount = $("#tblProductDetail .product-addlist").length;
    if (rowCount != 0) {

        GivenCash = isNaN(parseFloat(value)) ? 0 : parseFloat(value);
        calc_total();

    }
    else {
        swal('Warning', 'Please add atleast 1 product.', 'warning', { closeOnClickOutside: false });
    }
}


function CreditcardPay1() {

    var i = 0;
    CreditCardBackFromTrs();
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if ($(item).find('.SKUId').text() != '0') {
            i++;
        }
    });
    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            FocusOnBarCode();
        });
        return;
    }

    else {
        BindCardType();
    }
}

function BindCardType() {
    var html = "";
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BindCardType",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Card Type Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CardTypeList = xml.find("Table"), i = 1;
                $("#CardList").html('');
                $.each(CardTypeList, function () {
                    if (i <= 3) {
                        html += '<div  class="col-md-4">';
                        html += '<button type="button" onclick="OpenTransactionDiv(' + $(this).find("AutoId").text() + ');" id="' + $(this).find("AutoId").text() + '" class="disc-btn btn btn-primary" style="color:' + $(this).find("textColor").text() + ';background-color:' + $(this).find("BGColor").text() + '">' + $(this).find("CardTypeName").text() + '</button>';
                        html += '</div>';
                        i++;
                    }
                    else {
                        html += '<div  class="col-md-4" style="margin-top:10px">';
                        html += '<button type="button" onclick="OpenTransactionDiv(' + $(this).find("AutoId").text() + ');" id="' + $(this).find("AutoId").text() + '" class="disc-btn btn btn-primary" style="color:' + $(this).find("textColor").text() + ';background-color:' + $(this).find("BGColor").text() + '">' + $(this).find("CardTypeName").text() + '</button>';
                        html += '</div>';
                        i++;
                    }
                });

                $("#CardList").append(html);
                $('#CardTypeModal').modal('show');
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

function OpenTransactionDiv(CardVal) {

    $('.CardList').hide();
    $('.CreditCardDetails').show();
    $('#btnCreditCardPayBack').attr('onclick', 'CreditCardBackFromTrs()');
    $('#btnCreditCardePayProceed').show();
    $('#btnCreditCardePayProceed').attr('onclick', 'CreditcardPay(' + CardVal + ')');
}

function CreditCardBackFromTrs() {

    $('.CardList').show();
    $('.CreditCardDetails').hide();
    $('#txtLastfourDigits').val('');
    $('#txtCreditCardTransactionID').val('');
    $('#btnCreditCardPayBack').attr('onclick', 'CloseCardTypeModal()');
    $('#btnCreditCardePayProceed').hide();
    $('#btnCreditCardePayProceed').attr('onclick', '');
}

function CloseCardTypeModal() {
    $("#ddlCardType option").remove();
    $("#ddlCardType").append('<option value="0">Select Card Type</option>');
    $('#CardTypeModal').modal('hide');
    FocusOnBarCode();
}

var CardType = 0, TrasactionID = '', CreditCardLastfourDigit = '';
function CreditcardPay(CardVal) {
    var i = 0;
    debugger;
    if ($('#txtLastfourDigits').val().trim() == '' || $('#txtLastfourDigits').val().trim().length != 4) {
        toastr.error('Please enter credit card Last 4 digit No.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else if ($('#txtCreditCardTransactionID').val().trim() == '') {
        toastr.error('Please enter Transaction ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else if ($('#hdnOrderId').val().trim() == '' || $('#hdnOrderId').val().trim() == '0') {
        //$("#hdnOrderId").val(JsonObj[0].OrderDetail[0].OrderId);
        //$("#hdnOrderNo").val(JsonObj[0].OrderDetail[0].OrderNo);
        toastr.error('Invalid order no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if ($(item).find('.SKUId').text() != '0') {
            i++;
        }
    });
    if (i == 0) {
        $("#tblTransaction").find('.CreditCard').remove();
        PayMentMethod = '';
        CardType = 0;
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            calc_total();
            FocusOnBarCode();
        });
        return;
    }
    else {
        swal({
            title: "",
            text: "Is Credit Card Transaction successful?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                debugger;
                CardType = CardVal;
                PayMentMethod = 'Credit Card';
                CreditCardLastfourDigit = $('#txtLastfourDigits').val().trim();
                TrasactionID = $('#txtCreditCardTransactionID').val().trim();
                //$('#CardTypeModal').modal('hide');
                var ProceedAmt = $('#txtTransactionAmt').val().trim();
                var DraftId = $('#hdnOrderId').val().trim();
                ProceedAmt = isNaN(parseFloat(ProceedAmt)) ? 0 : parseFloat(ProceedAmt);
                CreateTransactionLog(DraftId, '', CardType, CreditCardLastfourDigit, TrasactionID, ProceedAmt, 'Success');
                calc_total();
            }
            else {
                debugger;
                CardType = CardVal;
                PayMentMethod = 'Credit Card';
                CreditCardLastfourDigit = $('#txtLastfourDigits').val().trim();
                TrasactionID = $('#txtCreditCardTransactionID').val().trim();
                var ProceedAmt = $('#txtTransactionAmt').val().trim();
                var DraftId = $('#hdnOrderId').val().trim();
                ProceedAmt = isNaN(parseFloat(ProceedAmt)) ? 0 : parseFloat(ProceedAmt);
                CreateTransactionLog(DraftId, '', CardType, CreditCardLastfourDigit, TrasactionID, ProceedAmt, 'Failed');
                swal('Warning!', 'Transaction Failed.', 'warning', { closeOnClickOutside: false }).then(function () {
                    $("#tblTransaction").find('.CreditCard').remove();
                    PayMentMethod = '';
                    CardType = 0;
                    CreditCardLastfourDigit = '';
                    TrasactionID = '';
                    //$('#CardTypeModal').modal('hide');
                    CloseCardTypeModal();
                    FocusOnBarCode();
                });
            }
        });
    }
}

function CreateTransactionLog(DraftId, InvoiceNo, CardType, CardNo, TransactionId, ProceedAmt, Status) {
    debugger;
    var data = {
        CustomerId: $("#hdnCustomerId").val().trim(),
        DraftId: DraftId,
        InvoiceNo: '',
        CardType: CardType,
        CardNo: CardNo,
        TransactionId: TransactionId,
        ProceedAmt: ProceedAmt,
        Status: Status,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/CreateTransactionLog",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                //swal("", "Some error occured!", "error", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                swal("Error!", response.d, "error", { closeOnClickOutside: false });
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


function FinalPay(PaymentMethod, PayGrandTotal, LeftAmt) {

    if (PaymentMethod.trim() == 'None') {
        swal('Warning', 'Please select any payment method.', 'warning', { closeOnClickOutside: false });
    }
    else {
        if (PaymentMethod == 'Credit Card') {

            printInvoice(PaymentMethod, LeftAmt);
        }
        else {
            swal({
                //title: "Return Amount : $" + parseFloat(LeftAmt).toFixed(2) + "",
                text: "Do you want to save this order?",
                icon: "warning",
                showCancelButton: true,
                closeOnClickOutside: false,
                buttons: {
                    cancel: {
                        text: "No",
                        value: null,
                        visible: true,
                        className: "btn-warning",
                        closeModal: true,
                    },
                    confirm: {
                        text: "Yes",
                        value: true,
                        visible: true,
                        className: "",
                        closeModal: true,
                    },
                }
            }).then(function (isConfirm) {
                if (isConfirm) {
                    printInvoice(PaymentMethod, LeftAmt);
                }
                else {

                    if (PaymentMethod == "Gift Card") {
                        ResetGiftCard();
                    }
                    else if (PaymentMethod == "Coupon") {
                        RemoveGift();
                    }
                    else if (PayMentMethod == "Royaltypoints") {
                        RoyaltyAmount = 0;
                        UsedRoyaltyPoints = 0;
                        $("#tblTransaction").find('.HappPointsPayment').remove();
                    }
                    else if (PayMentMethod == "Cash") {
                        GivenCash = 0;
                        $("#tblTransaction").find('.CashPayment').remove();
                    }

                    PayMentMethod = '';
                    PayButton = '';
                    OpenCashModal2();
                }
            });
        }
    }
}

function printInvoice(PaymentMode, LeftAmt, CardVal) {
    debugger;
    $('#loading').show();
    var CardTypeId = 0, LocalTransactionID = '', LastfourDigit = '';
    if (PaymentMode == 'Credit Card') {
        CardTypeId = CardType;
        LocalTransactionID = TrasactionID;
        LastfourDigit = CreditCardLastfourDigit;
    }
    data = {
        PaymentMode: PaymentMode,
        LeftAmt: LeftAmt,
        CustomerId: $("#hdnCustomerId").val(),
        Discount: $('#lbldiscount').text(),
        CardTypeId: CardTypeId,
        TransactionID: LocalTransactionID,
        CreditCardLastfourDigit: LastfourDigit,
        CouponCode: CouponNo,
        CouponAmt: CouponAmt,
        GIftCardCode: GiftCardNo,
        GiftCardAmt: GiftCardAmt,
        GiftCardLeftAmt: TempGiftCardLeftAmt,
        GiftCardUsedAmt: TempGiftCardUsedAmt,
        RoyaltyAmount: RoyaltyAmount,
        UsedRoyaltyPoints: UsedRoyaltyPoints,
        OrderId: $("#hdnOrderId").val().trim(),
        OrderNo: $("#hdnOrderNo").val().trim(),
        DraftId: ($('#hdnDraftId').val().trim() == '') ? 0 : $('#hdnDraftId').val().trim(),
    }
    //InvoiceProductTable = new Array();
    //var i = 0;
    //$("#tblProductDetail .product-addlist").each(function (index, item) {
    //    if ($(item).find('.SKUId').text() != '0') {
    //        debugger;
    //        InvoiceProductTable[i] = new Object();
    //        InvoiceProductTable[i].SKUId = $(item).find('.hdnSKUId').val();
    //        InvoiceProductTable[i].SKUName = $(item).find('.SKUName').html().trim();
    //        InvoiceProductTable[i].SchemeId = $(item).find('.hdnSchemeId').val();
    //        InvoiceProductTable[i].Quantity = $(item).find('.quantity').val();
    //        if ($(item).find('.SKUName').text().trim() == "Lottery Payout") {
    //            InvoiceProductTable[i].UnitPrice = '-' + $(item).find('.spnUnitPrice').text();
    //        }
    //        else {
    //            InvoiceProductTable[i].UnitPrice = $(item).find('.spnUnitPrice').text();
    //        }
    //        InvoiceProductTable[i].Tax = 0;
    //        InvoiceProductTable[i].Amount = 0;
    //        InvoiceProductTable[i].ProductAddedSeq = i;
    //        i++;
    //    }
    //});
    var j = 0;
    TransDetailTable = new Array();
    $("#tblTransaction tr").each(function (index, item) {
        TransDetailTable[j] = new Object();
        var Amt = $(item).find('.PaymentAmt').text().trim().replace(CSymbol, '');
        TransDetailTable[j].PaymentBy = $(item).find('.PaymentBy').text().trim();
        TransDetailTable[j].PaymentCode = '';
        TransDetailTable[j].PaymentAmt = parseFloat(Amt).toFixed(2);
        j++;
    });

    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false });
        return;
    }
    //var InvoiceTableValues = JSON.stringify(InvoiceProductTable);
    var TransactionTableValues = JSON.stringify(TransDetailTable);
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/GenerateInvoice",
        data: JSON.stringify({ dataValues: JSON.stringify(data), TransactionTableValues: TransactionTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'false') {
                swal("Error!", "Some error occured. Please try again later.", "error", { closeOnClickOutside: false }).then(function () {
                    POSReset();
                });
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                $('#loading').hide();
                TempGiftCartList = [];
                var title = '';
                var RAmt = parseFloat(LeftAmt).toFixed(2);
                var ReAmt = (CSymbol + (RAmt.toString())).replace(CSymbol + '-', '-' + CSymbol);
                if (parseFloat(LeftAmt) == 0) {   //.replace('$-', '-$')
                    title = "";
                }
                else {
                    title = "Return Amount: " + ReAmt + "";
                }
                swal({
                    title: title,
                    text: "Do you want to print the invoice?",
                    icon: "warning",
                    showCancelButton: true,
                    closeOnClickOutside: false,
                    buttons: {
                        cancel: {
                            text: "No",
                            value: null,
                            visible: true,
                            className: "btn-warning",
                            closeModal: true,
                        },
                        confirm: {
                            text: "Yes",
                            value: true,
                            visible: true,
                            className: "",
                            closeModal: true,
                        },
                    }
                }).then(function (isConfirm) {
                    if (isConfirm) {
                        window.open("/Pages/PrintSaleInvoice.html?dt=" + response.d, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
                        setTimeout(POSReset(), 3000);
                    }
                    else {
                        POSReset();
                    }
                })
            }
        },
        failure: function (result) {
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        },
        error: function (result) {
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function CloseAddScrModal() {
    $('#ClockInOutModal').modal('hide');
}
function DeleteHappyPointPaymentRow(e) {
    RoyaltyAmount = 0;
    UsedRoyaltyPoints = 0;

    $(e).closest('tr').remove();
    if ($("#tblTransaction tr").length == 0) {
        //$("#tblTransaction").hide();
    }
    calc_total();
}

function NewOrder() {

    if ($("#tblProductDetail .row").length > 0) {
        swal({
            title: "Are you sure?",
            text: "You want to reset cart list.",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "",
                    closeModal: true,
                }
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                var OrderNo = '', OrderId = '';
                OrderNo = localStorage.getItem("OrderNo");
                OrderId = localStorage.getItem("OrderId");
                if (OrderNo == '' || OrderNo == null) {
                    OrderNo = $('#hdnOrderId').val();
                    OrderId = $('#hdnOrderNo').val();
                }
                ResetCart(OrderNo, OrderId);
                localStorage.clear();
                $('#Lotterylbl').hide();
                $('#hdnOrderId').val('');
                $('#hdnOrderNo').val('');
                $('#txtSearchProduct').val('');
                $('#DiscType').text('(' + CSymbol + ')');
                EmptyProductList();
                FocusOnBarCode();
                AddWalkInCustomer();
            }
            else {
                $('#txtSearchProduct').val('');
                FocusOnBarCode();
            }
        })
    }
    else {
        $('#DiscType').text('(' + CSymbol + ')');
        $('#txtSearchProduct').val('');
        localStorage.clear();
        $('#hdnOrderId').val('');
        $('#hdnOrderNo').val('');
        swal("Warning!", "There is no product in cart list.", "warning", { closeOnClickOutside: false }).then(function () {
            AddWalkInCustomer();
            FocusOnBarCode();
        });
    }
}

function ResetCart(OrderNo, OrderId) {
    if ($("#tblProductDetail .row").length > 1) {
        var data = {
            OrderNo: OrderNo,
            OrderId: OrderId || 0
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/ResetCart",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'Session') {
                    $('#loading').hide();
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == 'false') {
                    swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
                    $('#loading').hide();
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var DraftName = xml.find("Table");
                    if (DraftName.length > 0) {
                        $('#txtDraftName').val($(DraftName).find("DraftName").text());
                        if ($(DraftName).find("DraftName").text() != '') {
                            $("#btnDraft").text("Update Draft");
                        }
                        else {
                            $("#btnDraft").text("Save Draft Order");
                        }
                    }
                    $('#ModalDraftOrder').modal('show');
                    $('#ModalAction').modal('hide');

                }

            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
                $('#loading').hide();
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
                $('#loading').hide();
            }
        });
    }
}
function EmptyProductList() {
    $('#totalQuantityCnt').text('0');
    $('#totalProductCnt').text('0');
    $("#tblProductDetail").text('');
    $("#lblsubtotal").text('0.00');
    $("#lblLottoPayout").text('0.00');
    $("#lblsubtotal1").text(CSymbol + '0.00');
    $("#lblLottery").text(CSymbol + '0.00');
    $("#lbldiscount").text('0.00');
    $("#lbldiscount1").text(CSymbol + '0.00');
    $("#lblcoupan").text('0.00');
    $("#lbltax").text('0.00');
    $("#lblgrandtotal").text('0.00');
    $("#lblgrandtotal1").text(CSymbol + '0.00');
    $("#hdnDraftId").text('');
    $("#DiscRemove").hide();
    $("#txt_PayNow").attr('disabled', 'disabled');
    PayMentMethod = '';
    ResetGiftCard();
    $('#lblOdrTotal').css('color', 'green');
    $('#lblgrandtotal1').css('color', 'green');
}
function OpenModalAction() {
    debugger;
    $('#ModalAction').modal('show');
    if ($("#tblProductDetail .row").length == 0) {
        if ((parseFloat($('#lblsubtotal').text()) + parseFloat($("#lbltax").text().replace(CSymbol, ''))) > 0) {
            $('#DiscBTN').removeAttr('disabled', 'disabled');
        }
        else {
            $('#DiscBTN').attr('disabled', 'disabled');
        }
    }
    else {
        debugger;
        if ((parseFloat($('#lblsubtotal').text()) + parseFloat($("#lbltax").text().replace(CSymbol, ''))) > 0 || parseFloat($('#lbldiscount').text()) > 0) {
            $('#DiscBTN').removeAttr('disabled', 'disabled');
        }
        else {
            $('#DiscBTN').attr('disabled', 'disabled');
        }
    }
}

function CloseModalAction() {
    $('#ModalAction').modal('hide');
    FocusOnBarCode();
}

/////////////////////////////////Start Draft Order//////////////////////////
function OpenDraftModal() {
    debugger;
    if ($("#tblProductDetail .row").length > 1) {
        var data = {
            OrderNo: $("#hdnOrderNo").val(),
            OrderId: $("#hdnOrderId").val() || 0
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/GetDraftDetail",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'Session') {
                    $('#loading').hide();
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == 'Draft Name already exists!') {
                    swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
                    $('#loading').hide();
                }
                else if (response.d == 'false') {
                    swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
                    $('#loading').hide();
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var DraftName = xml.find("Table");
                    if (DraftName.length > 0) {
                        $('#txtDraftName').val($(DraftName).find("DraftName").text());
                        if ($(DraftName).find("DraftName").text() != '') {
                            $("#btnDraft").text("Update Draft");
                        }
                        else {
                            $("#btnDraft").text("Save Draft Order");
                        }
                    }
                    $('#ModalDraftOrder').modal('show');
                    $('#ModalAction').modal('hide');
                }

            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
                $('#loading').hide();
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
                $('#loading').hide();
            }
        });
    }
    else {
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false });
    }
}

function SaveDraft() {
    $('#loading').show();
    if ($('#txtDraftName').val().trim() == '') {
        swal('Warning!', 'Please fill the draft name!', 'warning', { closeOnClickOutside: false });
        $('#loading').hide();
        return false;
    }
    var data = {
        DraftName: $('#txtDraftName').val().trim(),
        CustomerId: $('#hdnCustomerId').val(),
        OrderNo: $("#hdnOrderNo").val(),
        OrderId: $("#hdnOrderId").val() || 0
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/SaveDraft",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'Session') {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else if (response.d == 'Draft Name already exists!') {
                swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
                $('#loading').hide();
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
                $('#loading').hide();
            }
            else {
                localStorage.clear();
                $('#Lotterylbl').hide();
                $('#hdnOrderId').val('');
                $('#hdnOrderNo').val('');
                $('#txtSearchProduct').val('');

                $("#tblProductDetail").text('');
                $("#lblsubtotal").text('0.00');
                $("#lbldiscount").text('0.00');
                $("#lbldiscount1").text(CSymbol + '0.00');
                $("#lblcoupan").text('0.00');
                $("#lbltax").text('0.00');
                $("#lblgrandtotal").text('0.00');
                //$('#txtDraftName').val('');
                $('#loading').hide();
                FocusOnBarCode();
                AddWalkInCustomer();
                if ($("#btnDraft").text() == 'Update Draft') {
                    $('#lblOdrTotal').css('color', 'green');
                    $('#lblgrandtotal1').css('color', 'green');
                    $('#DiscType').text('(' + CSymbol + ')');
                    EmptyProductList();
                    FocusOnBarCode();
                    AddWalkInCustomer();
                    swal("Success!", "Draft Order Updated Successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        $('#ModalDraftOrder').modal('hide');
                        BindOrderDraftLogList();
                    });
                }
                else {
                    $('#lblOdrTotal').css('color', 'green');
                    $('#lblgrandtotal1').css('color', 'green');
                    $('#DiscType').text('(' + CSymbol + ')');
                    EmptyProductList();
                    FocusOnBarCode();
                    AddWalkInCustomer();
                    swal("Success!", "Draft Order Saved Successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        $('#ModalDraftOrder').modal('hide');
                        BindOrderDraftLogList();
                    });
                }

                //$('#ModalDraftOrder').modal('hide');
            }

        },
        failure: function (result) {
            console.log(JSON.parse(result.responseText).d);
            $('#loading').hide();
        },
        error: function (result) {
            console.log(JSON.parse(result.responseText).d);
            $('#loading').hide();
        }
    });
}

function BindOrderDraftLogList() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BindOrderDraftLogList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

            if (response.d == "false") {
                window.location.href = '/Default.aspx'
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Product = xml.find("Table");
                $('#tblOrderLog tbody').empty();
                if (Product.length > 0) {
                    $("#tblOrderLog").show();
                    $.each(Product, function () {
                        var DName = "'" + $(this).find("DraftName").text().toString() + "'";
                        var Html = '';
                        Html += '<tr>';
                        Html += '<td class="Action1 text-center"><a id="deleterow"  title="Remove" onclick="deleteDraftItem(\'' + $(this).find("OrderNo").text() + '\')"><span class="fa fa-times" style="color: red;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;<a id="deletedraft" title="Open Draft Order" onclick="BindDraftOrder(\'' + $(this).find("OrderNo").text() + '\')"><span class=" fa fa-plus-square" style="color: blue;"></span></a></td>';
                        Html += '<td class="OrderId text-center" style="display:none;">' + $(this).find("OrderId").text() + '</td>';
                        Html += '<td class="OrderNo">' + $(this).find("OrderNo").text() + '</td>';
                        Html += '<td class="CustName" style="text-align:center">' + $(this).find("CustName").text() + '</td>';
                        Html += '<td class="DraftName" style="text-align:center">' + $(this).find("DraftName").text() + '</td>';
                        Html += '<td class="DraftDate text-center" style="width: 6%;">' + $(this).find("DraftDateTime").text() + '</td>';
                        Html += '<td class="Type" style="display:none">' + $(this).find("Type").text() + '</td>';
                        Html += '<td class="User" style="text-align:center">' + $(this).find("UserName").text() + '</td>';
                        Html += '</tr>';
                        $("#emptyTable1").hide();
                        $("#tblOrderLogBody").append(Html);
                    });
                    $('#ModalDraftLog').modal('show');
                    $('#ModalAction').modal('hide');
                }
                else {
                    $("#emptyTable1").show();
                    $("#tblOrderLog").hide();
                    $('#ModalDraftLog').modal('show');
                    $('#ModalAction').modal('hide');
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

function BindDraftOrder(OrderNo) {
    if ($("#tblProductDetail .row").length > 1 && (OrderNo != $("#hdnOrderNo").val())) {
        swal({
            title: "Warning!",
            text: "Do you want to reset current cart?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "",
                    closeModal: true,
                },
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                BindDraftOrderConfirmed(OrderNo);
            }
        });
    }
    else {
        BindDraftOrderConfirmed(OrderNo);
    }
}

function BindDraftOrderConfirmed(OrderNo) {
    if (OrderNo != '' && OrderNo != undefined) {
        var data = {
            CustomerId: 0,
            OrderNo: OrderNo,
            OrderId: 0
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/GetCart",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                debugger;
                if (response.d == 'false') {
                    swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    var JsonObj = $.parseJSON(response.d);
                    if (JsonObj.length > 0) {
                        AddInCart(JsonObj);
                    }
                    if ($("#tblProductDetail .product-addlist").length > 0) {
                        $('#txt_PayNow').removeAttr('disabled');
                    }
                    else {
                        $('#txt_PayNow').attr('disabled', 'disabled');
                    }

                    $('#ModalDraftLog').modal('hide');
                }
            },
            failure: function (result) {
                console.log(JSON.parse(result.responseText).d);
            },
            error: function (result) {
                console.log(JSON.parse(result.responseText).d);
            }
        });
    }
    FocusOnBarCode();
}



function ConfirmDraftList(response) {

    EmptyProductList();
    var xmldoc = $.parseXML(response.d);
    var xml = $(xmldoc);
    var Product = xml.find("Table");
    var itemDetail = xml.find("Table1");
    var DraftMaster = xml.find("Table2");

    if (Product.length > 0) {

        CreateTable(Product, itemDetail);
        if (DraftMaster.length > 0) {
            $("#lbldiscount").text(parseFloat($(DraftMaster).find('Discount').text()).toFixed(2));
            $("#lbldiscount1").text(CSymbol + parseFloat($(DraftMaster).find('Discount').text()).toFixed(2));
            $("#hdnCustomerId").val($(DraftMaster).find('CustomerId').text());
            $("#ddlCustomer").val($(DraftMaster).find('CustomerName').text());
        }
        calc_total();
        $('#ModalDraftLog').modal('hide');
    }
    else {
        swal('', 'There is no product in this draft!', 'warning', { closeOnClickOutside: false });
    }
}
//////////////////////////////////End Draft Order///////////////////////////

var ModalOpenFor = '';
/////////////////////////////////Start Discout Order////////////////////////openCal('Discount')"

function openDisc() {
    debugger;
    if ($('#hdnEmpId').val() == 4) {
        $('#txtpasswordD').val('');
        $('#ModalAction').modal('hide');
        $('#ModalDiscount').modal('show');
        $('#txtpasswordD').focus();
    }
    else {
        openCal('Discount');
    }
}

function CloseModalDiscount() {
    $('#txtpasswordD').val('');
    $('#ModalDiscount').modal('hide');
    FocusOnBarCode();
}

function ViewPasswordDisc() {

    if ($('#txtpasswordD').prop('type') == 'password') {
        $('#txtpasswordD').prop("type", "text");
    }
    else {
        $('#txtpasswordD').prop("type", "password");
    }
}

function GiveDiscount() {
    var validate = 1;
    if ($('#txtpasswordD').val().trim() == '') {
        toastr.error('Please enter Discount pin.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/GiveDiscount",
            data: "{'password':'" + $('#txtpasswordD').val().trim() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "Some error occured!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpassword').val('');
                    });
                } else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == "failed") {
                    swal("", "Access Denied!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpasswordD').val('');
                    });
                }
                else if (response.d == "Success") {
                    $('#ModalDiscount').modal('hide');
                    openCal('Discount');
                }
                else {
                    window.location.href = "/Default.aspx"
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
function openCal(Modal) {
    debugger;
    ModalOpenFor = Modal;
    if (ModalOpenFor != "LottoPay" && ModalOpenFor != "LottoSale") {
        if ($("#tblProductDetail .row").length > 0) {
            $('#result').val('');
            if (ModalOpenFor != "Discount") {
                $('#TR_Disc').hide();
                $('#Cal_Head').text('Custom Pay');
            } else {
                $('#TR_Disc').show();
                $('#switchYearly').prop("checked", false);
                $('#switchMonthly').prop("checked", true);
                $('#Cal_Head').text('Discount');
            }

            $('#Calcu_Header').show();
            $('#ModalCalculator').modal('show');
            $('#ModalAction').modal('hide');
            $('#ModalCash').modal('hide');
        }
        else {
            $('#result').val('');
            ModalOpenFor = '';
            swal("", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false });
            return false;
        }
    }
    else {
        $('#result').val('');
        if (ModalOpenFor != "LottoPay") {
            $('#TR_Disc').hide();
            $('#Cal_Head').text('Lottery Sale');
        } else if (ModalOpenFor == "Discount") {
            $('#TR_Disc').show();
            $('#Cal_Head').text('Discount');
        }
        else {
            $('#TR_Disc').hide();
            $('#Cal_Head').text('Lottery Payout');
        }
        $('#Calcu_Header').show();
        $('#ModalCalculator').modal('show');
        $('#ModalAction').modal('hide');
        $('#ModalCash').modal('hide');
    }
}

function CancelDiscount() {
    swal({
        title: "Warning!",
        text: "Do you want to remove Discount?",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            },
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            var OrderNo = '';
            if (localStorage.getItem("OrderNo") != '') {
                OrderNo = localStorage.getItem("OrderNo");
            }
            else {
                OrderNo = $("#hdnOrderNo").val();
            }
            var data = {
                CustomerId: $("#hdnCustomerId").val(),
                OrderNo: OrderNo,
                Discount: parseFloat('0').toFixed(2),
                Type: ''
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/AddDiscount",
                data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    debugger;
                    if (response.d == 'false') {
                        swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        debugger;
                        var JsonObj = $.parseJSON(response.d);
                        if (parseFloat(JsonObj[0].OrderDetail[0].Discount) > 0) {
                            $('#DiscRemove').show();
                        }
                        else {
                            $('#DiscRemove').hide();
                        }
                        closeCalModal();
                        //AddInCart(JsonObj);
                        if (parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0 || parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0) {
                            $('#Lotterylbl').show();
                        }
                        else {
                            $('#Lotterylbl').hide();
                        }
                        $('#lblLottery').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));

                        $('#lblLottoPayout').text(parseFloat(JsonObj[0].OrderDetail[0].LotteryPayout).toFixed(2));
                        $('#lbldiscount1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lbldiscount').text(parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2));
                        if (JsonObj[0].OrderDetail[0].DiscType == 'Percentage') {
                            $('#DiscType').text('(' + parseFloat(JsonObj[0].OrderDetail[0].DiscountPer).toFixed(2) + '%)');
                        }
                        else {
                            $('#DiscType').text('(' + CSymbol + ')');
                        }

                        $('#lblsubtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Subtotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lblsubtotal').text(JsonObj[0].OrderDetail[0].Subtotal);
                        $('#lbltax').text(parseFloat(JsonObj[0].OrderDetail[0].TotalTax).toFixed(2));
                        $('#lblgrandtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].OrderTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lblgrandtotal').text(JsonObj[0].OrderDetail[0].OrderTotal);


                    }
                },
                failure: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                }
            });
        }
    });
}

function SubmitDsicount() {
    debugger;
    $('#btnCalButton').attr('disabled', 'disabled');
    if (ModalOpenFor == 'Discount') {
        var check = 0;
        if ($('#result').val().trim() == '' || $('#result').val().trim() == '.') {
            swal('', 'Please fill discount amount!', 'warning', { closeOnClickOutside: false });
            check = 1;
            return false;
        }
        debugger;
        if ($("input[name='DiscType']:checked").val() != "Per") {
            debugger;
            if (parseFloat($('#result').val()) > (parseFloat($('#lblsubtotal').text()) + parseFloat($('#lbltax').text()))) {
                debugger;
                $('#result').val('');
                $('#btnCalButton').removeAttr('disabled');
                closeCalModal();
                swal("", "Discount amount can't be greater than total amount!", "warning", { closeOnClickOutside: false });
                check = 1;
                return false;
            }
        }
        else {
            debugger;
            if (parseFloat($('#result').val()) > 100) {
                $('#btnCalButton').removeAttr('disabled');
                swal("", "Discount Percentage can't be greater than 100%.", "warning", { closeOnClickOutside: false });
                check = 1;
            }
            else if ($('#result').val().trim() == '' || $('#result').val().trim() == '.') {
                $('#btnCalButton').removeAttr('disabled');
                swal("", "Please fill discount percentage.", "warning", { closeOnClickOutside: false });
                check = 1;
            }
        }
        if (check == 0) {
            var data = {
                CustomerId: $("#hdnCustomerId").val(),
                OrderNo: $("#hdnOrderNo").val(),
                Discount: parseFloat($('#result').val()).toFixed(2),
                Type: $("input[name='DiscType']:checked").val()
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/AddDiscount",
                data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    debugger;
                    if (response.d == 'false') {
                        $('#btnCalButton').removeAttr('disabled');
                        swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        debugger;
                        var JsonObj = $.parseJSON(response.d);
                        //AddInCart(JsonObj);
                        if (parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0 || parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0) {
                            $('#Lotterylbl').show();
                        }
                        else {
                            $('#Lotterylbl').hide();
                        }
                        $('#lblLottery').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lblLottoPayout').text(parseFloat(JsonObj[0].OrderDetail[0].LotteryPayout).toFixed(2));
                        $('#lbldiscount1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lbldiscount').text(parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2));
                        if (JsonObj[0].OrderDetail[0].DiscType == 'Percentage') {
                            $('#DiscType').text('(' + parseFloat(JsonObj[0].OrderDetail[0].DiscountPer).toFixed(2) + '%)');
                        }
                        else {
                            $('#DiscType').text('(' + CSymbol + ')');
                        }

                        $('#lblsubtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Subtotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lblsubtotal').text(JsonObj[0].OrderDetail[0].Subtotal);
                        $('#lbltax').text(parseFloat(JsonObj[0].OrderDetail[0].TotalTax).toFixed(2));
                        $('#lblgrandtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].OrderTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                        $('#lblgrandtotal').text(JsonObj[0].OrderDetail[0].OrderTotal);

                        if (parseFloat(JsonObj[0].OrderDetail[0].Discount) > 0) {
                            $('#DiscRemove').show();
                        }
                        else {
                            $('#DiscRemove').hide();
                        }
                        $('#btnCalButton').removeAttr('disabled');
                        closeCalModal();
                    }
                },
                failure: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                }
            });
        }
    }

    else if (ModalOpenFor == 'CustomPay') {
        if ($('#result').val().trim() == '' || $('#result').val().trim() == '.') {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Please fill Paid Amount!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else if (parseFloat($('#result').val().trim()) <= 0) {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Please fill Paid Amount!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else {
            $('#btnCalButton').removeAttr('disabled');
            var CustomCash = 0;
            $('#ModalCalculator').modal('hide');
            $('#ModalCash').modal('show');
            $('#PaidAmt').attr('readonly', 'readonly');
            $('#PaidAmt').val(parseFloat($('#result').val()).toFixed(2));
            CustomCash = isNaN(parseFloat($('#PaidAmt').val())) ? 0 : parseFloat($('#PaidAmt').val());
            $('#PaidAmt').change();
            Cal_Cash(CustomCash);
        }
    }
    else if (ModalOpenFor == 'LottoPay') {
       
        var CurrentAmt = 0;
        var LottoPayoutAmt = 0, Quantity = 0, UnitPrice = 0;
        $('#tblProductDetail .product-addlist').each(function () {
            Quantity = $(this).find('.quantity').val();
            UnitPrice = $(this).find('.spnUnitPrice').text().replace(CSymbol, '');
            if ($(this).find('.SKUName').text() == 'Lottery Payout') {
                LottoPayoutAmt = LottoPayoutAmt + (parseFloat(Quantity) * parseFloat(UnitPrice));
            }
        });
        CurrentAmt = parseFloat(CurrentCash());
        if ($('#result').val().trim() == '' || $('#result').val().trim() == '.') {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Please Fill Lottery Pay Amount!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else if (parseFloat($('#result').val().trim()) <= 0) {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Lottery pay amount can not be zero!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else if (CurrentAmt < (parseFloat($('#result').val().trim()) + LottoPayoutAmt)) {
            swal({
                text: "You don't have enough cash. Do you want to proceed?",
                icon: "warning",
                showCancelButton: true,
                closeOnClickOutside: false,
                buttons: {
                    confirm: {
                        text: "Yes",
                        value: true,
                        visible: true,
                        className: "btn-success",
                        closeModal: true,
                    },
                    cancel: {
                        text: "No",
                        value: null,
                        visible: true,
                        className: "btn-danger",
                        closeModal: true,
                    },
                }
            }).then(function (isConfirm) {
                debugger;
                if (isConfirm) {
                    var SKUName = 'Lottery Payout';
                    var data = {
                        CustomerId: $("#hdnCustomerId").val(),
                        SKUAutoId: 0,
                        OrderNo: $("#hdnOrderNo").val(),
                        OrderId: $("#hdnOrderId").val() || 0,
                        Quantity: 1,
                        SKUName: SKUName,
                        SKUAmt: parseFloat('-' + $('#result').val()).toFixed(2),
                        GiftCardCode: '',
                        CartItemId: 0,
                        Age: 0
                    }
                    $.ajax({
                        type: "POST",
                        url: "/Pages/POS.asmx/AddToCart",
                        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            debugger;
                            if (response.d == 'false') {
                                $('#btnCalButton').removeAttr('disabled');
                                swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                            }
                            else if (response.d == "Session") {
                                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                                    window.location.href = "/Default.aspx";
                                });
                            }
                            else {
                                debugger;
                                var JsonObj = $.parseJSON(response.d);

                                if (JsonObj.length > 0) {
                                    AddInCart(JsonObj);
                                }
                                if ($("#tblProductDetail .product-addlist").length > 0) {
                                    $('#txt_PayNow').removeAttr('disabled');
                                }
                                else {
                                    $('#txt_PayNow').attr('disabled', 'disabled');
                                }
                                $('#btnCalButton').removeAttr('disabled');
                            }
                        },
                        failure: function (result) {
                            $('#btnCalButton').removeAttr('disabled');
                            console.log(JSON.parse(result.responseText).d);
                        },
                        error: function (result) {
                            $('#btnCalButton').removeAttr('disabled');
                            console.log(JSON.parse(result.responseText).d);
                        }
                    });
                    $('#btnCalButton').removeAttr('disabled');
                    $('#ModalCalculator').modal('hide');
                    //calc_total();
                }
                else {
                    $('#btnCalButton').removeAttr('disabled');
                    $('#ModalCalculator').modal('hide');
                }
            });
        }
        else {
            debugger;
            var SKUName = 'Lottery Payout';
            //var GiftCardCode = '';
            var data = {
                CustomerId: $("#hdnCustomerId").val(),
                SKUAutoId: 0,
                OrderNo: $("#hdnOrderNo").val(),
                OrderId: $("#hdnOrderId").val() || 0,
                Quantity: 1,
                SKUName: SKUName,
                SKUAmt: parseFloat('-' + $('#result').val()).toFixed(2),
                GiftCardCode: '',
                CartItemId: 0,
                Age: 0
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/AddToCart",
                data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    debugger;
                    if (response.d == 'false') {
                        $('#btnCalButton').removeAttr('disabled');
                        swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        debugger;
                        var JsonObj = $.parseJSON(response.d);

                        if (JsonObj.length > 0) {
                            AddInCart(JsonObj);
                        }
                        if ($("#tblProductDetail .product-addlist").length > 0) {
                            $('#txt_PayNow').removeAttr('disabled');
                        }
                        else {
                            $('#txt_PayNow').attr('disabled', 'disabled');
                        }
                        $('#btnCalButton').removeAttr('disabled');
                    }
                },
                failure: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                }
            });
            $('#btnCalButton').removeAttr('disabled');
            $('#ModalCalculator').modal('hide');
            //calc_total();
        }
    }
    else if (ModalOpenFor == 'LottoSale') {
        if ($('#result').val().trim() == '' || $('#result').val().trim() == '.') {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Please Fill Lottery Sale Amount!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else if (parseFloat($('#result').val().trim()) <= 0) {
            $('#btnCalButton').removeAttr('disabled');
            swal('', 'Lottery Sale amount can not be zero!', 'warning', { closeOnClickOutside: false });
            return false;
        }
        else {
            var SKUName = 'Lottery Sale';
            //var GiftCardCode = '';
            var data = {
                CustomerId: $("#hdnCustomerId").val(),
                SKUAutoId: 0,
                OrderNo: $("#hdnOrderNo").val(),
                OrderId: $("#hdnOrderId").val() || 0,
                Quantity: 1,
                SKUName: SKUName,
                SKUAmt: parseFloat($('#result').val()).toFixed(2),
                GiftCardCode: '',
                CartItemId: 0,
                Age: 0
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/AddToCart",
                data: JSON.stringify({ dataValues: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    debugger;
                    if (response.d == 'false') {
                        $('#btnCalButton').removeAttr('disabled');
                        swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                    }
                    else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else {
                        debugger;
                        var JsonObj = $.parseJSON(response.d);

                        if (JsonObj.length > 0) {
                            AddInCart(JsonObj);
                        }
                        if ($("#tblProductDetail .product-addlist").length > 0) {
                            $('#txt_PayNow').removeAttr('disabled');
                        }
                        else {
                            $('#txt_PayNow').attr('disabled', 'disabled');
                        }
                        $('#btnCalButton').removeAttr('disabled');
                    }
                },
                failure: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                },
                error: function (result) {
                    $('#btnCalButton').removeAttr('disabled');
                    console.log(JSON.parse(result.responseText).d);
                }
            });

            $('#ModalCalculator').modal('hide');
            //calc_total();
        }
    }
}

function closeCalModal() {
    $('#ModalCalculator').modal('hide');
    $('#Calcu_Header').hide();
    if (ModalOpenFor == 'Discount') {
        //$('#ModalAction').modal('show');
    }
    else if (ModalOpenFor == 'CustomPay') {
        $('#ModalCash').modal('show');
    }
}
/////////////////////////////////End Discout Order//////////////////////////


/////////////////////////////////Start Add To Home////////////////////////

function OpenAddtoHome() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindScreen",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

            if (response.d == 'false') {
                $('#loading').hide();
                swal("", "No Screen Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ScreenList = xml.find("Table");
                if (ScreenList.length == 0) {
                    swal("", "Please Add Screen First!", "warning", { closeOnClickOutside: false });
                    return;
                }
                bindDepartment();
                bindScreenDDL();
                $('#txtAddToHomeProduct').val('');
                $("#ddlDepartment").val(0).select();
                AddToHomeProduct(1);
                $('#ModalAction').modal('hide');
                $('#ModalAddToHome').modal('show');
                $('#loading').hide();
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
function ImageError(evt) {
    evt.onerror = null;
    evt.src = '/Images/ProductImages/product.png';
}
function AddToHomeProduct(PageIndex) {

    $('#loading').show();

    data = {
        ScreenId: $("#ddlScreen").val() || 0,
        Department: $("#ddlDepartment").val() || 0,
        ProductName: $("#txtAddToHomeProduct").val(),
        pageSize: $("#ddlAddToHomePageSize").val(),
        PageIndex: PageIndex,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/AddToHomeProduct",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {

            if (response.d == "false") {
                $('#loading').hide();
            } else if (response.d == "Session") {
                $('#loading').hide();
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var pager = xml.find("Table");
                var ProductList = xml.find("Table1");

                if (ProductList.length > 0) {
                    if (pager.length > 0) {
                        $("#spAddToHomeSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlAddToHomePageSize').show();
                    }
                    else {
                        $('#ddlAddToHomePageSize').hide();
                    }
                    $("#AddToHomeEmptyTable").hide();
                    $("#spAddToHomeSortBy").show();
                    //$("#ddlAddToHomePageSize").show();
                    $("#divAddToHomeProductList").show();
                    html = "";
                    $.each(ProductList, function () {

                        html = html + '<div class="row" style="padding-right: 10px;">'
                        html = html + '<div class="col-md-2"><img src="../Images/ProductImages/' + $(this).find("ImagePath").text() + '" onerror="ImageError(this)";" class="product-img" /></div>';
                        html = html + '<div class="col-md-6">' + $(this).find("ProductName").text() + '</div>';
                        if ($(this).find("Type").text() == 'Product') {
                            if ($(this).find("Checked").text() == 0) {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'Product' + '\')" class="savedraft-btn btn btn-primary">Remove From Screen</button></div>';
                            }
                            else {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'Product' + '\')" class="cash-btn btn btn-primary">Add To Screen</button></div>';
                            }
                        }
                        else if ($(this).find("Type").text() == 'SKU') {
                            if ($(this).find("Checked").text() == 0) {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'SKU' + '\')" class="savedraft-btn btn btn-primary">Remove From Screen</button></div>';
                            }
                            else {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'SKU' + '\')" class="cash-btn btn btn-primary">Add To Screen</button></div>';
                            }
                        }
                        else if ($(this).find("Type").text() == 'Scheme') {
                            if ($(this).find("Checked").text() == 0) {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'Scheme' + '\')" class="savedraft-btn btn btn-primary">Remove From Screen</button></div>';
                            }
                            else {
                                html = html + '<div class="col-md-4" style="padding: 0px 15px 0px 0px;"><button type="button" onclick="AddToProductScreen(' + $(this).find("AutoId").text() + ',this,\'' + 'Scheme' + '\')" class="cash-btn btn btn-primary">Add To Screen</button></div>';
                            }
                        }
                        html = html + '<div class="col-md-12"><hr style="margin-top: 10px; margin-bottom: 10px;" /></div>';
                        html = html + '</div>';
                    });
                    $("#divAddToHomeProductList").html(html);
                }
                else {
                    $("#AddToHomeEmptyTable").show();
                    $("#spAddToHomeSortBy").hide();
                    $("#ddlAddToHomePageSize").hide();
                    $("#divAddToHomeProductList").hide();
                }

                $("#AddToHomePager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });

                if ($('#ddlAddToHomePageSize').val() == '0') {
                    $('#AddToHomePager').hide();
                }
                else {
                    $('#AddToHomePager').show();
                }

                $('#loading').hide();
            }
        },
        failure: function (result) {
            $('#loading').hide();
            console.log(result.d);
        },
        error: function (result) {
            $('#loading').hide();
            console.log(result.d);
        }
    });
}
function AddToProductScreen(AutoId, evt, Type) {

    var SName = $("#ddlScreen :selected").text();
    if (AutoId != '' && AutoId != undefined) {
        data = {
            ScreenId: $("#ddlScreen").val() || 0,
            ProductAutoId: AutoId,
            Type: Type
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/AddToProductScreen",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == "false") {
                    window.location.href = '/Default.aspx'
                } else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    BindProductList(1);
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SuccessText = xml.find("Table");
                    var temp = $(evt).parent();
                    if ($(SuccessText).find('SuccessCode').text() == '1') {
                        $(temp).html('<button type="button" onclick="AddToProductScreen(' + AutoId + ',this,\'' + Type + '\')" class="savedraft-btn btn btn-primary" > Remove From Screen</button >');
                        toastr.success('Product added in ' + SName + '!', 'Message', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });

                    }
                    else {
                        $(temp).html('<button type="button" onclick="AddToProductScreen(' + AutoId + ',this,\'' + Type + '\')" class="cash-btn btn btn-primary" > Add To Screen</button >');
                        toastr.success('Product removed from ' + SName + ' successfully!', 'Message', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
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
    else {
        swal('Error!', 'Can not add to favorite', 'error', { closeOnClickOutside: false });
    }
}
function AddToFavorite(AutoId, evt) {
    if (AutoId != '' && AutoId != undefined) {
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/AddToFavorite",
            data: "{'ProductAutoId':'" + AutoId + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == "false") {
                    window.location.href = '/Default.aspx'
                } else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    BindProductList(1);
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SuccessText = xml.find("Table");
                    var temp = $(evt).parent();
                    if ($(SuccessText).find('SuccessCode').text() == '1') {
                        $(temp).html('<button type="button" onclick="AddToFavorite(' + AutoId + ',this)" class="savedraft-btn btn btn-primary" > Remove From Home</button >');
                    }
                    else {
                        $(temp).html('<button type="button" onclick="AddToFavorite(' + AutoId + ',this)" class="cash-btn btn btn-primary" > Add To Home</button >');
                    }
                    toastr.success($(SuccessText).find('SuccessText').text(), 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
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
    else {
        swal('Error!', 'Can not add to favorite', 'error', { closeOnClickOutside: false });
    }
}

function CloseAddToHome() {
    $('#ModalAddToHome').modal('hide');
    FocusOnBarCode();
}
//////////////////////////////////End Add To Home/////////////////////////
function openCustomerModal() {

    $("#txtSName").val("");
    $("#txtSMobileNo").val("");
    $("#txtSEmailId").val("");
    SearchCustomer(1);
}

function OpenAddCustomerModal() {
    $("#txtFirstName").val("");
    $("#txtLastName").val("");
    $("#txtMobileNo").val("");
    $("#txtDOB").val("");
    $("#txtEmailId").val("");
    $("#txtCity").val("");
    $("#txtState").val("0").select2();
    $("#txtZipCode").val("");
    $("#txtAddress").val("");
    $('#SearchCustomerModal').modal('hide');
    $('#AddCustomerModal').modal('show');
    $('.GiftSection').hide();
    $('#btnAddCustomer').show();
    $('#NewCustomer').show();
}

function AddCustomer() {
    var validate = 1;
    if ($("#txtFirstName").val().trim() == "") {
        toastr.error('Please fill first name!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFirstName").addClass('border-warning');
        validate = 0;
        return false;
    }
    else if ($("#txtMobileNo").val().trim() == "") {
        toastr.error('Please fill Mobile No.!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtMobileNo").addClass('border-warning');
        validate = 0;
        return false;
    }
    //else if ($("#txtEmailId").val().trim() == "") {
    //    toastr.error('Please fill Email ID!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtEmailId").addClass('border-warning');
    //    validate = 0;
    //    return false;
    //}
    else if ($("#txtZipCode").val().trim() != "" && $("#txtZipCode").val().length != 5) {
        toastr.error('Please fill valid Zip Code!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtZipCode").addClass('border-warning');
        validate = 0;
        return false;
    }
    else if ($("#txtMobileNo").val().trim().length > 1) {
        if ($("#txtMobileNo").val().trim().length != 10) {
            toastr.error('Mobile no must be of 10 digit!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            $("#txtMobileNo").addClass('border-warning');
            validate = 0;
            return false;
        }
    }
    var regEmail = new RegExp(/^([\w+-.%]+@[\w-.]+\.[A-Za-z]{2,4},?)+$/);
    if (!regEmail.test($("#txtEmailId").val().replace(" ", "").trim()) && $("#txtEmailId").val().trim() != "") {
        toastr.error('Invalid Email ID', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEmailId").addClass('border-warning');
        validate = 0;
        return false;
    }

    if (validate == 1) {
        var data = {
            FirstName: $("#txtFirstName").val().trim(),
            LastName: $("#txtLastName").val().trim(),
            MobileNo: $("#txtMobileNo").val().trim(),
            DOB: $("#txtDOB").val().trim(),
            EmailId: $("#txtEmailId").val().trim(),
            Address: $("#txtAddress").val().trim(),
            City: $("#txtCity").val().trim(),
            State: $("#txtState").val(),
            ZipCode: $("#txtZipCode").val().trim(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/AddCustomer",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'Mobile no. already exists!') {
                    swal("", response.d, "error", { closeOnClickOutside: false });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var CustomerDeatil = xml.find("Table");
                    FocusOnBarCode();
                    $("#hdnCustomerId").val($(CustomerDeatil).find("AutoId").text());
                    $("#ddlCustomer").val($(CustomerDeatil).find("Name").text());
                    ResetCustomer();
                    swal("success", "Customer added successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        $('#AddCustomerModal').modal('hide');
                        FocusOnBarCode();
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

function ResetCustomer() {
    $("#txtFirstName").val('').removeAttr('disabled');
    $("#txtLastName").val('');
    $("#txtMobileNo").val('').removeAttr('disabled');
    $("#txtDOB").val('');
    $("#txtEmailId").val('');
    $("#txtAddress").val('');
    $("#txtCity").val('');
    $("#txtState").val('0');
    $("#txtBarcode").val('');
    $("#txtGiftNo").val('');
    $("#txtGiftAmount").val('0.00');
    FocusOnBarCode();
}

function SearchCustomer(pageIndex) {

    var data = {
        CustomerId: $("#txtCustId").val().trim(),
        Name: $("#txtSName").val().trim(),
        MobileNo: $("#txtSMobileNo").val().trim(),
        EmailId: $("#txtSEmailId").val().trim(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize1").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/SearchCustomer",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'false') {
                swal("", "Some error occured!", "error", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CustomerList = xml.find("Table1");
                var pager = xml.find("Table");
                if (CustomerList.length > 0) {

                    if (pager.length > 0) {
                        $("#spSearchCustomerSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize1').show();
                    }
                    else {
                        $('#ddlPageSize1').hide();
                    }
                    $("#spSearchCustomerSortBy").show();
                    //$("#ddlPageSize1").show();
                    $("#DivPager1").show();
                    $("#SearchListemptyTable").hide();
                    $("#tblCustomerList tbody tr").remove();
                    $.each(CustomerList, function () {
                        var TP = 0;
                        if ($(this).find("TotalPurchase").text() > 0) { TP = parseFloat($(this).find("TotalPurchase").text()).toFixed(2); }
                        var Html = '';
                        Html += '<tr>';
                        Html += '<td class="CustomerAction text-center" style="width: 4%;"><a id ="btnAddCustomer" title = "Select this customer" onclick = "AddThisCustomer(this)" > <span class="fa fa-plus-square" style="color: blue;"></span></a></td>';
                        Html += '<td class="CustomerId text-center" style="display: none;">' + $(this).find("AutoId").text() + '</td>';
                        Html += '<td class="DOBC text-center" style="display: none;">' + $(this).find("DOB").text() + '</td>';
                        Html += '<td class="CustomerIdG text-center">' + $(this).find("CustomerId").text() + '</td>';
                        Html += '<td class="CustomerName text-center">' + $(this).find("Name").text() + '</td>';
                        Html += '<td class="MobileNo text-center" style="white-space: nowrap;">' + $(this).find("MobileNo").text() + '</td>';
                        Html += '<td class="EmailId text-center" style="">' + $(this).find("EmailId").text() + '</td>';
                        Html += '<td class="TotalPurchase text-center" style="text-align:right">' + TP + '</td>';
                        Html += '<td class="RoyaltyPoints text-center" style="">' + $(this).find("RoyaltyPoint").text() + '</td>';
                        Html += '</tr>';
                        $("#tblCustomerList").append(Html);
                        Html = $("#tblCustomerList tbody tr:last-child").clone(true);
                    });
                    $("#tblCustomerList").show();
                }
                else {
                    $("#SearchListemptyTable").show();
                    $("#tblCustomerList").hide();
                    $("#spSearchCustomerSortBy").hide();
                    $("#DivPager1").hide();
                    $("#ddlPageSize1").show();
                }
                $("#SearchCustomerPager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSize1').val() == '0') {
                    $('#SearchCustomerPager').hide();
                }
                else {
                    $('#SearchCustomerPager').show();
                }
                $('#SearchCustomerModal').modal('show');
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

function AddThisCustomer(e) {
    var CustomerId = $(e).closest('tr').find(".CustomerId").text();
    var DOB = $(e).closest('tr').find(".DOBC").text();
    var CustomerName = $(e).closest('tr').find(".CustomerName").text();
    var RoyaltyPoints = $(e).closest('tr').find(".RoyaltyPoints").text();

    $("#hdnCustomerId").val(CustomerId);
    $("#hdnCustomerDOB").val(DOB);
    $("#ddlCustomer").val(CustomerName.trim());
    $("#hdnRoyaltyPoints").val(isNaN(parseInt(RoyaltyPoints)) ? 0 : parseInt(RoyaltyPoints));
    $("#txtAvlHappyPoints").val(isNaN(parseInt(RoyaltyPoints)) ? 0 : parseInt(RoyaltyPoints));
    $('#SearchCustomerModal').modal('hide');
    debugger;
    GetCart();
    //if (CustomerName.trim() == 'Walk In') {
    //var OrderNo = '', OrderId = 0;
    //if (localStorage.getItem("OrderNo") != '') {
    //    OrderNo = localStorage.getItem("OrderNo");
    //}
    //else {
    //    OrderNo = $("#hdnOrderNo").val();
    //}
    //if (localStorage.getItem("OrderId") != '') {
    //    OrderId = localStorage.getItem("OrderId");
    //}
    //else {
    //    OrderId = $("#hdnOrderNo").val();
    //}
    //var data = {
    //    CustomerId: $("#hdnCustomerId").val(),
    //    OrderNo: OrderNo,
    //    OrderId: OrderId || 0,
    //}
    //$.ajax({
    //    type: "POST",
    //    url: "/Pages/POS.asmx/DeleteGiftCard",
    //    data: JSON.stringify({ dataValues: JSON.stringify(data) }),
    //    contentType: "application/json; charset=utf-8",
    //    dataType: "json",
    //    async: false,
    //    success: function (response) {
    //        debugger;
    //        if (response.d == 'false') {
    //            swal("", "Product not found!", "warning", { closeOnClickOutside: false });
    //        }
    //        else if (response.d == "Session") {
    //            swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
    //                window.location.href = "/Default.aspx";
    //            });
    //        }
    //        else {
    //            debugger;
    //            var JsonObj = $.parseJSON(response.d);
    //            AddInCart(JsonObj);
    //        }
    //    },
    //    failure: function (result) {
    //        console.log(JSON.parse(result.responseText).d);
    //    },
    //    error: function (result) {
    //        console.log(JSON.parse(result.responseText).d);
    //    }
    //});


    //$("#tblProductDetail .row").each(function () {

    //    var SKUNameString = '';
    //    SKUNameString = $(this).find('.SKUName').text();
    //    if (SKUNameString.includes('Gift Card')) {
    //        TempGiftCartList = [];
    //        $(this).closest('.product-addlist').remove();
    //        if ($("#tblProductDetailBody").length == 0) {
    //            $("#emptyTable").show();
    //        }
    //    }
    //});
    //calc_total();
    //}
    FocusOnBarCode();
}

function AddWalkInCustomer() {
    var CustomerId = 1;
    var DOB = '';
    var CustomerName = 'Walk In';
    var RoyaltyPoints = 0;
    $("#hdnCustomerId").val(CustomerId);
    $("#hdnCustomerDOB").val(DOB);
    $("#ddlCustomer").val(CustomerName.trim());
    $("#hdnRoyaltyPoints").val(isNaN(parseInt(RoyaltyPoints)) ? 0 : parseInt(RoyaltyPoints));
    $("#txtAvlHappyPoints").val(isNaN(parseInt(RoyaltyPoints)) ? 0 : parseInt(RoyaltyPoints));
    $('#SearchCustomerModal').modal('hide');
    FocusOnBarCode();
}

function OpenSearchCustomerModal() {
    $('#AddCustomerModal').modal('hide');
    $('#SearchCustomerModal').modal('show');
}

function CloseModalCash() {

    //Reset Exact button
    PayButton = '';

    //Reset Exact Cash Payments
    GivenCash = 0;

    //Reset Exact Credit Card Payments
    $("#tblTransaction").find('.CreditCard').remove();
    PayMentMethod = '';
    CardType = 0;
    CreditCardLastfourDigit = '';
    TrasactionID = '';
    $('#CardTypeModal').modal('hide');

    //Reset Exact Happy point Transactions
    RoyaltyAmount = 0;
    UsedRoyaltyPoints = 0;
    $('.HappPointsPayment').closest('tr').remove();

    //Reset Exact Coupon Transactions
    $('.Gift').hide();
    CouponAmt = 0;
    CouponNo = '';
    MinCouponOrderAmt = 0;
    $("#tblTransaction").find('.CouponTr').remove();
    //DeleteCouponRow();
    //ResetGiftCard();

    //Reset Exact Gift Card Transactions
    DeleteGiftCardLog();
    $('#ModalCash').modal('hide');
    FocusOnBarCode();
    calc_total();
}

function OpenCashModal() {
    var maxAge = 0, minAge = 0, i = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if (i == 0) {
            maxAge = $(item).find('.hdnAge').val();
        }
        else {
            if (maxAge < $(item).find('.hdnAge').val()) {
                maxAge = $(item).find('.hdnAge').val();
            }
        }
        i++;
    });
    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            FocusOnBarCode();
        });
        return;
    }

    var CustomerAge = 0;
    var DOB = $('#hdnCustomerDOB').val();
    var jsDate = new Date(DOB);
    if (DOB != 1) {
        var today = new Date();
        CustomerAge = Math.floor((today - jsDate) / (365.25 * 24 * 60 * 60 * 1000));
    }
    if (CustomerAge >= maxAge && DOB != 1) {
        $('#DivCustomCash').hide();
        $('#PaidAmt').attr('readonly', 'readonly');
        $('#PaidAmt').val('0.00');
        $('#LeftAmt').val('0.00');
        document.getElementById("LeftAmt").style.color = "black";
        calc_total();
        $('#ModalCash').modal('show');
        //Cal_Cash('0');
    }
    else if ((DOB == 1 || DOB == "") && maxAge != 0) {
        var today = new Date();
        dt = subtractFromDate(new Date(), { years: maxAge });
        var day = ("0" + dt.getDate()).slice(-2);
        var month = ("0" + (dt.getMonth() + 1)).slice(-2);
        var today2 = (month) + "/" + (day) + "/" + dt.getFullYear();
        swal({
            title: "Warning!",
            text: "Please verify the customer is a minimum of  " + maxAge + " years old. Born before " + today2 + "?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "Not Verified",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Verified",
                    value: true,
                    visible: true,
                    className: "btn-success",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                $('#DivCustomCash').hide();
                $('#PaidAmt').attr('readonly', 'readonly');
                $('#PaidAmt').val('0.00');
                $('#LeftAmt').val('0.00');
                document.getElementById("LeftAmt").style.color = "black";
                calc_total();
                $('#ModalCash').modal('show');
            }
            //else {
            //    EmptyProductList();
            //    FocusOnBarCode();
            //    AddWalkInCustomer();
            //}
        });
    }
    else if (maxAge != 0) {
        var today = new Date();
        dt = subtractFromDate(new Date(), { years: maxAge });
        var day = ("0" + dt.getDate()).slice(-2);
        var month = ("0" + (dt.getMonth() + 1)).slice(-2);
        var today1 = (month) + "/" + (day) + "/" + dt.getFullYear();
        swal({
            title: "Warning!",
            text: "Please verify the customer is a minimum of  " + maxAge + " years old. Born before " + today1 + "?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "Not Verified",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Verified",
                    value: true,
                    visible: true,
                    className: "btn-success",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                $('#DivCustomCash').hide();
                $('#PaidAmt').attr('readonly', 'readonly');
                $('#PaidAmt').val('0.00');
                $('#LeftAmt').val('0.00');
                document.getElementById("LeftAmt").style.color = "black";
                calc_total();
                $('#ModalCash').modal('show');
            }
            //else {
            //    EmptyProductList();
            //    FocusOnBarCode();
            //    AddWalkInCustomer();
            //}
        });
    }
    else {
        $('#DivCustomCash').hide();
        $('#PaidAmt').attr('readonly', 'readonly');
        $('#PaidAmt').val('0.00');
        $('#LeftAmt').val('0.00');
        document.getElementById("LeftAmt").style.color = "black";
        calc_total();
        $('#ModalCash').modal('show');
    }
}

function OpenCashModal2() {

    //if (parseFloat($('#lblgrandtotal').text()) < 0) {
    //    $('.LotteryB').attr('disabled', 'disabled');
    //}
    //else {
    //    $('.LotteryB').removeAttr('disabled', 'disabled');
    //}
    var maxAge = 0, minAge = 0, i = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if (i == 0) {
            maxAge = $(item).find('.hdnAge').val();
        }
        else {
            if (maxAge < $(item).find('.hdnAge').val()) {
                maxAge = $(item).find('.hdnAge').val();
            }
        }
        i++;
    });
    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            FocusOnBarCode();
        });
        return;
    }
    $('#DivCustomCash').hide();
    $('#PaidAmt').attr('readonly', 'readonly');
    $('#PaidAmt').val('0.00');
    $('#LeftAmt').val('0.00');
    document.getElementById("LeftAmt").style.color = "black";
    calc_total();
    $('#ModalCash').modal('show');
}

const subtractFromDate = (
    date,
    { years, days, hours, minutes, seconds, milliseconds } = {}
) => {
    const millisecondsOffset = milliseconds ?? 0
    const secondsOffset = seconds ? 1000 * seconds : 0
    const minutesOffset = minutes ? 1000 * 60 * minutes : 0
    const hoursOffset = hours ? 1000 * 60 * 60 * hours : 0
    const daysOffset = days ? 1000 * 60 * 60 * 24 * days : 0
    const dateOffset =
        millisecondsOffset +
        secondsOffset +
        minutesOffset +
        hoursOffset +
        daysOffset

    let newDate = date
    if (years) newDate = date.setFullYear(date.getFullYear() - years)
    newDate = new Date(newDate - dateOffset)

    return newDate
}
/*var GivenCash = 0, LeftAmt = 0; 0;*/


function DeleteCashRow(e) {

    PayButton = '';
    Cal_Cash(0);
    $(e).closest('tr').remove();
    if ($("#tblTransaction tr").length == 0) {
        //$("#tblTransaction").hide();
    }
}
function OpenCustomCash() {
    $('#PaidAmt').removeAttr('readonly');
    $('#PaidAmt').val('0.00');
    //$('#DivCustomCash').show();
}

function CustomCash() {

    var CustomCash = 0;
    $('#PaidAmt').attr('readonly', 'readonly');
    CustomCash = isNaN(parseFloat($('#PaidAmt').val())) ? 0 : parseFloat($('#PaidAmt').val());
    Cal_Cash(CustomCash);
}
function DeleteCreditCardPayment(e) {
    PayMentMethod = '';
    $(e).closest('tr').remove();
    calc_total();
}

function POSReset() {
    localStorage.clear();
    $('#hdnOrderId').val('');
    $('#hdnOrderNo').val('');
    $('#txtSearchProduct').val('');
    EmptyProductList();
    FocusOnBarCode();
    AddWalkInCustomer();
    window.location.reload();
}

function RedirectToInvoiceList() {
    window.location.href = "/Pages/SaleinvoiceList.aspx";
}

//var CurrentDrawerCash = 0;
function CurrentCash() {
    var CurrentBal = 0;
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/BindCurrentCash",
        data: "{ }",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Current Cash Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {

                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CurrentBalance = $(xml).find("Table");

                if (CurrentBalance.length > 0) {
                    $.each(CurrentBalance, function () {
                        CurrentBal = parseFloat($(this).find("CurrentCashAmt").text());
                    });
                    return CurrentBal;
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
    return CurrentBal;
}

function Logout() {
    $('#txtBalance').val('0.00')
    swal({
        text: "Do you want to End Shift or Break.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            confirm: {
                text: "End Shift",
                value: true,
                visible: true,
                className: "btn-success",
                closeModal: true,
            },
            cancel: {
                text: "Break",
                value: null,
                visible: true,
                className: "btn-danger",
                closeModal: true,
            },
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            $("#ModalAction").modal("hide");
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/BindCurrencyList",
                data: "{}",
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

                        var Validate = 1;
                        var xmldoc = $.parseXML(response.d);
                        var xml = $(xmldoc);
                        var CurrencyList = $(xml).find("Table");
                        var OpenBalList = $(xml).find("Table1");
                        var CurrentBalance = $(xml).find("Table6");

                        if (OpenBalList.length > 0) {
                            $.each(OpenBalList, function () {
                                $('.OpenBalance').show();
                                /*$('.ClosingDate').hide();*/
                                $('#lbl_OpenBal').text('Previous Opening Balance:');
                                $('#txtOpenBalance').val($(this).find("OpeningBalance").text());
                            });
                        }
                        else {
                            Validate = 0;
                            swal('Error!', 'Shift not found. Login once again.', '', { closeOnClickOutside: false }).then(function () {
                                window.location.href = '/Default.aspx';
                            });
                        }
                        if (Validate == 1) {
                            if (CurrencyList.length > 0) {
                                $("#tableCurrency tbody tr").remove();
                                var row = $("#tableCurrency thead tr:first-child").clone(true);
                                $.each(CurrencyList, function () {

                                    $(".CCode", row).html($(this).find("AutoId").text());
                                    $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                                    $(".QTY", row).html('<div class="form-row" style="text-align:center;margin-left: -5px;"><button type="button" id="M" style="width: 110px; background-color:#d887347a;" class="minus-no btn btnMinus" onclick="MinusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" ><i class="fa fa-minus" aria-hidden="true"></i></button><input type="text" autocomplete="off" ondragover="return false" onPaste="return false" onCopy="return false" id="Q' + $(this).find("AutoId").text() + '" maxlength="3" onchange="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeyup="CalCurrency2(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" onkeypress="return /[0-9]/i.test(event.key)" style="text-align: center; height: 37px;font-size:21px" class="form-control text-center" placeholder="0" /><button type="button" id="P" onclick="PlusFun(this);CalCurrency(' + $(this).find("AutoId").text() + ',' + $(this).find("Amount").text() + ',this);" style="width: 110px;background-color:#d887347a;" class="minus-no btn btnplus" ><i class="fa fa-plus" aria-hidden="true"></i></button></div>');
                                    $(".TotalA", row).html('<span id="T' + $(this).find("AutoId").text() + '">0.00</span>').css('text-align', 'right').css('background-color', '#eee');
                                    $("#tableCurrency").append(row);
                                    row = $("#tableCurrency tbody tr:last-child").clone(true);
                                });
                                $("#tableCurrency").show();
                            }
                            var ClosingBal = 0, TempAmt = 0;
                            if (CurrentBalance.length > 0) {
                                ClosingBal = isNaN(parseFloat($('#txtBalance').val())) ? 0 : parseFloat($('#txtBalance').val());
                                //CurrentDrawerCash = isNaN(parseFloat($(this).find("CurrentCashAmt").text())) ? 0 : parseFloat($(this).find("CurrentCashAmt").text());
                                $.each(CurrentBalance, function () {
                                    TempAmt = parseFloat($(this).find("CurrentCashAmt").text());
                                    if (parseFloat($(this).find("CurrentCashAmt").text()) < 0) {
                                        $('#CurrentBaltxt').val(parseFloat(TempAmt * (-1)).toFixed(2));
                                        $('#CurrentBalStatus').val('over');
                                        $('#CurrentBalanceText').text('' + (CSymbol + parseFloat(TempAmt * (-1)).toFixed(2)).replace(CSymbol + '-', CSymbol) + ' is over.').css('color', 'green');
                                    }
                                    else if (parseFloat($(this).find("CurrentCashAmt").text()) == ClosingBal) {
                                        $('#CurrentBaltxt').val('0.00');
                                        $('#CurrentBalStatus').val('exact');
                                        $('#CurrentBalanceText').text('Exact.').css('color', 'black');
                                    }
                                    else {
                                        $('#CurrentBaltxt').val(parseFloat($(this).find("CurrentCashAmt").text()).toFixed(2));
                                        $('#CurrentBalStatus').val('short');
                                        //$('#CurrentBalanceText').text('$' + parseFloat($(this).find("CurrentCashAmt").text()).toFixed(2) + ' is short.').css('color', 'crimson');
                                        $('#CurrentBalanceText').text('' + (CSymbol + parseFloat($(this).find("CurrentCashAmt").text()).toFixed(2)).replace(CSymbol + '-', CSymbol) + ' is short.').css('color', 'crimson');
                                    }
                                    $('.CurrentBal').show();
                                    $('#txtCurrentBal').val($(this).find("CurrentCashAmt").text());
                                });
                            }
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
            $('#txtBalance').attr('disabled', true);
            $("#BalanceStatusHeader").html('Shift Closing:');
            $("#balanceStatusText").text('Closing Balance:');
            $("#btnOpeningBack").hide();
            $("#btnOpeningProceed").hide();
            $("#btnClosingBack").show();
            $("#btnCloseBalanceProceed").show();
            $("#ModalOpenBalance").modal('show');
            $("#txtBalance").val('0.00');
            //window.location.href = "/Default.aspx";
        }
        else {
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/BreakLog",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == 'Success') {
                        window.location.href = "/Default.aspx";
                        $("#ModalOpenBalance").modal('hide');
                    } else if (response.d == "Session") {
                        swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx";
                        });
                    }
                    else if (response.d == "failed") {
                        swal("", "Access Denied!", "error", { closeOnClickOutside: false });
                    }
                    else {
                        swal("", "Some error occured!", "error", { closeOnClickOutside: false });
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
    })
}
function MinusFun(e) {

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

    var TotalAmt = 0;
    $('#tableCurrency tbody tr').each(function () {
        var Total = $(this).find(".TotalA").text();
        TotalAmt += parseFloat(Total);
    });
    var AmtCheck = 0;
    $('#txtBalance').val(TotalAmt.toFixed(2));
    if ((parseFloat(parseFloat(TotalAmt).toFixed(2)) < parseFloat($('#txtCurrentBal').val()))) {

        AmtCheck = parseFloat($('#txtCurrentBal').val()) - TotalAmt;
        $('#CurrentBaltxt').val(AmtCheck);
        $('#CurrentBalStatus').val('short');
        $('#CurrentBalanceText').text(CSymbol + AmtCheck.toFixed(2) + ' is short.').css('color', 'crimson');
    }
    else if (parseFloat(parseFloat(TotalAmt).toFixed(2)) == parseFloat($('#txtCurrentBal').val())) {

        $('#CurrentBaltxt').val('0.00');
        $('#CurrentBalStatus').val('exact');
        $('#CurrentBalanceText').text('Exact.').css('color', 'black');
    }
    else {

        AmtCheck = parseFloat($('#txtCurrentBal').val()) - TotalAmt;
        $('#CurrentBaltxt').val(AmtCheck);
        $('#CurrentBalStatus').val('over');
        $('#CurrentBalanceText').text('' + (CSymbol + parseFloat(AmtCheck).toFixed(2)).replace(CSymbol + '-', CSymbol) + ' is over.').css('color', 'green');
    }
}


function AdminModal() {
    $('#ModalAction').modal('hide');
    $('#ModalAdmin').modal('show');
}

function CloseAdminModal() {
    $('#ModalAdmin').modal('hide');
    FocusOnBarCode();
}

function ViewPassword() {

    if ($('#txtpassword').prop('type') == 'password') {
        $('#txtpassword').prop("type", "text");
    }
    else {
        $('#txtpassword').prop("type", "password");
    }
}

function LoginAsAdmin() {
    var validate = 1;
    if ($('#txtpassword').val().trim() == '') {
        toastr.error('Please enter security pin.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/LoginAsAdmin",
            data: "{'password':'" + $('#txtpassword').val().trim() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "Some error occured!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpassword').val('');
                    });
                } else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == "failed") {
                    swal("", "Access Denied!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpassword').val('');
                    });
                }
                else {

                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var LoginDeatil = xml.find("Table");
                    if (LoginDeatil.length > 0) {
                        window.location.href = "/Pages/DashBoard.aspx"
                    }
                    else {
                        window.location.href = "/Default.aspx"
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
}

function ViewInvoiceList() {
    $('#txtInvoDate').datepicker({
        changeMonth: true,
        changeYear: true,
        todayBtn: "linked",
        dateFormat: 'mm/dd/yy',
        showOn: 'focus',
        showButtonPanel: true,
        closeText: 'Clear', // Text to show for "close" button
        onClose: function () {
            var event = arguments.callee.caller.caller.arguments[0];
            // If "Clear" gets clicked, then really clear it
            if ($(event.delegateTarget).hasClass('ui-datepicker-close')) {
                $(this).val('');
            }
        },
    });
    $("#ModalAction").modal("hide");
    $('#txtInvoiceNumber').val("");
    $('#txtCustName').val("");
    BindSaleInvoiceList(1);
    $('#ModalInvoiceList').modal('show');
}

function CloseModalInvoiceList() {
    $('#ModalInvoiceList').modal('hide');
    FocusOnBarCode();
}

function Pagevalue(e) {

    if ($(e).parent().attr("id") == "AddToHomePager") {
        AddToHomeProduct(parseInt($(e).attr("page")));
    }
    if ($(e).parent().attr("id") == "SaleInvoiceListPager") {
        BindSaleInvoiceList(parseInt($(e).attr("page")));
    }
    if ($(e).parent().attr("id") == "SearchCustomerPager") {
        SearchCustomer(parseInt($(e).attr("page")));
    }
    if ($(e).parent().attr("id") == "BindSafeCashListPager") {
        BindSafeCashList(parseInt($(e).attr("page")), 0);
    }
    if ($(e).parent().attr("id") == "SalePayoutListPager") {        
        BindPayoutList(parseInt($(e).attr("page")), 0);
    }
    if ($(e).parent().attr("id") == "SearchScreenPager") {
        BindScreenList(parseInt($(e).attr("page")), 0);
    }
}

function BindSaleInvoiceList(pageIndex) {
    $('#loading').show();
    if ($("#txtInvoFromDate").val().trim() != '' && $("#txtInvoToDate").val().trim() && (Date.parse($("#txtInvoFromDate").val()) > Date.parse($("#txtInvoToDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtInvoFromDate").val().trim() == '' || $("#txtInvoToDate").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Both From Date and To Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#loading').show();
    data = {
        InvoiceNo: $('#txtInvoiceNumber').val().trim(),
        CustomerName: $('#txtCustName').val().trim(),
        InvoiceFromDate: $('#txtInvoFromDate').val().trim(),
        InvoiceToDate: $('#txtInvoToDate').val().trim(),
        CreatedFrom: $('#ddlCreatedFrom').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SaleInvoiceList.aspx/BindSaleInvoiceList2",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Invoice Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {

                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var pager = $(xml).find("Table");
                var InvoiceList = $(xml).find("Table1");
                var status = "";
                if (InvoiceList.length > 0) {
                    if (pager.length > 0) {
                        $("#spInvoiceSortBy").text($(pager).find('SortByString').text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spInvoiceSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#InvoiceEmptyTable").hide();
                    $("#tblInvoiceList tbody tr").remove();
                    var row = $("#tblInvoiceList thead tr:first-child").clone(true);
                    $.each(InvoiceList, function () {

                        status = '';
                        $(".InvoiceAutoId", row).html($(this).find("AutoId").text());
                        $(".InvoiceNumber", row).html($(this).find("InvoiceNo").text());
                        $(".PaymentMethod", row).html($(this).find("PaymentMethod").text());
                        $(".CustomerName", row).html($(this).find("CustomerName").text());
                        $(".Tax", row).html($(this).find("Tax").text()).css('text-align', 'right');
                        $(".Discount", row).html($(this).find("Discount").text()).css('text-align', 'right');
                        $(".Coupon", row).html($(this).find("Coupon").text());
                        $(".CouponAmt", row).html($(this).find("CouponAmt").text()).css('text-align', 'right');
                        $(".Total", row).html($(this).find("Total").text()).css('text-align', 'right');
                        $(".InvoiceDate", row).html($(this).find("InvoiceDate").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        $(".Status", row).html(status);
                        if ($(this).find("CreatedFrom").text() == 'Web') {
                            $(".CreatedFrom", row).html("<span class='badge badge badge-pill' style='background-color:#088395'>" + $(this).find("CreatedFrom").text() + "</span>");

                        }
                        else {
                            $(".CreatedFrom", row).html("<span class='badge badge badge-pill' style='background-color:#26577C'>" + $(this).find("CreatedFrom").text() + "</span>");

                        }
                        //$(".SaleInvoiceItems", row).html("<a title='View Invoice Items' style='cursor:pointer;' onclick='BindSaleInvoiceItemList(" + $(this).find("AutoId").text() + ")'>View Items</a>");
                        $(".UpdationDetails", row).html($(this).find("UpdationDetails").text());
                        $(".Action", row).html("<a onclick='PrintInvoice1(" + $(this).find("AutoId").text() + ")'><i class='fa fa-print' title='Print Invoice' style='color:black'></i></a>&nbsp;&nbsp;&nbsp;<a style='height:20px;width:20px' onclick='BindSaleInvoiceItemList(" + $(this).find("AutoId").text() + ",this)'><img src='/Style/img/View.png' height='20' width='20' title='View Invoice Details' class='' /></a>");

                        $("#tblInvoiceList").append(row);
                        row = $("#tblInvoiceList tbody tr:last-child").clone(true);
                    });
                    $('#loading').hide();
                    $("#tblInvoiceList").show();
                }
                else {
                    $("#InvoiceEmptyTable").show();
                    $("#tblInvoiceList").hide();
                    $("#spInvoiceSortBy").hide();
                    $("#ddlPageSize").hide();
                    $('#loading').hide();
                }
                $(".SaleInvoiceListPager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt($(pager).find("PageIndex").text()),
                    PageSize: parseInt($(pager).find("PageSize").text()),
                    RecordCount: parseInt($(pager).find("RecordCount").text())
                });
                if ($('#ddlPageSize').val() == '0') {
                    $('#SaleInvoiceListPager').hide();
                }
                else {
                    $('#SaleInvoiceListPager').show();
                }
            }
            $('#loading').hide();
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function PrintInvoice1(AutoId) {

    window.open("/Pages/PrintSaleInvoice.html?dt=" + AutoId, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
}

function NoSalePopUp() {
    $("#ModalAction").modal("hide");
    $('#SearchNoSaleModal').modal('show');
    $('#txtNoSaleRemarkName').val('');
}

function NoSale(evt) {
    if ($('#txtNoSaleRemarkName').val().trim() == '') {
        $(evt).removeAttr('disabled');
        toastr.error('Remark required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    data = {
        NoSaleRemark: $('#txtNoSaleRemarkName').val().trim()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/NoSale",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", 'No Sale Remark saved successfully.', "success", { timer: 1500, button: false }).then(function () {
                    $('#txtNoSaleRemarkName').val('');
                    $('#SearchNoSaleModal').modal('hide');
                    $(evt).removeAttr('disabled');
                });
            } else {
                swal("Error", response.d, "error", { timer: 1500, button: false });
            }
            $(evt).removeAttr('disabled');
        },
        failure: function (result) {
            $(evt).removeAttr('disabled');
            console.log(result.d);
        },
        error: function (result) {
            $(evt).removeAttr('disabled');
            console.log(result.d);
        }
    });
}

function BindSaleInvoiceItemList(InvoiceAutoId, evt) {

    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/Pages/SaleInvoiceList.aspx/BindSaleInvoiceItemList",
        data: "{'InvoiceAutoId':'" + InvoiceAutoId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger
            if (response.d == 'false') {
                swal("", "No Invoice Item Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {


                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var InvoiceList = $(xml).find("Table");
                var InvoiceDeatils = $(xml).find("Table1");
                var TransactionDeatils = $(xml).find("Table2");
                var status = "";
                if (InvoiceList.length > 0) {
                    $("#InvoiceItemEmptyTable").hide();
                    $('#spnIvvoiceNo').text('Invoice No : ' + $(evt).parent().parent().find('.InvoiceNumber').text());
                    $("#tblInvoiceItemList tbody tr").remove();
                    var row = $("#tblInvoiceItemList thead tr:first-child").clone(true);
                    $.each(InvoiceList, function () {

                        status = '';
                        var SKUN = "", Scheme = "";
                        if ($(this).find("IsGift").text() == '1') {
                            SKUN = $(this).find("SKUName").text();
                            var queryString = SKUN.replaceAll("Gift Card - ", "");
                            SKUN = "Gift Card - " + hideWord(queryString);
                        }
                        else {
                            SKUN = $(this).find("SKUName").text();
                        }
                        if ($(this).find("SchemeName").text() != "") {
                            Scheme = $(this).find("SchemeName").text() + '<br/>';
                        }
                        $(".InvoiceItemAutoId", row).html($(this).find("AutoId").text());
                        // $(".SKUName", row).html(Scheme + SKUN);
                        $(".SKUName", row).html(SKUN + '</br>' + $(this).find("SKUProductList").text());
                        $(".SchemeName", row).html($(this).find("SchemeName").text());
                        $(".SchemeAutoId", row).html($(this).find("SchemeId").text());
                        $(".Quantity", row).html($(this).find("Quantity").text());
                        $(".UnitPrice", row).html($(this).find("Price").text()).css('text-align', 'right');
                        /*$(".Tax", row).html($(this).find("Tax").text()).css('text-align', 'right');*/
                        $(".Total", row).html($(this).find("Total").text()).css('text-align', 'right');
                        $("#tblInvoiceItemList").append(row);
                        row = $("#tblInvoiceItemList tbody tr:last-child").clone(true);
                    });
                    $("#tblInvoiceItemList").show();
                    $('#loading').hide();
                }
                else {
                    $("#InvoiceItemEmptyTable").show();
                    $("#tblInvoiceItemList").hide();
                    $('#loading').hide();
                }
                $('#tdSubtotal').text((CSymbol + parseFloat($(InvoiceDeatils).find('SubTotal').text()).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                $('#tdTax').text(CSymbol + parseFloat($(InvoiceDeatils).find('Tax').text()).toFixed(2));
                if ($(InvoiceDeatils).find('Discount').text() > 0) {
                    $('#tdDiscount').text(CSymbol + parseFloat($(InvoiceDeatils).find('Discount').text()).toFixed(2));
                }
                else {
                    $('#tdDiscount').text(CSymbol + parseFloat($(InvoiceDeatils).find('Discount').text()).toFixed(2));
                }
                if (parseFloat((InvoiceDeatils).find('LeftAmt').text()) > 0) {
                    $('.ReturnAmt').show();
                    $('#tdreturnAmt').text('-' + CSymbol + parseFloat($(InvoiceDeatils).find('LeftAmt').text()).toFixed(2));
                }
                else {
                    $('.ReturnAmt').hide();
                }
                if (parseFloat($(InvoiceDeatils).find('LotteryTotal').text()) || 0 != 0) {
                    $('.Lottery').show();
                    if (parseFloat($(InvoiceDeatils).find('LotteryTotal').text()) >= 0) {
                        $('#tdLotteryTotal').text((CSymbol + parseFloat($(InvoiceDeatils).find('LotteryTotal').text()).toFixed(2)));
                    }
                    else {
                        $('#tdLotteryTotal').text(('-' + CSymbol + parseFloat(parseFloat($(InvoiceDeatils).find('LotteryTotal').text()) * (-1)).toFixed(2)));
                    }
                    //$('#tdLotteryTotal').show();
                }
                else {
                    $('.Lottery').hide();
                    $('#tdLotteryTotal').text(CSymbol + '0.00');
                }
                //$('#tdCouponAmount').text('-$' + parseFloat($(InvoiceDeatils).find('CouponAmt').text()).toFixed(2)); 
                var GT = parseFloat($(InvoiceDeatils).find('Total').text());
                //$('#tdGrandTotal').text(('$' + GT).replace('$-', '-$'));
                $('#tdGrandTotal').text((CSymbol + parseFloat(GT).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));

                $('#spnItemCount').text($(InvoiceDeatils).find('ItemCount').text());
                $('#spnInvoceDate').text($(InvoiceDeatils).find('InvoiceDate').text());
                $('#spnCustName').text($(InvoiceDeatils).find('CustomerName').text());
                if ($(InvoiceDeatils).find('CustomerName').text().trim() != 'Walk In') {
                    $('.Happy').show();
                    $('#spnPMode').text($(InvoiceDeatils).find('HappyPoints').text());
                    $('#spnHappy').text($(InvoiceDeatils).find('AssignedRoyaltyPoints').text());
                }
                else {
                    $('.Happy').hide();
                }
                $('#ModalAction').modal('hide');
                $('#ModalInvoiceList').modal('hide');
                $('#InvoiceProductListModal').modal('show');
                var Trhtml = '', trCount = 0;
                $("#DivTransactionDetails").text('');
                if (TransactionDeatils.length > 0) {
                    $.each(TransactionDeatils, function () {
                        var Mode = $(this).find("PaymentMode").text();
                        if (Mode == "Happy points") {
                            Mode = "Reward Points";
                        }
                        var Amt = (CSymbol + parseFloat($(this).find("Amount").text()).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol);
                        Trhtml += '<div class="row">';
                        Trhtml += ' <div class="col-md-6">';
                        Trhtml += '<label style="white-space:nowrap">' + Mode + '</label>';
                        Trhtml += '</div>';
                        //Trhtml += '<div class="col-md-1">';
                        //Trhtml += '<label>:</label>';
                        //Trhtml += '</div>';
                        Trhtml += '<div class="col-md-5" style="text-align: right;white-space:nowrap;">';
                        Trhtml += '<span id="tdGrandTotal">' + Amt + '</span>';
                        Trhtml += '</div>';
                        Trhtml += '</div>';
                        trCount++;
                    });
                    $("#DivTransactionDetails").append(Trhtml);
                }
            }
            $('#loading').hide();
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function CloseModalInvoiceItemList() {
    $('#InvoiceProductListModal').modal('hide');
    $('#ModalInvoiceList').modal('show');
    //$("#ModalAction").modal("hide");
    ViewInvoiceList();
}

function CloseCustomerSearchModal() {
    FocusOnBarCode();
    $('#GiftModal').modal('hide');
    $('#CardTypeModal').modal('hide');
}

function CloseAddCustModal() {
    FocusOnBarCode();
    $("#txtFirstName").val('').removeAttr('disabled');
    $("#txtMobileNo").val('').removeAttr('disabled');
    $('#AddCustomerModal').modal('hide');
}

function GetUserTypeId() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/GetUserTypeId",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "Something went wrong.Please try again!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                if (response.d == '4') {
                    $("#DivClose").hide();
                    $("#DivAdmin").show();
                    $("#DivLogout").show();
                }
                else {
                    $("#DivAdmin").hide();
                    $("#DivLogout").hide();
                    $("#DivClose").show();
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

function GoToDashBoard() {
    window.location.href = 'DashBoard.aspx';
}


function CountProductAndQuantity() {
    var ProductCnt = 0, QuantityCnt = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        QuantityCnt += parseInt($(item).find('.quantity').val());
        ProductCnt++;
    });
    $("#totalProductCnt").text(ProductCnt);
    //$("#totalQuantityCnt").text(QuantityCnt);
}

function PayoutModal() {
    $("#ModalAction").modal("hide");
    $("#PayoutModal").modal("show");
    bindPayoutType();
    PayoutReset();
    $(".Expense").hide();
    $(".Vendor").hide();
}

function process(input) {
    let value = input.value;
    let numbers = value.replace(/[^0-9]/g, "");
    input.value = numbers;
}

function BindDDLExpenseVendor() {
    if ($("#ddlPayoutType").val() == 1) {
        bindVendor();
        $(".Expense").hide();
        $(".Vendor").show();
    }
    else if ($("#ddlPayoutType").val() == 2) {
        bindExpenses();
        $(".Vendor").hide();
        $(".Expense").show();
    }
    else {
        $(".Vendor").hide();
        $(".Expense").hide();
    }
}
function BindDDLExpenseVendor1() {
    $("#ddlExpense1").val('0').change();
    $("#ddlVendor1").val('0').change();
    if ($("#ddlPayoutType1").val() == 1) {
        bindVendor();
        $(".Expense1").hide();
        $(".Vendor1").show();
    }
    else if ($("#ddlPayoutType1").val() == 2) {
        bindExpenses();
        $(".Vendor1").hide();
        $(".Expense1").show();
    }
    else {
        $(".Vendor1").hide();
        $(".Expense1").hide();
    }
}

function bindVendor() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindVendor",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Vendor Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlVendor option").remove();
                $("#ddlVendor1 option").remove();
                $("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $("#ddlVendor1").append('<option value="0">Select Vendor</option>');
                $.each(StateList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text()));
                    $("#ddlVendor1").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text()));
                });
                $("#ddlVendor").select2().next().css('width', '260px');
                $("#ddlVendor1").select2().next().css('width', '200px');
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

function bindExpenses() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindExpenses",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Expenses Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlExpense option").remove();
                $("#ddlExpense1 option").remove();
                $("#ddlExpense").append('<option value="0">Select Expense</option>');
                $("#ddlExpense1").append('<option value="0">Select Expense</option>');
                $.each(StateList, function () {
                    $("#ddlExpense").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("ExpenseName").text()));
                    $("#ddlExpense1").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("ExpenseName").text()));
                });
                $("#ddlExpense").select2().next().css('width', '260px');
                $("#ddlExpense1").select2().next().css('width', '200px');
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
function bindPayoutType() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/bindPayoutType",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No PayoutType Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlPayoutType option").remove();
                $("#ddlPayoutType1 option").remove();
                $("#ddlPayoutType").append('<option value="0">Select Payout Type</option>');
                $("#ddlPayoutType1").append('<option value="0">Select Payout Type</option>');
                $.each(StateList, function () {
                    $("#ddlPayoutType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("PayoutType").text()));
                    $("#ddlPayoutType1").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("PayoutType").text()));
                });
                $("#ddlPayoutType").select2().next().css('width', '260px');
                $("#ddlPayoutType1").select2().next().css('width', '200px');
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

function ViewPayoutList() {
    $('#txtSAmount').val('');
    $('#txtSPayTo').val('');
    $('#ddlPayoutType1').val('0').change();
    BindPayoutList(1);
    bindPayoutType();
    $('#ModalAction').modal('hide');
    $('#ModalPayoutList').modal('show');
}
function CloseModalPayoutList() {
    $('#ModalPayoutList').modal('hide');
    FocusOnBarCode();
}

function BindPayoutList(pageIndex) {

    if ($("#txtSFromDate").val().trim() != '' && $("#txtSToDate").val().trim() && (Date.parse($("#txtSFromDate").val()) > Date.parse($("#txtSToDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtSAmount").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Please fill valid Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    $('#loading').show();

    data = {
        PayoutType: $("#ddlPayoutType1").val(),
        Expense: $("#ddlExpense1").val(),
        Vendor: $("#ddlVendor1").val(),
        CompanyId: $("#ddlSCompanyName").val().trim(),
        PayTo: $("#txtSPayTo").val().trim(),
        Amount: $("#txtSAmount").val(),
        FromDate: $("#txtSFromDate").val().trim(),
        ToDate: $("#txtSToDate").val().trim(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSizeP").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/BindPayoutList1",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var PayoutList = xml.find("Table1");
                var pager = xml.find("Table");
                var Total = xml.find("Table2");

                if (Total.length > 0) {

                    $("#lblTotal").text(parseFloat($(Total).find("TotalAmount").text()).toFixed(2));

                }
                var status = "";
                if (PayoutList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSizeP').show();
                    }
                    else {
                        $('#ddlPageSizeP').hide();
                    }
                    $("#spSortBy").show();
                    //$("#ddlPageSizeP").show();
                    $("#PayoutEmptyTable").hide();
                    $("#tblPayoutList tbody tr").remove();
                    var row = $("#tblPayoutList thead tr:first-child").clone(true);
                    $.each(PayoutList, function () {

                        status = '';
                        $(".PayoutAutoId", row).html($(this).find("AutoId").text());
                        $(".CompanyName", row).html($(this).find("CompanyName").text());
                        $(".PayTo", row).html($(this).find("PayTo").text());
                        $(".Amount", row).html(parseFloat($(this).find("Amount").text()).toFixed(2));
                        $(".PayoutType", row).html($(this).find("PayoutType").text());
                        $(".Expenses", row).html($(this).find("ExpenseName").text());
                        $(".Vendors", row).html($(this).find("VendorName").text());
                        $(".Remark", row).html($(this).find("Remark").text());
                        $(".PaymentMode", row).html($(this).find("PayoutMode").text());
                        $(".createdby", row).html($(this).find("CreatedBy").text());
                        $(".Createddate", row).html($(this).find("PayoutDate").text() + '<br/>' + $(this).find("PayoutTime").text());
                        //$(".PayTime", row).html($(this).find("PayoutTime").text());
                        if ($(this).find("EmpId").text() == $("#hdnEmpAutoId").val()) {
                            $(".Action", row).html("<a style='' Onclick='editPayout(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeletePayout' onclick='isDeletePayout(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        }
                        else {
                            $(".Action", row).html("<center><b>-&nbsp;&nbsp;-</b></center>");
                        }
                        $("#tblPayoutList").append(row);
                        row = $("#tblPayoutList tbody tr:last-child").clone(true);
                    });
                    $("#tblPayoutList").show();
                }

                else {
                    $("#PayoutEmptyTable").show();
                    $("#tblPayoutList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSizeP").hide();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSizeP').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
            }
            $('#loading').hide();
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

function editPayout(id) {

    data = {
        PayoutAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/editPayout",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var PayoutDetail = xml.find("Table");
                $('#ModalPayoutList').modal('hide');
                //$("#ModalAction").modal("show");
                $("#PayoutModal").modal("show");
                $("#hdnPayoutId").val($(PayoutDetail).find('AutoId').text());
                $("#txtPayTo").val($(PayoutDetail).find('PayTo').text());
                $("#txtAmount").val(parseFloat($(PayoutDetail).find('Amount').text()).toFixed(2));
                $("#hdnPayoutAmt").val(parseFloat($(PayoutDetail).find('Amount').text()).toFixed(2));
                $("#ddlPayoutmode").val($(PayoutDetail).find('PayoutMode').text()).select();
                $("#ddlPayoutType").val($(PayoutDetail).find('PayoutType').text()).change();
                $("#ddlVendor").val($(PayoutDetail).find('Vendor').text()).change();
                $("#ddlExpense").val($(PayoutDetail).find('Expense').text()).change();
                $("#txtDate").val($(PayoutDetail).find('PayoutDate').text());
                $("#txtTime").val($(PayoutDetail).find('PayoutTime').text());
                $("#txtRemark").val($(PayoutDetail).find('Remark').text());
                $("#btnSave").hide();
                $("#btnUpdate").show();

            }
            $('#loading').hide();
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

function UpdatePayout() {
    var CurrentAmt = 0, PayoutAmt = 0;
    if ($("#hdnPayoutAmt").val() != '' || parseFloat($("#hdnPayoutAmt").val()) > 0) {
        PayoutAmt = parseFloat($("#hdnPayoutAmt").val());
    }
    CurrentAmt = parseFloat(CurrentCash());
    if ((CurrentAmt + PayoutAmt) < parseFloat($("#txtAmount").val().trim())) {
        swal({
            text: "You don't have enough cash. Do you want to proceed?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "btn-success",
                    closeModal: true,
                },
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-danger",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                UpdatePayout2();
            }
            else {
                $("#PayoutModal").modal("hide");
            }
        });
    }
    else {
        UpdatePayout2();
    }
}

function UpdatePayout2() {

    var validate = 1; var Expense = 0, Vendor = 0;
    if ($("#ddlPayoutType").val().trim() == '0') {
        toastr.error('Payout Type Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlPayoutType").val() == '1') {
        if ($("#ddlVendor").val().trim() == '0') {
            toastr.error('Vendor Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            return false;
        }
        else {
            Vendor = $("#ddlVendor").val();
        }
    }
    else if ($("#ddlPayoutType").val() == '2') {
        if ($("#ddlExpense").val().trim() == '0') {
            toastr.error('Expense Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            return false;
        }
        else {
            Expense = $("#ddlExpense").val();
        }
    }
    if ($("#txtPayTo").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Pay To Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtAmount").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtAmount").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtPayTo").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Pay To Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtDate").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Date Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTime").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Time Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtRemark").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Remark Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {
        data = {
            Expense: Expense || '0',
            Vendor: Vendor,
            PayoutType: $("#ddlPayoutType").val(),
            PayTo: $("#txtPayTo").val().trim(),
            Remark: $("#txtRemark").val().trim(),
            Amount: $("#txtAmount").val(),
            PayoutDate: $("#txtDate").val(),
            PayoutTime: $("#txtTime").val(),
            PayoutMode: $("#ddlPayoutmode").val(),
            //TransactionId: $("#txtTransactionId").val(),
            PayoutAutoId: $("#hdnPayoutId").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/PayoutMaster.aspx/UpdatePayout2",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    $('#loading').hide();
                    swal("Success!", "Payout details updated successfully.", "success", { closeOnClickOutside: false });
                    $("#PayoutModal").modal("hide");
                    PayoutReset();
                    ViewPayoutList();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function isDeletePayout(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Payout.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: false,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: false
            }
        },
    }).then((isConfirm) => {

        if (isConfirm) {
            data = {
                PayoutAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/PayoutMaster.aspx/DeletePayout",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                dataType: "json",
                contentType: "application/json;charset=utf-8",
                beforeSend: function () {
                    $('#fade').show();
                },
                complete: function () {
                    $('#fade').hide();
                },
                success: function (response) {
                    if (response.d == 'true') {
                        swal("Success!", "Payout deleted successfully.", "success", { closeOnClickOutside: false });
                        BindPayoutList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false });
                    }
                    $('#loading').hide();
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
        else {
            $('#loading').hide();
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}
function InsertPayout() {

    var CurrentAmt = 0;
    CurrentAmt = parseFloat(CurrentCash());
    if (CurrentAmt < parseFloat($("#txtAmount").val().trim())) {
        swal({
            text: "You don't have enough cash. Do you want to proceed?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "btn-success",
                    closeModal: true,
                },
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-danger",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                SavePayout();
            }
            else {
                $("#PayoutModal").modal("hide");
            }
        });
    }
    else {
        SavePayout();
    }
}

function SavePayout() {
    $("#btnSave").attr('disabled', 'disabled');
    $('#loading').hide();
    var Expense = 0, Vendor = 0;
    var validate = 1;
    if ($("#ddlPayoutType").val().trim() == '0') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Payout Type Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlPayoutType").val() == '1') {
        if ($("#ddlVendor").val().trim() == '0') {
            $('#loading').hide();
            $("#btnSave").removeAttr('disabled');
            toastr.error('Vendor Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            return false;
        }
        else {
            Vendor = $("#ddlVendor").val();
        }
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
    }
    else if ($("#ddlPayoutType").val() == '2') {
        if ($("#ddlExpense").val().trim() == '0') {
            toastr.error('Expense Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            $('#loading').hide();
            $("#btnSave").removeAttr('disabled');
            return false;
        }
        else {
            Expense = $("#ddlExpense").val();
        }
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
    }
    if ($("#txtPayTo").val().trim() == '') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Pay To Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtAmount").val().trim() == '') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtAmount").val().trim() == '.') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Please enter valid Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtAmount").val().trim()) == 0) {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    //if ($("#txtTransactionId").val().trim() == '' && $("#ddlPayoutmode").val().trim() == '2') {
    //    $('#loading').hide();
    //    toastr.error('Transaction ID Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtDate").val().trim() == '') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Date Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTime").val().trim() == '') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Time Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtRemark").val().trim() == '') {
        $('#loading').hide();
        $("#btnSave").removeAttr('disabled');
        toastr.error('Remark Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    //if ($("#ddlPayoutmode").val() == "1") {
    //    $("#txtTransactionId").val('');
    //}
    //if ($('#ddlPayoutmode option:selected').text() != 'Online') {
    //    $("#txtTransactionId").val("");
    //}
    if (validate == 1) {

        data = {
            /*  CompanyId: '',*/
            Expense: Expense || '0',
            Vendor: Vendor,
            PayoutDate: $("#txtDate").val(),
            PayoutTime: $("#txtTime").val(),
            PayoutType: $("#ddlPayoutType").val(),
            PayTo: $("#txtPayTo").val().trim(),
            Remark: $("#txtRemark").val().trim(),
            Amount: $("#txtAmount").val(),
            PayoutMode: $("#ddlPayoutmode").val(),
            /*TransactionId: $("#txtTransactionId").val()*/
        }
        $.ajax({
            type: "POST",
            url: "/Pages/PayoutMaster.aspx/InsertPayout1",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    $('#loading').hide();
                    $("#btnSave").removeAttr('disabled');
                    PayoutReset();
                    $("#PayoutModal").modal("hide");
                    swal("Success!", "Payout added successfully.", "success", { closeOnClickOutside: false });
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    $("#btnSave").removeAttr('disabled');
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
                $("#btnSave").removeAttr('disabled');
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $("#btnSave").removeAttr('disabled');
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $("#btnSave").removeAttr('disabled');
                $('#loading').hide();
            }
        })
    }
}

function PayoutReset() {
    $(".Expense").hide();
    $(".Vendor").hide();
    $("#txtRemark").val('');
    $("#txtPayTo").val('');
    $("#hdnPayoutId").val('');
    $("#hdnPayoutAmt").val('');
    $("#txtAmount").val('');
    $("#ddlPayoutType").val('0').change();
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('#txtDate').val(today);
    $("#txtTime").val(formatAMPM(new Date));
    $("#btnSave").show();
    $("#btnUpdate").hide();
    $("#txtTime").val(formatAMPM(new Date));
}

function OpenScreenList() {
    $("#txtScreenName").val('');
    $("#ddlStatus").val('1').change();
    BindScreenList(1);
    //$("#ModalAction").modal("hide");
    $("#SearchScreenModal").modal("show");
}

function OpenAddScreenModal() {
    $('#SearchScreenModal').modal('hide');
    $('#AddScreenModal').modal('show');
    $("#txtScreenSName").val("");
    $("#ddlStatusS").val(1).select();
    $("#btnAddScreen").show();
    $("#btnUpdateScreen").hide();
}

function AddScreen() {

    var validate = 1;
    if ($("#txtScreenSName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Screen Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {

        data = {
            ScreenName: $("#txtScreenSName").val(),
            Status: $("#ddlStatusS").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/InsertScreen",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    $("#txtScreenSName").val("");
                    $("#ddlStatusS").val(1).select();
                    $("#AddScreenModal").modal("hide");
                    swal("Success!", "Screen added successfully.", "success", { closeOnClickOutside: false });
                    bindMenuScreen();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function BindScreenList(pageIndex) {

    var status = '';
    $('#loading').show();
    data = {
        ScreenName: $("#txtScreenName").val().trim(),
        Status: $("#ddlStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSizeS").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/GetScreen",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ScreenList = xml.find("Table1");
                var pager = xml.find("Table");

                if (ScreenList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSearchScreenSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSizeS').show();
                    }
                    else {
                        $('#ddlPageSizeS').hide();
                    }
                    $("#spSearchScreenSortBy").show();
                    //$("#ddlPageSizeS").show();
                    $("#SearchScreenEmptyTable").hide();
                    $("#tblScreenList tbody tr").remove();
                    var row = $("#tblScreenList thead tr:first-child").clone(true);
                    $.each(ScreenList, function () {

                        $(".ScreenAutoId", row).html($(this).find("AutoId").text());
                        $(".ScreenN", row).html($(this).find("Name").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        $(".SStatus", row).html(status);
                        if ($(this).find("Name").text() != 'Home Screen' && $(this).find("Name").text() != 'Lottery') {
                            $(".ScreenAction", row).html("<a style='' Onclick='editScreen(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteScreen' onclick='isDeleteScreen(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        }
                        else {
                            $(".ScreenAction", row).html("<p>&nbsp;</p>");
                        }

                        $("#tblScreenList").append(row);
                        row = $("#tblScreenList tbody tr:last-child").clone(true);
                    });
                    $("#tblScreenList").show();
                }

                else {
                    $("#SearchScreenEmptyTable").show();
                    $("#tblScreenList").hide();
                    $("#spSearchScreenSortBy").hide();
                    $("#ddlPageSizeS").hide();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSizeS').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
            }
            $('#loading').hide();
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

function isDeleteScreen(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Screen.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: false,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: false
            }
        },
    }).then((isConfirm) => {
        if (isConfirm) {
            data = {
                ScreenId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/POS.asmx/DeleteScreen",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                dataType: "json",
                contentType: "application/json;charset=utf-8",
                beforeSend: function () {
                    $('#fade').show();
                },
                complete: function () {
                    $('#fade').hide();
                },
                success: function (response) {

                    if (response.d == 'true') {
                        swal("Success!", "Screen deleted successfully.", "success", { closeOnClickOutside: false });
                        BindScreenList(1);
                        bindMenuScreen();
                        BindScreenProduct(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false });
                    }
                    $('#loading').hide();
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
        else {
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function editScreen(id) {

    data = {
        ScreenId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/editScreen",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ScreenDetail = xml.find("Table");

                $('#SearchScreenModal').modal('hide');
                $("#AddScreenModal").modal("show");

                $("#hdnPayoutId").val($(ScreenDetail).find('AutoId').text());
                $("#txtScreenSName").val($(ScreenDetail).find('Name').text());
                $("#ddlStatusS").val($(ScreenDetail).find('Status').text()).select();
                $("#btnAddScreen").hide();
                $("#btnUpdateScreen").show();

            }
            $('#loading').hide();
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

function UpdateScreen() {

    var validate = 1;
    if ($("#txtScreenSName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Screen Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {

        data = {
            ScreenId: $("#hdnPayoutId").val(),
            ScreenName: $("#txtScreenSName").val(),
            Status: $("#ddlStatusS").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/UpdateScreen",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    $("#txtScreenSName").val("");
                    $("#ddlStatusS").val(1).select();
                    $("#AddScreenModal").modal("hide");
                    swal("Success!", "Screen updated successfully.", "success", { closeOnClickOutside: false });
                    bindMenuScreen();
                    BindScreenList(1);
                    BindScreenProduct(1);
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function OpenCouponModal() {
    if (parseFloat($('#lblcoupan').text()) == 0) {
        $("#txtGift").val('');
        //$("#CardTypeModal").modal("hide");
        $("#GiftModal").modal("show");
    }
    else {
        swal("Warning!", "Coupon already applied!", "warning", { closeOnClickOutside: false });
    }
}

function CloseCouponModal() {
    $("#txtGift").val('');
    $("#GiftModal").modal("hide");
}

var CouponAmt = 0, CouponNo = '', MinCouponOrderAmt = 0;
function ApplyCoupon() {
    if ($("#txtGift").val().trim() == '') {
        toastr.error('Required Coupon Code!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('.Gift').hide();
    var i = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        i++;
    });
    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            FocusOnBarCode();
        });
        return;
    }
    else {
        data = {
            TotalAmt: $('#lblgrandtotal').text(),
            CouponCode: $('#txtGift').val().trim()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/ApplyCoupon",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {

                if (response.d == 'Invalid Coupon Code!') {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false }).then(function () {
                        $('#txtGift').val('');
                    });
                }
                else if (response.d == 'Minimum') {
                    $('#loading').hide();
                    swal("Warning!", 'Coupon is not applicable due to less Order Amount.', "warning", { closeOnClickOutside: false }).then(function () {
                        $('#txtGift').val('');
                    });
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var GiftCardDetail = xml.find("Table");
                    var LottoPayoutAmt = 0, TotalLotterySale = 0;
                    $('#tblProductDetail .product-addlist').each(function () {
                        Quantity = $(this).find('.quantity').val();
                        UnitPrice = $(this).find('.spnUnitPrice').text().replace(CSymbol, '');
                        if ($(this).find('.SKUName').text() == 'Lottery Payout') {
                            LottoPayoutAmt = LottoPayoutAmt + (parseFloat(Quantity) * parseFloat(UnitPrice));
                        }
                        if (($(this).find('.SKUName').text().trim()).includes('Lottery') && $(this).find('.SKUName').text().trim() != 'Lottery Payout') {
                            TotalLotterySale = TotalLotterySale + (parseFloat(Quantity) * parseFloat(UnitPrice));
                        }
                    });
                    $.each(GiftCardDetail, function () {
                        if ($(this).find("CouponType").text() == 1 && parseFloat($(this).find("CouponAmount").text()) <= ((parseFloat($('#lblgrandtotal').text()) + LottoPayoutAmt - TotalLotterySale))) {
                            CouponNo = $(this).find("AutoId").text();
                            MinCouponOrderAmt = parseFloat($(this).find("CouponAmount").text()).toFixed(2);
                            CouponAmt = parseFloat($(this).find("Discount").text()).toFixed(2);
                            var Tamt = parseFloat($('#lblgrandtotal').text()).toFixed(2);
                            if (parseFloat(Tamt) < parseFloat(MinCouponOrderAmt)) {
                                swal('Warning!', 'Coupon is not applicable.', 'warning', { closeOnClickOutside: false }).then(function () {
                                    RemoveGift();
                                    calc_total();
                                });
                            }
                            else {
                                if (parseFloat(Tamt) <= parseFloat(CouponAmt)) {
                                    CouponAmt = Tamt;
                                }
                                swal("Success!", "Coupon applied successfully.", "success", { closeOnClickOutside: false }).then(function () {
                                    $("#GiftModal").modal("hide");
                                    $("#ModalAction").modal("hide");
                                    calc_total();
                                });
                            }
                        }
                        else if ($(this).find("CouponType").text() == 0 && parseFloat($(this).find("CouponAmount").text()) <= (parseFloat($('#lblgrandtotal').text()) + LottoPayoutAmt - TotalLotterySale)) {
                            var Tamt = parseFloat($('#lblgrandtotal').text()) + LottoPayoutAmt - TotalLotterySale;
                            var Gamt1 = (Tamt * parseFloat($(this).find("Discount").text())) / 100;
                            CouponNo = $(this).find("AutoId").text();
                            MinCouponOrderAmt = parseFloat($(this).find("CouponAmount").text()).toFixed(2);
                            CouponAmt = parseFloat(Gamt1).toFixed(2);
                            if (parseFloat(Tamt) < parseFloat(MinCouponOrderAmt)) {
                                swal('Warning!', 'Coupon is not applicable.', 'warning', { closeOnClickOutside: false }).then(function () {
                                    RemoveGift();
                                    calc_total();
                                });
                            }
                            else {
                                swal("Success!", "Coupon applied successfully.", "success", { closeOnClickOutside: false }).then(function () {
                                    $("#GiftModal").modal("hide");
                                    $("#ModalAction").modal("hide");
                                    calc_total();
                                });
                            }
                        }
                        else if (LottoPayoutAmt != 0 || TotalLotterySale != 0) {
                            swal('Warning', 'Coupon is not applicable on Lottery!', '', { closeOnClickOutside: false });
                        }
                    });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function DeleteCouponRow(e) {
    RemoveGift();

    //PayMentMethod = '';
    calc_total();
    $(e).closest('tr').remove();
    if ($("#tblTransaction tr").length == 0) {
        //$("#tblTransaction").hide();
    }
}

function RemoveGift() {
    $("#tblTransaction").find('.CouponTr').remove();
    $('.Gift').hide();
    CouponAmt = 0;
    CouponNo = '';
    MinCouponOrderAmt = 0;
    //calc_total();
}

function ClockInOutPopUp() {
    $("#ModalAction").modal("hide");
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/CheckClockInOut",
        data: "",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'Invalid Gift-Card!') {
                $('#loading').hide();
                swal("Error!", response.d, "error", { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ClockInOutDetail = xml.find("Table");
                if (ClockInOutDetail.length == 0) {
                    $('.h5clockIn').show();
                    $('.h5clockOut').hide();
                    $('#clockout').hide();
                    $('#Clockin').show();
                    $('.ClockInDate').hide();
                    $("#txtClockInDate").val('');
                    $("#txtremarkClock").val('');
                    $("#ClockInOutModal").modal("show");
                }
                $.each(ClockInOutDetail, function () {

                    if ($(this).find("ClockOUT").text() == "") {
                        $('.h5clockIn').hide();
                        $('.h5clockOut').show();
                        $('#clockout').show();
                        $('#Clockin').hide();
                        $('.ClockInDate').show();
                        $("#txtClockInDate").val($(this).find("ClockIn").text());
                        $("#txtremarkClock").val('');
                        $("#ClockInOutModal").modal("show");
                    }
                    else {
                        $('.h5clockIn').show();
                        $('.h5clockOut').hide();
                        $('#clockout').hide();
                        $('#Clockin').show();
                        $('.ClockInDate').hide();
                        $("#txtClockInDate").val('');
                        $("#txtremarkClock").val('');
                        $("#ClockInOutModal").modal("show");
                    }
                });

            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    })

}

function ClockIn() {
    data = {
        Remark: $('#txtremarkClock').val().trim(),
        DateTime: $('#spnTimer2').val()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/ClockIn",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'Already Clocked In!') {
                $('#loading').hide();
                swal("Error!", response.d, "error", { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal("Success!", "Clocked In.", "success", { closeOnClickOutside: false });
                $("#ClockInOutModal").modal("hide");

            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    })
}

function ClockOut() {
    data = {
        Remark: $('#txtremarkClock').val().trim(),
        DateTime: $('#spnTimer2').val()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/ClockOut",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'Already Clocked Out!') {
                $('#loading').hide();
                swal("Error!", response.d, "error", { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal("Success!", "Clocked Out.", "success", { closeOnClickOutside: false });
                $("#ClockInOutModal").modal("hide");

            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    })
}

function OpenLottoPaout() {
    openCal('LottoPay');
}

function OpenLottoSale() {
    openCal('LottoSale');
}


function Deposit() {
    $('.Deposit').show();
    $('.Withdraw').hide();
    $("#ModalAction").modal("hide");
    $("#ModalDeposit").modal("show");
    DepositReset();
}

function Withdraw() {
    $('.Deposit').hide();
    $('.Withdraw').show();
    $("#ModalAction").modal("hide");
    //$("#ModalDeposit").modal("show");
    $('#ModalWithdraw').modal('show');
    $('#txtpasswordW').val('');
    $('#txtpasswordW').focus();
    DepositReset();
}

function ViewPasswordWith() {

    if ($('#txtpasswordW').prop('type') == 'password') {
        $('#txtpasswordW').prop("type", "text");
    }
    else {
        $('#txtpasswordW').prop("type", "password");
    }
}

function CloseModalWithdraw() {
    $('#ModalWithdraw').modal('hide');
    FocusOnBarCode();
}

function DepositReset() {
    $("#txtDAmount").val('0.00');
    $("#txtDRemark").val('');
    $("#btnDeposit1").removeAttr('disabled');
    $("#btnWithdraw1").removeAttr('disabled');
}

function SaveDeposit() {
    $("#btnDeposit1").attr('disabled', 'disabled');
    $('#loading').show();
    if (parseFloat($("#txtDAmount").val().trim()) == 0 || $("#txtDAmount").val().trim() == "") {
        $('#loading').hide();
        $("#btnDeposit1").removeAttr('disabled');
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    data = {
        Amount: $('#txtDAmount').val(),
        Remark: $('#txtDRemark').val()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/SaveDeposit",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'false') {
                $('#loading').hide();
                $("#btnDeposit1").removeAttr('disabled');
                swal("Error!", response.d, "error", { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                $('#loading').hide();

                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var SafeCashList = xml.find("Table");
                var AID = '';
                $.each(SafeCashList, function () {
                    if ($(this).find("AutoId").text() != "") {
                        AID = $(this).find("AutoId").text();
                    }
                });
                swal("Success!", "Deposited successfully.", "success", { closeOnClickOutside: false }).then(function () {
                    $("#btnDeposit1").removeAttr('disabled');
                    PrintSafeCash(AID);
                });
                $("#ModalDeposit").modal("hide");
            }
            //else {
            //    swal("Error!", "Error occured.", "error", { closeOnClickOutside: false });
            //    $("#ModalDeposit").modal("hide");
            //}
            $('#loading').hide();
            $("#btnDeposit1").removeAttr('disabled');
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $("#btnDeposit1").removeAttr('disabled');
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $("#btnDeposit1").removeAttr('disabled');
            $('#loading').hide();
        }
    })
}

function PrintSafeCash(AutoId) {

    window.open("/Pages/SafeCashSlip.html?dt=" + AutoId, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
}

function WithdrawSec() {
    var validate = 1;
    if ($('#txtpasswordW').val().trim() == '') {
        toastr.error('Please enter security pin.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/WithdrawSecurity",
            data: "{'password':'" + $('#txtpasswordW').val().trim() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "Some error occured!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpasswordW').val('');
                    });
                } else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else if (response.d == "failed") {
                    swal("", "Access Denied!", "error", { closeOnClickOutside: false }).then(function () {
                        $('#txtpasswordW').val('');
                    });
                }
                else if (response.d == "Success") {
                    $('#ModalWithdraw').modal('hide');
                    $("#ModalDeposit").modal("show");
                }
                else {
                    window.location.href = "/Default.aspx"
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

function SaveWithdraw() {
    $("#btnWithdraw1").attr('disabled', 'disabled');
    $('#loading').show();
    if (parseFloat($("#txtDAmount").val().trim()) == 0 || $("#txtDAmount").val().trim() == "") {
        $('#loading').hide();
        $("#btnWithdraw1").removeAttr('disabled');
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    data = {
        Amount: $('#txtDAmount').val(),
        Remark: $('#txtDRemark').val()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/SaveWithdraw",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {

            if (response.d == 'false') {
                $('#loading').hide();
                $("#btnWithdraw1").removeAttr('disabled');
                swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
            }
            else if (response.d == 'Insufficient Safe Cash Amount!') {
                $('#loading').hide();
                $("#btnWithdraw1").removeAttr('disabled');
                swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var SafeCashList = xml.find("Table");
                var AID = '';
                $.each(SafeCashList, function () {
                    if ($(this).find("AutoId").text() != "") {
                        AID = $(this).find("AutoId").text();
                    }
                });
                swal("Success!", "Withdraw successfully.", "success", { closeOnClickOutside: false }).then(function () {
                    $("#btnWithdraw1").removeAttr('disabled');
                    PrintSafeCash(AID);
                });
                $("#ModalDeposit").modal("hide");
            }
            //else {
            //    swal("Warning!", response.d, "error", { closeOnClickOutside: false });
            //    $("#ModalDeposit").modal("hide");
            //}
            $('#loading').hide();
            $("#btnWithdraw1").removeAttr('disabled');
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
            $("#btnWithdraw1").removeAttr('disabled');
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
            $("#btnWithdraw1").removeAttr('disabled');
        }
    })
}

function SafeCashList() {

    $("#tblSafeList tbody tr").remove();
    $("#txtAmount1").val('0.00');
    $("#ddlMode2").val('0').change();
    var n = new Date();
    var d = ("0" + n.getDate()).slice(-2);
    var m = ("0" + (n.getMonth() + 1)).slice(-2);
    var todayS = (m) + "/" + (d) + "/" + n.getFullYear();
    $("#txtStartDate").val(todayS);
    $("#txtEndDate").val(todayS);
    $("#ModalAction").modal("hide");
    $("#SafeCashList").modal("show");
    BindSafeCashList(1, 0);
}

function CloseSafeCashList() {
    $("#SafeCashList").modal("hide");
    FocusOnBarCode();
}
function BindSafeCashList(pageIndex, chk) {
    debugger
    //$("#Total").text('$0.00');

    //$('#loading').show();
    if (chk != 1) {
        if ($("#txtStartDate").val().trim() != '' && $("#txtEndDate").val().trim() && (Date.parse($("#txtStartDate").val()) > Date.parse($("#txtEndDate").val()))) {
            $('#loading').hide();
            toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            return false;
        }
        if ($("#txtStartDate").val() == '' || $("#txtEndDate").val() == '') {
            $('#loading').hide();
            toastr.error('Both From Date and To Date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            validate = 0;
            return false;
        }
    }
    data = {
        Terminal: 0,
        FromDate: $("#txtStartDate").val(),
        ToDate: $("#txtEndDate").val(),
        Amount: parseFloat($("#txtAmount1").val()) || 0,
        Mode: $("#ddlMode2").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSizePS").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SafeCash.aspx/BindSafeCashList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ModuleList = xml.find("Table1");
                var pager = xml.find("Table");
                var TotalAmt = xml.find("Table2");
                var status = ""; var Mode1 = "";
                $.each(TotalAmt, function () {

                    if ($(this).find("Total").text() == '') {
                        $("#Total", row).html(CSymbol + '0.00');
                    }
                    else {
                        if (parseFloat($(this).find("Total").text()) < 0) {
                            var T = parseFloat($(this).find("Total").text()) - parseFloat($(this).find("Total").text() * 2);
                            $("#Total", row).html('-' + CSymbol + parseFloat(T).toFixed(2));
                        }
                        else {
                            $("#Total", row).html(CSymbol + $(this).find("Total").text());
                        }
                    }
                });
                if (ModuleList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSizePS').show();
                    }
                    else {
                        $('#ddlPageSizePS').hide();
                    }
                    $("#spSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#SafeEmptyTable").hide();
                    $("#tblSafeList tbody tr").remove();
                    var row = $("#tblSafeList thead tr:first-child").clone(true);
                    var TotalDep = 0, TotalWith = 0;
                    $.each(ModuleList, function () {

                        status = '';
                        $(".SafeCashAutoId", row).html($(this).find("AutoId").text());
                        if ($(this).find("Mode").text() == 1) {
                            $(".Mode", row).html('Deposit');
                            Mode1 = $(this).find("Mode").text();
                            TotalDep += parseFloat($(this).find("Amount").text());
                        }
                        else {
                            $(".Mode", row).html('Withdraw');
                            Mode1 = $(this).find("Mode").text();
                            TotalWith += parseFloat($(this).find("Amount").text());
                        }

                        $(".Amount", row).html($(this).find("Amount").text());
                        $(".Remark", row).html($(this).find("Remark").text());
                        $(".CreatedDate", row).html($(this).find("CreatedDate").text());
                        $(".CreatedBy", row).html($(this).find("CreatedBy").text());
                        $(".Terminal", row).html($(this).find("TerminalName").text());
                        if ($(this).find("Status").text() == 0) {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Open</span>";
                            if ($('#hdnEmpAutoId').val() == $(this).find("Emp").text()) {
                                $(".Action", row).html("<a id='btnDeleteSafe' onclick='isDeleteSafe(" + $(this).find("AutoId").text() + "," + Mode1 + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a id='btnPrintSafe' onclick='PrintSafeCash(" + $(this).find("AutoId").text() + ")' title='Print' style='cursor:pointer'><i class='fa fa-print' style='color:black'></i></a >");
                            }
                            else {
                                $(".Action", row).html(" ");
                            }
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Closed</span>"
                            if ($('#hdnEmpAutoId').val() == $(this).find("Emp").text()) {
                                $(".Action", row).html(" ");
                            }
                            else {
                                $(".Action", row).html(" ");
                            }
                        }
                        $(".Status", row).html(status);
                        $("#tblSafeList").append(row);
                        row = $("#tblSafeList tbody tr:last-child").clone(true);
                    });
                    var TotalAmt = TotalDep - TotalWith;
                    $("#spn_TotalSafe").text((CSymbol + parseFloat(TotalAmt).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                    $("#tblSafeList").show();
                }
                else {
                    $("#SafeEmptyTable").show();
                    $("#tblSafeList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSizePS").hide();
                }
                //var pager = xml.find("Table");
                $("#BindSafeCashListPager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSizePS').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
            }
            $('#loading').hide();
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

function isDeleteSafe(id, Mode1) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this Safe Cash.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: false,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: false
            }
        },
    }).then((isConfirm) => {
        if (isConfirm) {
            $('#loading').show();
            data = {
                SafeCashAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/SafeCash.aspx/DeleteSafeCash",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                dataType: "json",
                contentType: "application/json;charset=utf-8",
                beforeSend: function () {
                    $('#fade').show();
                },
                complete: function () {
                    $('#fade').hide();
                },
                success: function (response) {
                    if (response.d == 'true') {
                        if (Mode1 == 1) {
                            swal("Success!", "Deposit Safe Cash deleted successfully.", "success", { closeOnClickOutside: false });
                        }
                        else {
                            swal("Success!", "Withdraw Safe Cash deleted successfully.", "success", { closeOnClickOutside: false });
                        }

                        BindSafeCashList(1, 1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false });
                    }
                    $('#loading').hide();
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
        else {
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function GiftCard() {
    if ($('#ddlCustomer').val().trim() == 'Walk In' || $('#ddlCustomer').val().trim() == 'Walk in' || $('#ddlCustomer').val().trim() == 'Walk IN') {
        $("#ModalAction").modal("hide");
        $("#AddCustomerModal").modal("show");
        $('.GiftSection').show();
        $('#btnAddCustomer').hide();
        $('#NewCustomer').hide();

        $("#txtFirstName").val('');
        $("#txtLastName").val('');
        $("#txtGiftNo").val('');
        $("#txtGiftAmount").val('');
        $("#txtMobileNo").val('');
        $("#txtDOB").val('');
        $("#txtEmailId").val('');
        $("#txtAddress").val('');
        $("#txtCity").val('');
        $("#txtState").val('0').change();
        $("#txtZipCode").val('');
        $("#txtGiftNo").focus();
    }
    else {
        var data = {
            CustomerId: $('#hdnCustomerId').val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/FillCustomerDetails",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {

                if (response.d == 'Invalid Gift-Card!') {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var CustomerDetails = xml.find("Table");
                    $.each(CustomerDetails, function () {
                        $("#txtFirstName").val($(this).find("FirstName").text()).attr('disabled', 'disabled');
                        $("#txtLastName").val($(this).find("LastName").text());
                        $("#txtMobileNo").val($(this).find("MobileNo").text()).attr('disabled', 'disabled');
                        $("#txtDOB").val($(this).find("DOB").text());
                        $("#txtEmailId").val($(this).find("EmailId").text());
                        $("#txtAddress").val($(this).find("Address").text());
                        $("#txtCity").val($(this).find("City").text());
                        $("#txtState").val($(this).find("State").text()).change();
                        $("#txtZipCode").val($(this).find("ZipCode").text());
                    });
                    $("#ModalAction").modal("hide");
                    $("#txtGiftNo").val('');
                    $("#txtGiftAmount").val('0.00');
                    $("#AddCustomerModal").modal("show");
                    $('.GiftSection').show();
                    $('#btnAddCustomer').hide();
                    $('#NewCustomer').hide();
                    $("#txtGiftNo").focus();
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        })
    }
}
var TempGiftCartList = [];
function AddGiftCard() {
    debugger;
    $('#loading').show();
    var validate = 1;
    if ($("#txtGiftNo").val().trim() == "") {
        toastr.error('Please fill Gift Card Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtGiftNo").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    if ($("#txtGiftAmount").val().trim() == "") {
        toastr.error('Please fill Gift Card Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtGiftAmount").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    if (parseFloat($("#txtGiftAmount").val().trim()) <= 0) {
        toastr.error('Please fill Gift Card Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtGiftAmount").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    if ($("#txtFirstName").val().trim() == "") {
        toastr.error('Please fill First Name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFirstName").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    if ($("#txtMobileNo").val().trim() == "") {
        toastr.error('Please fill Mobile Number.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtMobileNo").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    if ($("#txtMobileNo").val().trim().length > 1) {
        if ($("#txtMobileNo").val().trim().length != 10) {
            toastr.error('Mobile no must be of 10 digit.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            $("#txtMobileNo").addClass('border-warning');
            validate = 0;
            $('#loading').hide();
            return false;
        }
    }
    if ($("#txtZipCode").val().trim() != "" && $("#txtZipCode").val().length != 5) {
        toastr.error('Please fill valid Zip Code!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtZipCode").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    var regEmail = new RegExp(/^([\w+-.%]+@[\w-.]+\.[A-Za-z]{2,4},?)+$/);
    if (!regEmail.test($("#txtEmailId").val().replace(" ", "").trim()) && $("#txtEmailId").val().trim() != "") {
        toastr.error('Invalid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEmailId").addClass('border-warning');
        validate = 0;
        $('#loading').hide();
        return false;
    }

    var k = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if ($(item).find('.SKUName').text() != '0' || $(item).find('.SKUName').text() == '') {
            if (TempGiftCartList.includes($("#txtGiftNo").val().trim())) {
                k++;
            }
        }
    });
    debugger;
    if (k > 0) {
        toastr.error('Gift Card Code already exists in cart.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtGiftNo").val('');
        validate = 0;
        $('#loading').hide();
        return false;
    }
    var OrderNo = '', GiftCardNo = '';
    if (localStorage.getItem("OrderNo") != '' && localStorage.getItem("OrderNo") != null && localStorage.getItem("OrderNo") != undefined) {
        OrderNo = localStorage.getItem("OrderNo");
    }
    localStorage.getItem("OrderNo");
    var CustomerId = $('#hdnCustomerId').val();
    GiftCardNo = $("#txtGiftNo").val().trim();
    //var GN = hideWord(GiftCardNo);

    if (validate == 1) {
        var data = {
            FirstName: $("#txtFirstName").val().trim(),
            LastName: $("#txtLastName").val().trim(),
            MobileNo: $("#txtMobileNo").val().trim(),
            DOB: $("#txtDOB").val().trim(),
            OrderNo: OrderNo,
            SKUName: 'Gift Card - ' + $("#txtGiftNo").val().trim(),
            EmailId: $("#txtEmailId").val().trim(),
            Address: $("#txtAddress").val().trim(),
            City: $("#txtCity").val().trim(),
            State: $("#txtState").val(),
            ZipCode: $("#txtZipCode").val().trim(),
            GiftCardNo: $("#txtGiftNo").val().trim(),
            GiftCardAmt: $("#txtGiftAmount").val().trim(),
            CustomerId: CustomerId || 0,
            Quantity: 1
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POS.asmx/AddGiftCard",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                debugger;
                if (response.d == 'false') {
                    swal("", "Product not found!", "warning", { closeOnClickOutside: false });
                }
                else if (response.d == "Session") {
                    swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                        window.location.href = "/Default.aspx";
                    });
                }
                else {
                    debugger;
                    TempGiftCartList.push(GiftCardNo);
                    var JsonObj = $.parseJSON(response.d);
                    AddInCart(JsonObj);

                    if ($("#tblProductDetail .product-addlist").length > 0) {
                        $('#txt_PayNow').removeAttr('disabled');
                    }
                    else {
                        $('#txt_PayNow').attr('disabled', 'disabled');
                    }

                    $('#loading').hide();
                    CloseAddCustModal();
                    swal('Success!', 'Gift Card added successfully.', 'success', { closeOnClickOutside: false });
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
//

function AddInCart(JsonObj) {
    debugger;
    $("#hdnOrderId").val(JsonObj[0].OrderDetail[0].OrderId);
    $("#hdnOrderNo").val(JsonObj[0].OrderDetail[0].OrderNo);
    $("#hdnCustomerId").val(JsonObj[0].CustomerDetail[0].AutoId);
    $("#txtAvlHappyPoints").val(JsonObj[0].CustomerDetail[0].AssignedRoyaltyPoints);
    $("#hdnRoyaltyPoints").val(JsonObj[0].CustomerDetail[0].AssignedRoyaltyPoints);
    $("#ddlCustomer").val(JsonObj[0].CustomerDetail[0].Name);
    $('#totalProductCnt').text(JsonObj[0].OrderDetail[0].ItemCount);
    $('#totalQuantityCnt').text(JsonObj[0].OrderDetail[0].TotalQuantity);
    if (parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0 || parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal) != 0) {
        $('#Lotterylbl').show();
    }
    else {
        $('#Lotterylbl').hide();
    }
    $('#lblLottery').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].LotteryTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    $('#lblLottoPayout').text(parseFloat(JsonObj[0].OrderDetail[0].LotteryPayout).toFixed(2));
    if (JsonObj[0].OrderDetail[0].DiscType == 'Percentage') {
        $('#DiscType').text('(' + parseFloat(JsonObj[0].OrderDetail[0].DiscountPer).toFixed(2) + '%)');

    }
    else {
        $('#DiscType').text('(' + CSymbol + ')');
    }

    $('#lbldiscount1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    $('#lbldiscount').text(parseFloat(JsonObj[0].OrderDetail[0].Discount).toFixed(2));

    $('#lblsubtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].Subtotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    $('#lblsubtotal').text(JsonObj[0].OrderDetail[0].Subtotal);
    $('#lbltax').text(parseFloat(JsonObj[0].OrderDetail[0].TotalTax).toFixed(2));
    $('#lblgrandtotal1').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].OrderTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
    $('#lblgrandtotal').text(JsonObj[0].OrderDetail[0].OrderTotal);
    if (parseFloat(JsonObj[0].OrderDetail[0].OrderTotal) < 0) {
        $('#lblOdrTotal').css('color', 'red');
        $('#lblgrandtotal1').css('color', 'red');
    }
    else {
        $('#lblOdrTotal').css('color', 'green');
        $('#lblgrandtotal1').css('color', 'green');
    }
    if (parseFloat(JsonObj[0].OrderDetail[0].Discount) > 0) {
        $('#DiscRemove').show();
    }
    else {
        $('#lbldiscount').text('0.00');
        $('#lbldiscount1').text(CSymbol + '0.00');
        $('#DiscRemove').hide();
    }

    localStorage.clear();
    localStorage.setItem("OrderNo", JsonObj[0].OrderDetail[0].OrderNo);
    localStorage.setItem("OrderId", JsonObj[0].OrderDetail[0].OrderId);

    //if ($("#tblProductDetail").length > 0) {
    //    var SKUId = 0, Quantity = 0, UnitPrice = 0, Tax = 0, i = 0;
    //    $('#tblProductDetail .product-addlist').each(function () {
    //        SKUId = $(this).find('.hdnSKUId').val();
    //        if (SKUId == $(ProductDetail).find("SKUId").text()) {

    //            $(this).find('.hdnSchemeId').val($(ProductDetail).find("SchemeId").text());

    //if (parseFloat($(ProductDetail).find("UnitPrice").text()) != parseFloat($(ProductDetail).find("SKUSubTotal").text())) {
    //    $(this).find('.original-price').text(CSymbol + parseFloat($(ProductDetail).find("UnitPrice").text()).toFixed(2));
    //    $(this).find('.original-price').show();
    //}
    //else {
    //    $(this).find('.original-price').val('');
    //    $(this).find('.original-price').hide();
    //}

    //            $(this).find('.spnUnitPrice').text($(ProductDetail).find("SKUSubTotal").text());
    //            $(this).find('.quantity').val($(ProductDetail).find("Quantity").text());
    //            $(this).find('.spntax').text($(ProductDetail).find("Tax").text());
    //            $(this).find('.SKUName').text($(ProductDetail).find("SKUName").text());
    //            i += 1;
    //        }
    //    });
    //}

    $("#tblProductDetail").html('');
    var len = JsonObj[0].ProductList.length;
    var product = "";
    if (len > 0) {
        for (var i = 0; i < len; i++) {
            var SKUName = JsonObj[0].ProductList[i].SKUName;
            var newStr = SKUName.replace(/'/g, "");

            if (SKUName == 'Lottery Payout') {
                product += '<div class="row product-addlist" style="padding-top: 5px;background-color:#ffcfcf;">';
            }
            else if (SKUName == 'Lottery Sale') {
                product += '<div class="row product-addlist" style="padding-top: 5px;background-color:#f7f7d4;">';
            }

            else {
                product += '<div class="row product-addlist" style="padding-top: 5px;">';
            }
            product += '<div class="col-md-2"><img src="..' + JsonObj[0].ProductList[i].ProductImagePath + '" class="product-img" onerror="errorImg(this)" /></div>';
            product += '<div class="col-md-10">';
            product += '<div class="row" style="margin-bottom: 10px;margin-left: 0px;">';
            product += '<div class="col-md-12">';
            product += '';
            if (SKUName.includes('Gift Card')) {
                SKUName = 'Gift Card - ' + hideWord((SKUName.replace('Gift Card -', '')).trim());
            }
            product += '<h6 class="SKUName">' + SKUName + '</h6>';
            product += '<input type="hidden" class="hdnSKUId" value="' + JsonObj[0].ProductList[i].SKUId + '" />';
            product += '<input type="hidden" class="hdnAge" value="' + JsonObj[0].ProductList[i].MinAge + '" />';
            product += '<input type="hidden" class="hdnCartItemId" value="' + JsonObj[0].ProductList[i].AutoId + '" />';
            product += '<input type="hidden" class="hdnSchemeId" value="' + JsonObj[0].ProductList[i].SchemeId + '" />';
            product += '</div></div>';
            product += '<div class="row">';
            product += '<div class="col-md-6">';
            product += '<div class="row" style="text-align:right;margin-left: 4px;">';
            product += '<div class="col-md-3" style="padding:0px; text-align:right">';
            debugger;
            if (parseFloat(JsonObj[0].ProductList[i].UnitPrice) != parseFloat(JsonObj[0].ProductList[i].OrgUnitPrice) && JsonObj[0].ProductList[i].IsProduct == '0') {
                product += '<p><span class="original-price">' + CSymbol + parseFloat(JsonObj[0].ProductList[i].OrgUnitPrice).toFixed(2) + '</span></p>';
            }
            else {
                product += '<p><span class="original-price" style="display:none"></span></p>';
            }
            product += '</div>';
            product += '<div class="col-md-4" style="padding:0px;text-align:right;margin-left: 20px;">';
            if (parseFloat(JsonObj[0].ProductList[i].UnitPrice) < 0) {
                product += '<p style="white-space:nowrap">-' + CSymbol + '<span class="spnUnitPrice">' + parseFloat(JsonObj[0].ProductList[i].UnitPrice).toFixed(2).replace('-', '') + '</span></p>';

            }
            else {
                product += '<p style="white-space:nowrap">' + CSymbol + '<span class="spnUnitPrice">' + parseFloat(JsonObj[0].ProductList[i].UnitPrice).toFixed(2).replace('-', '') + '</span></p>';
            }
            product += '</div>';
            product += '<div class="col-md-5" style="padding:0px; text-align:right">';
            product += '<p style="display:none"><span>Tax: ' + CSymbol + '</span><span class="spntax">' + parseFloat(JsonObj[0].ProductList[i].Tax).toFixed(2) + '</span></p>';
            product += '</div>';
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            product += '</div>';
            product += '</div>';
            product += '<div class="col-md-5">';
            product += '<div class="form-row">';
            SKUName = SKUName.replace(/'/g, "&apos;");
            if (JsonObj[0].ProductList[i].SKUId != 0) {
                product += "<button type='button' class='minus-no btn' onclick='PlusMinusProduct(\"" + SKUName + "\"," + JsonObj[0].ProductList[i].SKUId + "," + JsonObj[0].ProductList[i].Quantity + ",0," + JsonObj[0].ProductList[i].AutoId + ")'><i class='fa fa-minus' aria-hidden='true'></i></button>";

                product += '<input type="text" tabindex="0" class="form-control w-25 mx-2 quantity input-no text-center" onkeypress="return isNumberKey(event)"  maxlength="3" value="' + JsonObj[0].ProductList[i].Quantity + '" readonly style="width: 50px;font-size: 24px;" />';

                product += "<button type='button' class='minus-no btn' onclick='PlusMinusProduct(\"" + SKUName + "\"," + JsonObj[0].ProductList[i].SKUId + "," + JsonObj[0].ProductList[i].Quantity + ",1," + JsonObj[0].ProductList[i].AutoId + ")'><i class='fa fa-plus' aria-hidden='true'></i></button>";
            }
            else {
                product += "<button type='button' disabled='disabled' class='minus-no btn' onclick='PlusMinusProduct(\"" + SKUName + "\"," + JsonObj[0].ProductList[i].SKUId + "," + JsonObj[0].ProductList[i].Quantity + ",0," + JsonObj[0].ProductList[i].AutoId + ")'><i class='fa fa-minus' aria-hidden='true'></i></button>";

                product += '<input type="text" tabindex="0" class="form-control w-25 mx-2 quantity input-no text-center" onkeypress="return isNumberKey(event)"  maxlength="3" value="' + JsonObj[0].ProductList[i].Quantity + '" readonly style="width: 50px;font-size: 24px;" />';

                product += "<button type='button' disabled='disabled' class='minus-no btn' onclick='PlusMinusProduct(\"" + SKUName + "\"," + JsonObj[0].ProductList[i].SKUId + "," + JsonObj[0].ProductList[i].Quantity + ",1," + JsonObj[0].ProductList[i].AutoId + ")'><i class='fa fa-plus' aria-hidden='true'></i></button>";
            }
            product += '</div></div>';
            product += '<div class="col-md-1" style="padding-left: 0px;">';
            product += '<i class="fa fa-trash fa-2x" title="Remove" style="color:red;cursor: pointer;" onclick="deleterow(this,\'' + newStr + '\',' + JsonObj[0].ProductList[i].SKUId + ',0,' + JsonObj[0].ProductList[i].AutoId + ')"></i>';
            product += '</div></div></div> ';
            product += '<div class="col-md-12"><hr style="margin:0px; margin-top: 5px;" /></div ></div > ';
        }

        $("#emptyTable").hide();
        $("#tblProductDetail").prepend(product);
    }
}

function hideWord(number) {
    let string = String(number)
    let sliced = string.slice(-4);
    let mask = String(sliced).padStart(string.length, "*")
    return mask;
}

function OpenGiftCard1() {
    $("#CardTypeModal").modal('hide');
    $("#GiftCardRedeemModal").modal('show');
}

function CloseGiftCardRedeemModal() {
    $("#txtGiftCardNo").val('');
    $("#GiftCardRedeemModal").modal('hide');
    $("#ModalCash").modal('show');
}

var GiftCardAmt = 0, TempGiftCardAmt = 0, GiftCardNo = '', GiftCardLeftAmt = 0,
    TempGiftCardLeftAmt = 0, GiftCardAppliedStatus = 0, TempGiftCardUsedAmt = 0, PushGiftCardMessage = 0;
function RedeemGiftCard() {
    debugger;
    if ($("#txtGiftCardNo").val().trim() == "") {
        toastr.error('Required Gift Card Code!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtGiftCardNo").addClass('border-warning');
        validate = 0;
        return false;
    }
    data = {
        GiftCardNo: $("#txtGiftCardNo").val().trim(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/RedeemGiftCard",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
                $("#txtGiftCardNo").val('');
            }
            else if (response.d == 'Gift Card is not sold yet!') {
                swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                $("#txtGiftCardNo").val('');
            }
            else if (response.d == 'Gift Card has been already used!') {
                swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                $("#txtGiftCardNo").val('');
            }
            else if (response.d == 'Session') {
                swal('Error!', 'Session Expired.', 'error', { closeOnClickOutside: false }).then(function () {
                    window.location.href = 'Default.aspx';
                });
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var GiftCardDetails = xml.find("Table");
                GiftCardAmt = $(GiftCardDetails).find("TotalAmt").text();
                GiftCardLeftAmt = $(GiftCardDetails).find("LeftAmt").text();
                GiftCardNo = $(GiftCardDetails).find("GiftCardCode").text();
                PushGiftCardMessage = 0;
                if (GiftCardLeftAmt == 0) {
                    ResetGiftCard();
                    $("#txtGiftCardNo").val('');
                    swal('Warning!', 'Invalid Gift Card Code.', 'warning', { closeOnClickOutside: false });
                }
                else {
                    //ResetGiftCard();
                    var Gtext = "Gift Card " + GiftCardNo + " applied sucessfully.";
                    swal('Success!', Gtext, 'success', { closeOnClickOutside: false });

                    CloseGiftCardRedeemModal();
                    calc_total();
                    /* }*/
                    /*});*/
                }
            }
            $('#loading').hide();
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


function DeleteGiftCard(e) {

    $(e).closest('tr').remove();
    ResetGiftCard();
    if ($("#tblTransaction tr").length == 0) {
        //$("#tblTransaction").hide();
    }
}

function ResetGiftCard() {
    GiftCardAmt = 0;
    GiftCardNo = '';
    GiftCardLeftAmt = 0;
    GiftCardAppliedStatus = 0;
    TempGiftCardAmt = 0;
    TempGiftCardLeftAmt = 0;
    TempGiftCardUsedAmt = 0;
    $("#DivGiftCard").hide();
    $("#tblTransaction").find('.GiftCard').remove();
    $("#lblGiftCardAmt").text(parseFloat(0).toFixed(2));
    $("#lblGiftCardAmt1").text(CSymbol + parseFloat(0).toFixed(2));
    //calc_total();
}

function PayWithGiftCard(TempGiftCardUsedAmt) {

    var i = 0;
    $("#tblProductDetail .product-addlist").each(function (index, item) {
        if ($(item).find('.SKUId').text() != '0') {
            i++;
        }
    });
    if (i == 0) {
        $('#loading').hide();
        swal("Warning!", "Please add atleast 1 product.", "warning", { closeOnClickOutside: false }).then(function () {
            FocusOnBarCode();
        });
        return;
    }
    else {
        var tltText = 'Gift Card Left Amount is ' + CSymbol + parseFloat(TempGiftCardLeftAmt).toFixed(2);
        swal({
            title: tltText,
            text: "You want to proceed this order?",
            icon: "warning",
            showCancelButton: true,
            closeOnClickOutside: false,
            buttons: {
                cancel: {
                    text: "No",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Yes",
                    value: true,
                    visible: true,
                    className: "",
                    closeModal: true,
                },
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                //printInvoice();
                //FinalPay('Gift Card', TempGiftCardUsedAmt, '0');
                calc_total();
            }
            else {
                swal('', 'Cancelled.', 'warning', { closeOnClickOutside: false }).then(function () {
                    ResetGiftCard();
                    CloseCardTypeModal();
                    FocusOnBarCode();
                });
            }
        });
    }
}

function GiftCardLookUp() {
    $("#txtInvoice").val('');
    $("#txtMobile").val('');
    $("#txtGiftCode").val('');
    $("#txtEmail").val('');
    $("#tblGiftList tbody tr").remove();
    $("#ModalAction").modal("hide");
    $("#GiftCardLookUp").modal("show");
}

function CloseGiftList() {
    $("#GiftCardLookUp").modal("hide");
    $("#tblGiftList").hide();
    $("#GiftEmptyTable").hide();
}

function BindGiftCardSearch(pageIndex) {
    $("#tblGiftList").hide();
    $("#GiftEmptyTable").hide();
    if ($("#txtInvoice").val().trim() == "") {
        if ($("#txtMobile").val().trim() == "") {
            if ($("#txtGiftCode").val().trim() == "") {
                if ($("#txtEmail").val().trim() == "") {
                    toastr.error('Please fill atleast one field!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                    validate = 0;
                    return false;
                }
            }
        }
    }
    if ($("#txtMobile").val().trim() != "" && $("#txtMobile").val().length < 10) {
        toastr.error('Please fill valid Mobile No.!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtMobile").addClass('border-warning');
        validate = 0;
        return false;
    }
    var regEmail = new RegExp(/^([\w+-.%]+@[\w-.]+\.[A-Za-z]{2,4},?)+$/);
    if (!regEmail.test($("#txtEmail").val().replace(" ", "").trim()) && $("#txtEmail").val().trim() != "") {
        toastr.error('Please fill valid Email ID!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEmail").addClass('border-warning');
        validate = 0;
        return false;
    }
    data = {
        InvoiceAutoId: $("#txtInvoice").val().trim() || 0,
        Mobile: $("#txtMobile").val().trim(),
        GiftCode: $("#txtGiftCode").val().trim(),
        Email: $("#txtEmail").val().trim(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSizeGift").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/GiftCardReport.aspx/BindGiftCardSearch",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {

                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table1");
                var pager = xml.find("Table");
                $("#tblGiftList tbody tr").remove();
                $("#tblGiftList").hide();
                if (UserList.length > 0) {
                    $("#tblGiftList").show();
                    if (pager.length > 0) {
                        $("#GiftListSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSizeGift').show();
                    }
                    else {
                        $('#ddlPageSizeGift').hide();
                    }
                    $("#GiftListSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#GiftEmptyTable").hide();

                    var row = $("#tblGiftList thead tr:first-child").clone(true);
                    $.each(UserList, function () {
                        $(".AutoId", row).html($(this).find("AutoId").text());
                        $(".GiftCardCode", row).html($(this).find("GiftCardCode").text());
                        $(".TotalAmt", row).html($(this).find("TotalAmt").text()).css('text-align', 'right');
                        $(".LeftAmt", row).html($(this).find("LeftAmt").text()).css('text-align', 'right');
                        $(".GiftCardPurchaseInvoice", row).html($(this).find("GiftCardPurchaseInvoice").text());
                        $(".SoldDate", row).html($(this).find("SoldDate").text());
                        $(".Customer", row).html($(this).find("Customer").text());
                        $(".Mobile", row).html($(this).find("MobileNo").text());
                        $(".Email", row).html($(this).find("EmailId").text());
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        $(".SoldBy", row).html($(this).find("SoldBy").text());
                        if (parseFloat($(this).find("LeftAmt").text()) == parseFloat($(this).find("TotalAmt").text())) {
                            $(".Status", row).html('Sold');
                        }
                        else if (parseFloat($(this).find("LeftAmt").text()) == parseFloat(0)) {
                            $(".Status", row).html('Closed');
                        }
                        else if (parseFloat($(this).find("LeftAmt").text()) > parseFloat(0) || parseFloat($(this).find("LeftAmt").text()) < parseFloat($(this).find("TotalAmt").text())) {
                            $(".Status", row).html('Partial');
                        }
                        else {
                            $(".Status", row).html(' ');
                        }


                        $("#tblGiftList").append(row);
                        row = $("#tblGiftList tbody tr:last-child").clone(true);
                    });
                    $("#tblGiftList").show();
                }
                else {
                    $("#GiftEmptyTable").show();
                    $("#tblGiftList").show();
                    $("#tblGiftList").hide();
                    $("#GiftListSortBy").hide();
                    $("#ddlPageSizeGift").hide();
                }
                //var pager = xml.find("Table");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSizeGift').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').hide();
                }
            }
            $('#loading').hide();
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

var RoyaltyAmount = 0, UsedRoyaltyPoints = 0;
function ValidateRedeemHappyPoints() {
    debugger
    if ($("#ddlCustomer").val().trim() == 'Walk In') {
        swal('Warning!', 'Please select or create the Customer first.', 'warning', { closeOnClickOutside: false });
    }
    else if (parseInt(($("#hdnRoyaltyPoints").val())) == 0 || isNaN(parseInt(($("#hdnRoyaltyPoints").val())))) {
        swal('Warning!', 'No Reward Points To Redeem.', 'warning', { closeOnClickOutside: false });
    }
    else {
        GetRoyaltyRedeemCriteria();
    }
}

function GetRoyaltyRedeemCriteria() {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/GetRoyaltyRedeemCriteria",
        data: "",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                //swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
                swal('Warning!', 'Not Applicable.', 'warning', { closeOnClickOutside: false });
            }
            //else if (response.d == 'false') {
            //    swal('Warning!', 'Not Applicable.', 'warning', { closeOnClickOutside: false });
            //}
            else if (response.d == 'Session') {
                swal('Error!', 'Session Expired.', 'error', { closeOnClickOutside: false }).then(function () {
                    window.location.href = 'Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var RoyaltyRedeemDetails = xml.find("Table");
                var MinOrderAmtToReedem = $(RoyaltyRedeemDetails).find('MinOrderAmt').text();
                var NeedToReedemPoint = 0, AvailablePoint = 0;
                if (!isNaN(parseFloat(MinOrderAmtToReedem)) && (parseFloat(MinOrderAmtToReedem) <= (parseFloat($('#PayGOrdertotal').val()) - parseFloat($("#lblLottery").text().replace(CSymbol, ''))))) {
                    var AmtPerRoyaltyPoint = 0;
                    debugger;
                    AmtPerRoyaltyPoint = $(RoyaltyRedeemDetails).find("AmtPerRoyaltyPoint").text();
                    $("#txtAmtPerPoint").val(parseFloat(AmtPerRoyaltyPoint).toFixed(2));
                    AvailablePoint = parseInt($('#txtAvlHappyPoints').val().trim());
                    var tempRewardAmt = 0;
                    tempRewardAmt = $("#tblTransaction tr.HappPointsPayment").find('.PaymentAmt').text().replace(CSymbol, '');
                    if (tempRewardAmt == '') {
                        tempRewardAmt = 0;
                    }
                    if (parseFloat(AmtPerRoyaltyPoint) != 0 && !isNaN(parseFloat(AmtPerRoyaltyPoint))) {
                        NeedToReedemPoint = ((parseFloat($('#PayGtotal').val().trim()) - parseFloat($("#lblLottery").text().replace(CSymbol, ''))) + parseFloat(tempRewardAmt)) / (parseFloat(AmtPerRoyaltyPoint));
                    }
                    else {
                        NeedToReedemPoint = 0;
                    }
                    if (NeedToReedemPoint >= AvailablePoint) {
                        OpenRedeemHappyPointsModal(AvailablePoint);
                    }
                    else {
                        if (parseFloat(NeedToReedemPoint) == parseInt(NeedToReedemPoint)) {
                            //NeedToReedemPoint = NeedToReedemPoint;
                        }
                        else {
                            NeedToReedemPoint = parseInt(NeedToReedemPoint) + 1;
                        }
                        OpenRedeemHappyPointsModal(NeedToReedemPoint);
                    }
                }
                else {
                    swal('Warning!', 'Order amount is less than minimum amount to reedem reward points', 'warning', { closeOnClickOutside: false }).then(function () {
                        CloseHappyPointRedeemModal();
                    });
                }
            }
            $('#loading').hide();
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

function OpenRedeemHappyPointsModal(ReedemPoint) {
    $("#txtRedeemHappyPoints").val(isNaN(ReedemPoint) ? 0 : ReedemPoint);
    $("#hdnMaxRedeemHappyPoints").val(isNaN(ReedemPoint) ? 0 : ReedemPoint);
    $("#HappypointsRedeemModal").modal('show');
}

function RedeemHappyPoints() {
    var validate = 1;

    if ($("#txtAvlHappyPoints").val().trim() == "" || parseInt($("#txtAvlHappyPoints").val().trim()) == 0) {

        toastr.error('No Reward Points TO Redeem.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else if ($("#txtRedeemHappyPoints").val().trim() == "" || parseInt($("#txtRedeemHappyPoints").val().trim()) == 0) {

        toastr.error('Please fill Points To Redeem.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else if (parseInt($("#hdnMaxRedeemHappyPoints").val().trim()) < parseInt($("#txtRedeemHappyPoints").val().trim())) {

        toastr.error('Entered Reward points have exceeded than needed points.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else if (parseInt($("#txtAvlHappyPoints").val().trim()) < parseInt($("#txtRedeemHappyPoints").val().trim())) {

        toastr.error('Rewards points can not be greater than Available points.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {

        UsedRoyaltyPoints = parseInt($("#txtRedeemHappyPoints").val().trim());
        RoyaltyAmount = parseFloat($("#txtAmtPerPoint").val().trim()) * parseInt($("#txtRedeemHappyPoints").val().trim());
        $("#HappypointsRedeemModal").modal('hide');
        calc_total();
    }
}

function CloseHappyPointRedeemModal() {

    $("#txtRedeemHappyPoints").val('0');
    $("#txtAmtPerPoint").val('0');
    $("#HappypointsRedeemModal").modal('hide');
}