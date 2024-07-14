$(document).ready(function () {
    SetCurrency();
    var now = new Date();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        minDate: 0,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('#txtFromDate').val(today);
    $('#txtToDate').val(today);
    BindExpensesTerminal();
    BindExpenseReport(1);
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/CouponMaster.aspx/CurrencySymbol",
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

function BindExpensesTerminal() {
    $.ajax({
        type: "POST",
        url: "/Pages/ExpenseMaster.aspx/BindExpenseTerminal",
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
                var ExpenseList = xml.find("Table");
                var TerminalList = xml.find("Table1");

                $("#ddlExpense option").remove();
                $("#ddlExpense").append('<option value="0">All Expense</option>');
                $.each(ExpenseList, function () {
                    $("#ddlExpense").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("ExpenseName").text()));
                });
                $("#ddlExpense").select2().next();

                $("#ddlTerminal option").remove();
                $("#ddlTerminal").append('<option value="0">All Terminal</option>');
                $.each(TerminalList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlTerminal").select2().next();
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
function Pagevalue(e) {
    BindExpenseReport(parseInt($(e).attr("page")));
};
function BindExpenseReport(pageIndex) {
    debugger
    $('#loading').show();
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() == '' || $("#txtFromDate").val().trim() == '' && $("#txtToDate").val().trim() != '') {
        $('#loading').hide();
        toastr.error('Both date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    data = {
        FormDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        ExpenseId: $("#ddlExpense").val(),
        TerminalId: $("#ddlTerminal").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ExpenseMaster.aspx/BindExpenseReport",
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
                var status = "", Total = 0;
                if (ModuleList.length > 0) {
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
                    $("#tblExpenseList tbody tr").remove();
                    var row = $("#tblExpenseList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".ExpenseAutoId", row).html($(this).find("AutoId").text());
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        $(".Expense", row).html($(this).find("Expense").text());
                        $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                        $(".PayTo", row).html($(this).find("PayTo").text());
                        $(".PayoutMode", row).html($(this).find("PayoutMode").text());
                        $(".Remark", row).html($(this).find("Remark").text());
                        $(".PayoutDateTime", row).html($(this).find("PayoutDate").text() + '  ' + $(this).find("PayoutTime").text());
                        $(".CreationDetail", row).html($(this).find("CreationDetail").text());
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        Total = Total + parseFloat($(this).find("Amount").text());                        
                        $("#tblExpenseList").append(row);
                        row = $("#tblExpenseList tbody tr:last-child").clone(true);
                    });
                    $("#tblExpenseList").show();
                    $("#tblExpenseList tfoot tr").remove();
                    var html2 = '<tfoot>' +
                        '<tr class="tfoot">' +
                        '<td class="lblTotal" colspan="3" style="white-space: nowrap; text-align: right"><strong>Total</strong></td>' +
                        '<td class="tdTotal" colspan="" style="white-space: nowrap; text-align: right"><span id="Total"><strong>' + CSymbol + '' + parseFloat(Total).toFixed(2) + '</strong></span></td>' +
                        '</tr>' +
                        '</tfoot >';
                    $("#tblExpenseList").append(html2);
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblExpenseList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                //var pager = xml.find("Table");
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