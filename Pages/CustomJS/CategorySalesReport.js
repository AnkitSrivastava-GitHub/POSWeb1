
$(document).ready(function () {
    debugger;
    SetCurrency();
    BindTerminalList();
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        clear: false,
        backspace: false,
        min: [2018, 1, 1],
        max: [month, today, now.getFullYear()],
    });

    $(".date").val(today);
    $("#txtAllReportDate").on('keyup', function (event) {
        const key = event.key; // const {key} = event; ES6+
        if (key === "Backspace" || key === "Delete") {
            $("#txtAllReportDate").val(filledDate);
            return false;
        }
    });
    BindCategorySalesReport(1);
    BindTicketSalesReport(1);
    BindPayoutReport();
    BindTransDetailsReport();
});
var CSymbol = "",filledDate='';

function FilledDate() {
    if ($("#txtAllReportDate").val() != '') {
        filledDate = $("#txtAllReportDate").val();
    }
}
function SetCurrency() {
    debugger;
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
function getShiftList() {
    data = {
        ReportDate: $("#txtAllReportDate").val().trim(),
        TerminalId: $("#ddlAllReportTerminal").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/getShiftList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Shift Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ShiftList = xml.find("Table");
                $("#ddlAllShift option").remove();
                if (ShiftList.length > 0) {
                    $("#ddlAllShift").append('<option value="0">All Shift</option>');
                    $.each(ShiftList, function () {
                        $("#ddlAllShift").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("shiftName").text()));
                    });
                }
                else {
                    $("#ddlAllShift").append('<option value="0">All Shift</option>');
                }
                $("#ddlAllShift").select2();
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

function BindTerminalList() {
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/BindTerminalList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Terminal Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var TerminalList = xml.find("Table");
                //$("#ddlCategorySalesTerminal option").remove();
                //$("#ddlCategorySalesTerminal").append('<option value="0">All Terminal</option>');
                //$.each(TerminalList, function () {
                //    $("#ddlCategorySalesTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                //});
                //$("#ddlCategorySalesTerminal").select2();

                //$("#ddlTicketSaleTerminal option").remove();
                //$("#ddlTicketSaleTerminal").append('<option value="0">All Terminal</option>');
                //$.each(TerminalList, function () {
                //    $("#ddlTicketSaleTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                //});
                //$("#ddlTicketSaleTerminal").select2();

                //$("#ddlLottoPayoutTerminal option").remove();
                //$("#ddlLottoPayoutTerminal").append('<option value="0">All Terminal</option>');
                //$.each(TerminalList, function () {
                //    $("#ddlLottoPayoutTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                //});
                //$("#ddlLottoPayoutTerminal").select2();

                //$("#ddlPaymentDetailsTerminal option").remove();
                //$("#ddlPaymentDetailsTerminal").append('<option value="0">All Terminal</option>');
                //$.each(TerminalList, function () {
                //    $("#ddlPaymentDetailsTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                //});
                //$("#ddlPaymentDetailsTerminal").select2();

                $("#ddlAllReportTerminal option").remove();
                $("#ddlAllReportTerminal").append('<option value="0">All Terminal</option>');
                $.each(TerminalList, function () {
                    $("#ddlAllReportTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlAllReportTerminal").select2();
                $("#ddlAllReportTerminal").change().select2();
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
    debugger;
    if ($(e).parent().attr('id') == 'CategorySalePager') {
        BindCategorySalesReport(parseInt($(e).attr("page")));
    }
    else if ($(e).parent().attr('id') == 'TicketSalePager') {
        BindTicketSaleReport(parseInt($(e).attr("page")));
    }
};

function SearchAllReports(pageIndex) {
    BindCategorySalesReport(pageIndex);
    BindTicketSalesReport(pageIndex);
    BindPayoutReport();
    BindTransDetailsReport();
}

function BindCategorySalesReport(pageIndex) {
    $('#loading').show();
    data = {
        ReportDate: $("#txtAllReportDate").val().trim(),
        TerminalId: $("#ddlAllReportTerminal").val(),
        ShiftId: $("#ddlAllShift").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlCategorySalePageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/BindCategorySalesReport",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CategorySalesList = xml.find("Table1");
                var pager = xml.find("Table");
                var CategorySalesTotal = xml.find("Table2");
                var TotalCashTrns = xml.find("Table3");
                var TotalPayOut = xml.find("Table4");
                var OpeningBalance = xml.find("Table5");
                var safeCashAmt = xml.find("Table6");
                var CurrentCashAmt = xml.find("Table7");
                debugger;
                $("#tblCurrentCashList tbody tr").remove();
                var TempHtml = '';
                TempHtml += '<tr>';
                TempHtml += '<td class="Openbal" style="white-space: nowrap; text-align: center;">' + $(OpeningBalance).find('OpeningBalance').text() + '</td>';
                TempHtml += '<td class="CashTotalTrs" style="white-space: nowrap; text-align: center;">' + $(TotalCashTrns).find('TotalCashTrns').text() + '</td>';
                TempHtml += '<td class="PayoutInCash" style="white-space: nowrap; width: 100px; text-align: right;">' + $(TotalPayOut).find('TotalPayOut').text() + '</td>';
                TempHtml += '<td class="SafeDepositeCash" style="white-space: nowrap; width: 100px; text-align: right;">' + $(safeCashAmt).find('safeCashAmt').text() + '</td>';
                TempHtml += '</tr>';
                $("#tblCurrentCashList").append(TempHtml);
                if (parseFloat($(CurrentCashAmt).find('CurrentCashAmt').text()) >= 0) {
                    $('#spnCurrencySymbol').text(CSymbol);
                    $('#CurrentCash').text($(CurrentCashAmt).find('CurrentCashAmt').text());
                }
                else {
                    var tempAmt = parseFloat($(CurrentCashAmt).find('CurrentCashAmt').text()) * (-1);
                    $('#spnCurrencySymbol').text('-' + CSymbol);
                    $('#CurrentCash').text(parseFloat(tempAmt).toFixed(2));
                }
                if (CategorySalesList.length > 0) {
                    $("#spCategorySaleSortBy").show();
                    $("#ddlCategorySalePageSize").show();
                    $("#CategorySaleEmptyTable").hide();
                    $("#tblCategorySalesList tbody tr").remove();
                    var row = $("#tblCategorySalesList thead tr:first-child").clone(true);
                    $.each(CategorySalesList, function () {
                        debugger;
                        if ($(this).find("TotalCateSaleAmt").text() != '' && parseFloat($(this).find("TotalCateSaleAmt").text()) != 0) {
                            debugger;
                            $(".CategoryAutoId", row).html($(this).find("CategoryId").text());
                            $(".CategoryName", row).html($(this).find("CategoryName").text());
                            $(".CategorySaleAmount", row).html($(this).find("TotalCateSaleAmt").text());
                            //$(".Action", row).html("<a id='btnDeleteAge' onclick='isDeleteAge(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editAge(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                            $("#tblCategorySalesList").append(row);
                            row = $("#tblCategorySalesList tbody tr:last-child").clone(true);
                        }
                    });
                    $("#tblCategorySalesList").show();

                    if (CategorySalesTotal.length > 0) {
                        $('#CatSalestotal').text($(CategorySalesTotal).find('TotalCateSaleAmt').text());
                    }
                }
                else {
                    debugger;
                    $("#CategorySaleEmptyTable").show();
                    $("#tblCategorySalesList").hide();
                    $("#spCategorySaleSortBy").hide();
                    $("#ddlCategorySalePageSize").hide();
                }
                debugger;
                $(".CategorySalePager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if (($(pager).find('RecordCount').text()) <= 10) {
                    $('#CategorySaleDivPager').hide();
                }
                else if ($('#ddlCategorySalePageSize').val() == '0') {
                    $('#CategorySalePager').hide();
                }
                else {
                    $('#CategorySaleDivPager').show();
                    $('#CategorySalePager').show();
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

function BindTicketSalesReport(pageIndex) {
    $('#loading').show();
    data = {
        ReportDate: $("#txtAllReportDate").val().trim(),
        TerminalId: $("#ddlAllReportTerminal").val(),
        ShiftId: $("#ddlAllShift").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlTicketSalePageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/BindTicketSalesReport",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var LotterySalesList = xml.find("Table1");
                var pager = xml.find("Table");
                var TicketSalesTotal = xml.find("Table2");
                var LottoPayoutTotal = xml.find("Table3");
                var AllowlotterySale = xml.find("Table4");
                if ($(AllowlotterySale).find('AllowLotterySale').text() == '1') {
                    if (LotterySalesList.length > 0 || LottoPayoutTotal.length > 0) {
                        $("#spTicketSaleSortBy").show();
                        $("#ddlTicketSalePageSize").show();
                        $("#TicketSaleEmptyTable").hide();
                        $("#tblTicketSaleList tbody tr").remove();
                        var row = $("#tblTicketSaleList thead tr:first-child").clone(true);
                        $.each(LotterySalesList, function () {
                            /* $(".TicketAutoId", row).html($(this).find("AutoId").text());*/
                            $(".TicketsName", row).html($(this).find("ProductName").text());
                            $(".TicketSaleAmount", row).html($(this).find("TotalLotterySale").text());
                            //$(".Action", row).html("<a id='btnDeleteAge' onclick='isDeleteAge(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editAge(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                            $("#tblTicketSaleList").append(row);
                            row = $("#tblTicketSaleList tbody tr:last-child").clone(true);
                        });
                        $("#tblTicketSaleList").show();
                        if (TicketSalesTotal.length > 0) {
                            $('#TicketSalestotal').text($(TicketSalesTotal).find('TotalLotterySale').text());
                        }
                        else {
                            $('#TicketSalestotal').text('0.00');
                        }
                        if (LottoPayoutTotal.length > 0) {
                            $('#LottoPayOut').text(parseFloat($(LottoPayoutTotal).find('TotalLottoPayout').text()).toFixed(2));
                        }
                        else {
                            $('#LottoPayOut').text('0.00');
                        }
                    }
                    else {
                        $("#TicketSaleEmptyTable").show();
                        $("#tblTicketSaleList").hide();
                        $("#spTicketSaleSortBy").hide();
                        $("#ddlTicketSalePageSize").hide();
                    }
                    $(".TicketSalePager").ASPSnippets_Pager({
                        ActiveCssClass: "current",
                        PagerCssClass: "pager",
                        PageIndex: parseInt(pager.find("PageIndex").text()),
                        PageSize: parseInt(pager.find("PageSize").text()),
                        RecordCount: parseInt(pager.find("RecordCount").text())
                    });
                    if (($(pager).find('RecordCount').text()) <= 10) {
                        $('#DivTicketSalePager').hide();
                    }
                    else if ($('#ddlCategorySalePageSize').val() == '0') {
                        $('#TicketSalePager').hide();
                    }
                    else {
                        $('#DivTicketSalePager').show();
                        $('#TicketSalePager').show();
                    }
                    $('#divLottery').show();
                }
                else {
                    $('#divLottery').hide();
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

function BindPayoutReport() {
    $('#loading').show();
    data = {
        ReportDate: $("#txtAllReportDate").val().trim(),
        TerminalId: $("#ddlAllReportTerminal").val(),
        ShiftId: $("#ddlAllShift").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/BindPayoutReport",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        async: false,
        dataType: "json",
        contentType: "application/json;charset=utf-8",
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
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var PayoutList = xml.find("Table");
                var PayoutTotal = xml.find("Table1");
                if (PayoutList.length > 0) {
                    $("#LottoPayoutEmptyTable").hide();
                    $("#tblLottoPayoutList tbody tr").remove();
                    var row = $("#tblLottoPayoutList thead tr:first-child").clone(true);
                    $.each(PayoutList, function () {
                        $(".LottoPayoutName", row).html($(this).find("ProductName").text());
                        $(".LottoPayoutAmount", row).html(parseFloat($(this).find("TotalLottoPayout").text()).toFixed(2));
                        $("#tblLottoPayoutList").append(row);
                        row = $("#tblLottoPayoutList tbody tr:last-child").clone(true);
                    });
                    $("#tblLottoPayoutList").show();
                    if (PayoutTotal.length > 0) {
                        $('#PayoutTotal').text($(PayoutTotal).find('PayoutTotal').text());
                    }
                }
                else {
                    $("#LottoPayoutEmptyTable").show();
                    $("#tblLottoPayoutList").hide();
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

function BindTransDetailsReport() {
    $('#loading').show();
    data = {
        ReportDate: $("#txtAllReportDate").val().trim(),
        TerminalId: $("#ddlAllReportTerminal").val(),
        ShiftId: $("#ddlAllShift").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/BindTransDetailsReport",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var TransDetailsList = xml.find("Table");
                var TransDetailsTotal = xml.find("Table1");

                if (TransDetailsList.length > 0) {
                    $("#PaymentDetailsEmptyTable").hide();
                    var i = 0;
                    $("#tblPaymentDetailsList tbody tr").remove();
                    var row = $("#tblPaymentDetailsList thead tr:first-child").clone(true);
                    $.each(TransDetailsList, function () {
                        debugger;
                        if (parseFloat($(this).find("PaymentMethodwiseTotalAmount").text()) != 0) {
                            $(".PaymentMethods", row).html($(this).find("PaymentMode").text());
                            $(".TransTotal", row).html($(this).find("PaymentMethodwiseTotalAmount").text());
                            $("#tblPaymentDetailsList").append(row);
                            row = $("#tblPaymentDetailsList tbody tr:last-child").clone(true);
                            i++;
                        }
                    });
                    $("#tblPaymentDetailsList").show();
                    if (TransDetailsTotal.length > 0) {
                        $('#Salestotal').text($(TransDetailsTotal).find('TrasactionGrandTotal').text());
                    }
                    if (i == 0) {
                        debugger;
                        $("#PaymentDetailsEmptyTable").show();
                        $("#tblPaymentDetailsList").hide();
                    }
                }
                else {

                    debugger;
                    $("#PaymentDetailsEmptyTable").show();
                    $("#tblPaymentDetailsList").hide();


                    //$("#spTicketSaleSortBy").hide();
                    //$("#ddlTicketSalePageSize").hide();
                }
                //$(".TicketSalePager").ASPSnippets_Pager({
                //    ActiveCssClass: "current",
                //    PagerCssClass: "pager",
                //    PageIndex: parseInt(pager.find("PageIndex").text()),
                //    PageSize: parseInt(pager.find("PageSize").text()),
                //    RecordCount: parseInt(pager.find("RecordCount").text())
                //});
                //if (($(pager).find('RecordCount').text()) <= 10) {
                //    $('#DivTicketSalePager').hide();
                //}
                //else if ($('#ddlCategorySalePageSize').val() == '0') {
                //    $('#TicketSalePager').hide();
                //}
                //else {
                //    $('#DivTicketSalePager').show();
                //    $('#TicketSalePager').show();
                //}
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