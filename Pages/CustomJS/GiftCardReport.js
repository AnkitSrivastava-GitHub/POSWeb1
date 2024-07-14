$(document).ready(function () {
    SetCurrency();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
    });
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });
    BindGiftCard(1);
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/GiftCardReport.aspx/CurrencySymbol",
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
    BindGiftCard(parseInt($(e).attr("page")));
};

function BindGiftCard(pageIndex) {
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() == '' || $("#txtFromDate").val().trim() == '' && $("#txtToDate").val().trim() != '') {
        //$('#loading').hide();
        toastr.error('Both date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#loading').show();
    data = {
        InvoiceAutoId: $("#txtInvoice").val().trim() || 0,
        Mobile: $("#txtMobile").val().trim(),
        CustomerName: $("#txtCustomer").val().trim(),
        FromDate: $("#txtFromDate").val().trim(),
        ToDate: $("#txtToDate").val().trim(),
        Email: $("#txtEmail").val().trim(), 
        Terminal: $("#ddlTerminal").val() || 0,
        Status: $("#ddlStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/GiftCardReport.aspx/BindGiftCard",
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
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table1");
                var pager = xml.find("Table");
                if (UserList.length > 0) {
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
                    $("#tblGiftList tbody tr").remove();
                    var row = $("#tblGiftList thead tr:first-child").clone(true);
                    $.each(UserList, function () {
                        debugger;
                        status = '';
                        $(".AutoId", row).html($(this).find("AutoId").text());
                        $(".GiftCardCode", row).html($(this).find("GiftCardCode").text());
                        $(".TotalAmt", row).html($(this).find("TotalAmt").text()).css('text-align','right');
                        $(".LeftAmt", row).html($(this).find("LeftAmt").text()).css('text-align', 'right');
                        $(".GiftCardPurchaseInvoice", row).html($(this).find("GiftCardPurchaseInvoice").text());
                        $(".SoldDate", row).html($(this).find("SoldDate").text());
                        $(".Customers", row).html($(this).find("Customer").text());
                        $(".Mobile", row).html($(this).find("MobileNo").text());
                        $(".Email", row).html($(this).find("EmailId").text());
                        $(".CompanyName", row).html($(this).find("CompanyName").text()); 
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        $(".SoldBy", row).html($(this).find("SoldBy").text());
                        if (parseFloat($(this).find("LeftAmt").text()) == parseFloat($(this).find("TotalAmt").text())) {
                            $(".Status", row).html('Sold');
                        }
                        else if (parseFloat($(this).find("LeftAmt").text()) == parseFloat(0)) {
                            $(".Status", row).html('Closed');
                        }
                        else if (parseFloat($(this).find("LeftAmt").text()) > parseFloat(0) && parseFloat($(this).find("LeftAmt").text()) < parseFloat($(this).find("TotalAmt").text())) {
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
                    $("#EmptyTable").show();
                    $("#tblGiftList").hide();
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