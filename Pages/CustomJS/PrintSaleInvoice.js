$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;

    InvoiceAutoId = getQueryString('dt');
    if (InvoiceAutoId != null) {
        Print_Invoice(InvoiceAutoId);
    }
    else {
        window.location.href = '/Default.aspx'
    }
    
});


var CSymbol = "";

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

function Print_Invoice(InvoiceAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/POS.asmx/Print_Invoice",
        data: "{'InvoiceAutoId':'" + InvoiceAutoId + "'}",
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
        var JsonObj = $.parseJSON(response.d);
        var InvoiceSKUList = JsonObj[0].InvoiceSKUList;
        //var InvoiceSKUItemList = JsonObj[0].InvoiceSKUItemList;
        var ComapanyDetails = JsonObj[0].ComapanyDetails;
        var InvoiceTransactionList = JsonObj[0].InvoiceTransactionList;
        $('#lblComName').text(JsonObj[0].CompanyName);
        $('#lblAddress1').text(JsonObj[0].BillingAddress);
        $('#lblAddress2').text(JsonObj[0].Address2);
        $('#spnInvoiceNo').text(JsonObj[0].InvoiceNo);
        $('#spnInvoiceDate').text(JsonObj[0].InvoiceDate);
        if (parseInt(JsonObj[0].EarnedRoyalty) > 0) {
            $('#spnHappyPointCount').text(parseInt(JsonObj[0].EarnedRoyalty));
            if (parseInt(JsonObj[0].ShowHappyPoints) == 1) {
                $("#trHappyPoints").show();
            }
            else {
                $("#trHappyPoints").hide();
            }
        }
        else {
            $('#spnHappyPointCount').text('0');
            $("#trHappyPoints").hide();
        }
        if (parseInt(JsonObj[0].ShowFooter) == 1) {
            $('#Footertxt').text(JsonObj[0].Footer);
            $("#trFooter").show();

        }
        else {
            $("#trFooter").hide();
        }
        if (parseFloat(JsonObj[0].LeftAmt) > 0) {
            $('#trReturnAmt').show();
            $('#spnReturnAmt').text(('-' + CSymbol + parseFloat(JsonObj[0].LeftAmt).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
        }
        else {
            $('#trReturnAmt').hide();
        }

        $('#spnInvoiceDate').text(JsonObj[0].InvoiceDate);
        $('#spnSubtotal').text((CSymbol + parseFloat(JsonObj[0].SubTotal).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
        var tempflag = CSymbol, Gflag = CSymbol, GiftCardFlag = CSymbol;
        if (parseFloat(JsonObj[0].Discount) > 0) {
            tempflag = CSymbol
        }
        if (parseFloat(JsonObj[0].CouponAmt) > 0) {
            Gflag = '-' + CSymbol;
        }
        if (parseFloat(JsonObj[0].GiftCardUsedAmt) > 0) {
            GiftCardFlag = '-' + CSymbol;
        }
        if (parseFloat(JsonObj[0].Discount) > 0) {
            $('#trDiscount').show();
            $('#spnDiscount').text(tempflag + parseFloat(JsonObj[0].Discount).toFixed(2));
        }
        debugger;
        $('#spnTax').text(CSymbol + parseFloat(JsonObj[0].Tax).toFixed(2));
        if (parseFloat(JsonObj[0].LotteryTotal)!=0) {
            $("#trLotteryTotal").show();
            if (parseFloat(JsonObj[0].LotteryTotal) < 0) {
                $('#spnLotteryTotal').text('-' + CSymbol + parseFloat(parseFloat(JsonObj[0].LotteryTotal)*(-1)).toFixed(2));
            }
            else {
                $('#spnLotteryTotal').text(CSymbol + parseFloat(JsonObj[0].LotteryTotal).toFixed(2));
            }
        }
        else {
            $("#trLotteryTotal").hide();
        }
        $('#spnPMode').text(JsonObj[0].PaymentMethod);
        if (parseFloat(JsonObj[0].CouponAmt) != 0) {
            $('#gift').show();
            var GT = parseFloat(JsonObj[0].Total);
            if (GT < 0) {
                $('#spn_Payment').text('Payout Mode : ');
            }
            $('#spnGift').text((Gflag + parseFloat(JsonObj[0].CouponAmt).toFixed(2)));
            $('#spnGrandTotal').text((CSymbol + GT.toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
        }
        else {
            $('#gift').hide();
            if (parseFloat(JsonObj[0].Total) < 0) {
                $('#spn_Payment').text('Payout Mode : ');
            }
            $('#spnGrandTotal').text((CSymbol + parseFloat(JsonObj[0].Total).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
        }
        $.each(JsonObj[0].InvoiceSKUList, function (index, item) {
            var SKUN = '';
            SKUN = item.SKUName;
            if (item.IsGift == '1') {
                var queryString = SKUN.replaceAll("Gift Card - ", "");
                SKUN = "Gift Card - " + hideWord(queryString);
            }
            else {
                //if (item.SKUProductList != '') {

                //    SKUN = '<strong>' + item.SKUName +' '+ item.ProductIdentifier + '</strong><br/>' + item.SKUProductList;
                //}
                //else {
                //    SKUN =  item.SKUName + '<br/>' + item.SKUProductList;
                //}

                if ((item.SKUName).includes('</br>')) {
                    //SKUN = item.SKUName;
                    SKUN = '<strong>' + SKUN.substring(0, SKUN.indexOf('</br>')) + '</strong>' + item.ProductIdentifier + SKUN.substring(SKUN.indexOf('</br>'), (SKUN.length));
                }
                //else {
                //    SKUN = item.SKUName;
                //}
                
            }
            html += '<tr style="vertical-align:top;">';
            html += '<td style="width:3%">' + (index + 1) + '.' + '</td>';
            html += '<td style="width:72%">' + SKUN + '</td>';
            html += '<td style="text-align:center; width:5%">' + item.Quantity + '</td>';
            html += '<td style="text-align:right; width:10%">' + parseFloat(item.Price).toFixed(2) + '</td>';
            /* html += '<td style="text-align:right">' + item.Tax + '</td>';*/
            html += '<td style="text-align:right; width:10%">' + parseFloat(parseFloat(item.Quantity) * parseFloat(item.Price)).toFixed(2) + '</td>';
            html += '</tr>';

        });
        $('#InvoiceItemBody').append(html);
        htmltrans = "", transCount = 0;
        $.each(JsonObj[0].InvoiceTransactionList, function (index, item) {
            if (parseFloat(item.Amount) != 0) {
                var Mode = item.PaymentMode;
                if (Mode == "Happy points") {
                    Mode = "Reward Points";
                }
                var Amt = (CSymbol + parseFloat(item.Amount).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol);
                htmltrans += '<tr>';
                htmltrans += '<td style="width:65%">' + Mode + '</td>';
                htmltrans += '<td style="width:5%"> : </td>';
                htmltrans += '<td style="text-align:right; width:30%">' + Amt + '</td>';
                htmltrans += '</tr>';
                transCount++;
            }
        });
        if (transCount == 0) {
            $('#InvoiceTransactionBody').hide();
            $('#trsHead').hide();
        }
        $('#InvoiceTransactionBody').append(htmltrans);
    }

    document.getElementById('InvContent').innerHTML = html;    
    $('#dv_print').show();
    window.print();
}

function hideWord(number) {
    let string = String(number)
    let sliced = string.slice(-4);
    let mask = String(sliced).padStart(string.length, "*")
    return mask;
}


