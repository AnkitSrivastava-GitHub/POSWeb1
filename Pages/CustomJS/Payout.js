$(document).ready(function () {
    SetCurrency();
    var now = new Date();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });   

    $('#txtTime').pickatime({
        interval: 5
    });
    $("#txtTime").val(formatAMPM(new Date));   
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('.date').val(today);
    $('#txtDate').val(today);

    $('#txtDate').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        min: [month, today, now.getFullYear()]
    });

    BindPayoutList(1);
    BindDropDowns();
    bindPayoutType();
});

var CSymbol = "";

function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/CurrencySymbol",
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

function Pagevalue(e) {
    BindPayoutList(parseInt($(e).attr("page")));
};

function BindDropDowns() {
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/bindTerminal",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Terminal Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlTerminal option").remove();
                $("#ddlSTerminal option").remove();
                $("#ddlTerminal").append('<option value="0">Select Terminal</option>');
                $("#ddlSTerminal").append('<option value="0">All Terminal</option>');
                $.each(StateList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                    $("#ddlSTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlTerminal").select2().next().css('width', '403px');
                $("#ddlSTerminal").select2();
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

function BindDDLExpenseVendor() {
    $('#ddlVendor').val('0').change();
    $('#ddlExpense').val('0').change();
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
    if ($("#ddlPayoutType1").val() == 1) {
        bindVendor();
        $(".Expense1").hide();
        $(".ExVe").hide();
        $(".Vendor1").show();
    }
    else if ($("#ddlPayoutType1").val() == 2) {
        bindExpenses();
        $(".Vendor1").hide();
        $(".ExVe").hide();
        $(".Expense1").show();
    }
    else {
        $(".ExVe").show();
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
                $("#ddlVendor").select2().next().css('width', '403px');
                $("#ddlVendor1").select2().next().css('width', '288px');
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
                $("#ddlExpense").select2().next().css('width', '403px');
                $("#ddlExpense1").select2().next().css('width', '288px');
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
                $("#ddlPayoutType").select2().next().css('width', '403px');
                $("#ddlPayoutType1").select2().next().css('width', '288px');
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
function InsertPayout() {
    debugger;
    /* $('#loading').show();*/
    var validate = 1; var Vendor = 0, Expense = 0;
    if ($("#ddlTerminal").val().trim() == '0') {
        toastr.error('Terminal Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
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
    if ($("#txtAmount").val().trim() == '.') {
        $('#loading').hide();
        toastr.error('Please enter valid Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtAmount").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTransactionId").val().trim() == '' && $("#ddlPayoutmode").val().trim() == '2') {
        $('#loading').hide();
        toastr.error('Transaction ID Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
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

    if ($("#ddlPayoutmode").val() == "1") {
        $("#txtTransactionId").val('');
    }
    if ($('#ddlPayoutmode option:selected').text() != 'Online') {
        $("#txtTransactionId").val("");
    }
    if (validate == 1) {
        debugger;
        data = {
            Expense: Expense || '0',
            Vendor: Vendor,
            Terminal: $("#ddlTerminal").val(),
            PayoutType: $("#ddlPayoutType").val(),
            PayoutDate: $("#txtDate").val(),
            PayoutTime: $("#txtTime").val(),
            PayTo: $("#txtPayTo").val().trim(),
            Remark: $("#txtRemark").val().trim(),
            Amount: $("#txtAmount").val(),
            PayoutMode: $("#ddlPayoutmode").val(),
            TransactionId: $("#txtTransactionId").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/PayoutMaster.aspx/InsertPayout",
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
                    swal("Success!", "Payout added successfully.", "success", { closeOnClickOutside: false });
                    BindPayoutList(1);
                    Reset();
                    CloseModel();
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
function OpenOnline() {
    debugger;
    if ($('#ddlPayoutmode option:selected').text() == 'Online') {
        $('#ddlTransactionId').show();
    }
    else {
        $('#ddlTransactionId').hide();

    }
}
function BindPayoutList(pageIndex) {
    debugger;
    if ($("#txtSFromDate").val().trim() != '' && $("#txtSToDate").val().trim() != '' && (Date.parse($("#txtSFromDate").val()) > Date.parse($("#txtSToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSFromDate").val().trim() != '' && $("#txtSToDate").val().trim() == '') {
        //$('#loading').hide();
        toastr.error('Please fill both From Date & To Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSFromDate").val().trim() == '' && $("#txtSToDate").val().trim() != '') {
        //$('#loading').hide();
        toastr.error('Please fill both From Date & To Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtSAmount").val().trim()) == 0) {
        toastr.error('Please fill valid Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    $('#loading').show();
    debugger;
    data = {
        PayoutType: $("#ddlPayoutType1").val(),
        Expense: $("#ddlExpense1").val(),
        Vendor: $("#ddlVendor1").val(),
        TerminalId: $("#ddlSTerminal").val().trim() || 0,
        PayTo: $("#txtSPayTo").val().trim(),
        Amount: $("#txtSAmount").val(),
        FromDate: $("#txtSFromDate").val().trim(),
        ToDate: $("#txtSToDate").val().trim(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/BindPayoutList",
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
                debugger;
                if (Total.length > 0) {

                    $("#lblTotal").text(parseFloat($(Total).find("TotalAmount").text()).toFixed(2));

                }
                var status = "";
                if (PayoutList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#EmptyTable").hide();
                    $("#tblPayoutList tbody tr").remove();
                    var row = $("#tblPayoutList thead tr:first-child").clone(true);
                    $.each(PayoutList, function () {
                        debugger;
                        status = '';
                        $(".PayoutAutoId", row).html($(this).find("AutoId").text());
                        $(".CompanyName", row).html($(this).find("CompanyName").text());
                        $(".PayTo", row).html($(this).find("PayTo").text());
                        $(".Amount", row).html(parseFloat($(this).find("Amount").text()).toFixed(2));
                        $(".Terminal", row).html($(this).find("TerminalName").text());
                        $(".PayoutType", row).html($(this).find("PayoutType").text());
                        $(".Expenses", row).html($(this).find("ExpenseName").text());
                        $(".Vendors", row).html($(this).find("VendorName").text());
                        $(".PayoutDate", row).html($(this).find("PayoutDate").text());
                        $(".PayoutTime", row).html($(this).find("PayoutTime").text());
                        $(".Remark", row).html($(this).find("Remark").text());
                        $(".PaymentMode", row).html($(this).find("PayoutMode").text());
                        $(".createdby", row).html($(this).find("CreatedBy").text() + "</br>" + $(this).find("CreatedDate").text());
                        $(".UserType", row).html($(this).find("UserType").text());
                        $(".Action", row).html("<a id='btnDeletePayout' onclick='isDeletePayout(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editPayout(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblPayoutList").append(row);
                        row = $("#tblPayoutList tbody tr:last-child").clone(true);
                    });
                    $("#tblPayoutList").show();
                }

                else {
                    $("#EmptyTable").show();
                    $("#tblPayoutList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSize').val() == '0') {
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
    $('#loading').show();
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
                OpenModel();
                $("#hdnPayoutId").val($(PayoutDetail).find('AutoId').text());
                $("#ddlTerminal").val($(PayoutDetail).find('Terminal').text()).change();
                $("#txtPayTo").val($(PayoutDetail).find('PayTo').text());
                $("#txtAmount").val(parseFloat($(PayoutDetail).find('Amount').text()).toFixed(2));
                $("#ddlPayoutmode").val($(PayoutDetail).find('PayoutMode').text()).change();
                $("#ddlPayoutType").val($(PayoutDetail).find('PayoutType').text()).change();
                $("#ddlVendor").val($(PayoutDetail).find('Vendor').text()).change();
                $("#ddlExpense").val($(PayoutDetail).find('Expense').text()).change();
                $("#txtTransactionId").val($(PayoutDetail).find('TransactionId').text());
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
    debugger;
    $('#loading').show();
    var validate = 1; var Vendor = 0, Expense = 0;
    if ($("#ddlTerminal").val().trim() == '0') {
        toastr.error('Terminal Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlPayoutType").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Payout Type Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlPayoutType").val() == '1') {
        if ($("#ddlVendor").val().trim() == '0') {
            $('#loading').hide();
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
            $('#loading').hide();
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
    if (parseInt($("#txtAmount").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTransactionId").val().trim() == '' && $("#ddlPayoutmode").val().trim() == '2') {
        $('#loading').hide();
        toastr.error('Transaction ID Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
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

    if ($("#ddlPayoutmode").val == "1") {
        $("#txtTransactionId").val('');
    }
    if ($('#ddlPayoutmode option:selected').text() != 'Online') {
        $("#txtTransactionId").val("");
    }
    if (validate == 1) {
        data = {
            Expense: Expense || '0',
            Vendor: Vendor,
            PayoutType: $("#ddlPayoutType").val(),
            PayoutDate: $("#txtDate").val(),
            PayoutTime: $("#txtTime").val(),
            Terminal: $("#ddlTerminal").val(),
            PayTo: $("#txtPayTo").val().trim(),
            Remark: $("#txtRemark").val().trim(),
            Amount: $("#txtAmount").val(),
            PayoutMode: $("#ddlPayoutmode").val(),
            TransactionId: $("#txtTransactionId").val(),
            PayoutAutoId: $("#hdnPayoutId").val()

        }
        $.ajax({
            type: "POST",
            url: "/Pages/PayoutMaster.aspx/UpdatePayout",
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
                    BindPayoutList(1);
                    Reset();
                    CloseModel();
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
        debugger;
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
                        Reset();
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
function Reset() {
    $(".Expense").hide();
    $(".Vendor").hide();
    $("#txtRemark").val('');
    $("#txtPayTo").val('');
    $("#hdnPayoutId").val('');
    $("#txtAmount").val('');
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('.date').val(today);
    $("#txtTime").val(formatAMPM(new Date));
    //$("#ddlPayoutmode").val(1).change();
    $("#ddlPayoutType").val('0').change();
    $("#txtTransactionId").val('');
    $("#btnSave").show();
    $("#btnUpdate").hide();
}

function OpenModel() {
    Reset();
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('.date').val(today);
    $("#txtTime").val(formatAMPM(new Date));
    $("#ModalTerminal").modal("show");
}

function CloseModel() {
    $("#ModalTerminal").modal("hide");
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