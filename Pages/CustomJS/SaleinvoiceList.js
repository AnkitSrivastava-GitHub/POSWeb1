$(document).ready(function () {
    var now = new Date();  
    SetCurrency();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    BindSaleInvoiceList(1);
    BindTerminal();

    $('#ddlCreatedFrom').select2();

    $('#txtInvoDate').datepicker({
        changeMonth: true,
        changeYear: true,
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
        dateFormat: 'mm/dd/yy',
        //yearRange: "-70:-6",
    });
});

 function PreventBackSpace(evt) {
    console.log(e.which);
    if (e.which == 8 || e.which == 46) return false;
};


var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/CurrencySymbol",
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
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
        }
    });
}

function showLoader() {
    $('#loading').show();
}

function hideLoader() {
    setTimeout(function () {
        $('#loading').hide();
    }, 1000);
}



function Pagevalue(e) {
    BindSaleInvoiceList(parseInt($(e).attr("page")));
};

function BindTerminal() {
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

function BindSaleInvoiceList(pageIndex) {
    debugger;
    showLoader();
    if (($("#txtInvoFromDate").val().trim() != '' && $("#txtInvoToDate").val().trim() == '') || ($("#txtInvoFromDate").val().trim() == '' && $("#txtInvoToDate").val().trim() != '')) {
        $('#loading').hide();
        toastr.error('Please fill both From Date and To Date', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtInvoFromDate").val().trim() != '' && $("#txtInvoToDate").val().trim() && (Date.parse($("#txtInvoFromDate").val()) > Date.parse($("#txtInvoToDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
   
    data = {
        InvoiceNo: $('#txtInvoiceNumber').val().trim(),
        CustomerName: $('#txtCustName').val().trim(),
        InvoiceFromDate: $('#txtInvoFromDate').val().trim(),
        InvoiceToDate: $('#txtInvoToDate').val().trim(),
        CreatedFrom: $('#ddlCreatedFrom').val(),
        Terminal: $('#ddlTerminal').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SaleInvoiceList.aspx/BindSaleInvoiceList",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        beforeSend: function () { showLoader(); },
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Invoice Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                debugger;
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
                        debugger;
                        status = '', CreatedFrom = '';
                        $(".InvoiceAutoId", row).html($(this).find("AutoId").text());
                        $(".InvoiceNumber", row).html($(this).find("InvoiceNo").text());
                        $(".PaymentMethod", row).html($(this).find("PaymentMethod").text());
                        $(".CustomerName", row).html($(this).find("CustomerName").text());
                        $(".Tax", row).html($(this).find("Tax").text()).css('text-align', 'right');
                        $(".Discount", row).html($(this).find("Discount").text()).css('text-align', 'right');
                        //$(".Coupon", row).html($(this).find("CouponAmt").text() + '<br/>' + $(this).find("Coupon").text());  
                        $(".Coupon", row).html($(this).find("CouponAmt").text());
                        $(".Terminal", row).html($(this).find("TerminalName").text());
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
                        //$(".SaleInvoiceItems", row).html("<a title='View Invoice Items' style='cursor:pointer;' onclick='BindSaleInvoiceItemList(" + $(this).find("AutoId").text() + ",this)'>View Items</a>");
                        $(".UpdationDetails", row).html($(this).find("UpdationDetails").text());

                        $(".Action", row).html("<a onclick='PrintInvoice(" + $(this).find("AutoId").text() + ")'><i class='fa fa-print' title='Print Invoice' style='color:black'></i></a>&nbsp;&nbsp;&nbsp;<a style='height:20px;width:20px' onclick='BindSaleInvoiceItemList(" + $(this).find("AutoId").text() + ",this)'><img src='/Style/img/View.png' height='20' width='20' title='View Invoice Details' class='' /></a>");

                        $("#tblInvoiceList").append(row);
                        row = $("#tblInvoiceList tbody tr:last-child").clone(true);
                    });                   
                    $("#tblInvoiceList").show();                   
                }
                else {
                    $("#InvoiceEmptyTable").show();
                    $("#tblInvoiceList").hide();
                    $("#spInvoiceSortBy").hide();
                    $("#ddlPageSize").hide();
                    hideLoader();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt($(pager).find("PageIndex").text()),
                    PageSize: parseInt($(pager).find("PageSize").text()),
                    RecordCount: parseInt($(pager).find("RecordCount").text())
                });
                if ($('#ddlPageSize').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
                hideLoader();
            }           
        },
        failure: function (result) {
            console.log(result.d);
            hideLoader();
        },
        error: function (result) {
            console.log(result.d);
            hideLoader();
        }
    });   
}

function PrintInvoice(AutoId) {
    window.open("/Pages/PrintSaleInvoice.html?dt=" + AutoId, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
}
function CloseModalInvoiceItemList() {
    $('#InvoiceProductListModal').modal('hide');
}

function hideWord(number) {
    let string = String(number)
    let sliced = string.slice(-4);
    let mask = String(sliced).padStart(string.length, "*")
    return mask;
}

function BindSaleInvoiceItemList(InvoiceAutoId, evt) {
    debugger;
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/Pages/SaleInvoiceList.aspx/BindSaleInvoiceItemList",
        data: "{'InvoiceAutoId':'" + InvoiceAutoId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Invoice Item Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    window.location.href = "/Default.aspx";
                });
            }
            else {
                debugger;

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
                        debugger;
                        status = '';
                        var SKUN = "",Scheme="";
                        if ($(this).find("IsGift").text() == '1') {
                            SKUN = $(this).find("SKUName").text();
                            var queryString = SKUN.replaceAll("Gift Card - ", "");
                            SKUN = "Gift Card - " + hideWord(queryString);
                        }
                        else {
                            SKUN = $(this).find("SKUName").text();
                        }
                        if ($(this).find("SchemeName").text()!="") {
                            Scheme = $(this).find("SchemeName").text() + '<br/>';
                        }
                        $(".InvoiceItemAutoId", row).html($(this).find("AutoId").text());
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
                $('#tdGrandTotal').text((CSymbol + GT).replace(CSymbol + '-', '-' + CSymbol));
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
