$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    AutoId = null;
    if (getQueryString('dt') != null) {
        AutoId = getQueryString('dt').replaceAll("%22", "");
        ShiftId = getQueryString('dt1').replaceAll("%22", "");
        ZReportDate = getQueryString('ddt').replaceAll("%22", "");
        z = getQueryString('ddl').replaceAll("%22", "");

    }
    if (AutoId != null) {
        Print_ZReport(AutoId, ShiftId, ZReportDate, z);
    }
    else {
        var now = new Date();
        var day = ("0" + now.getDate()).slice(-2);
        var month = ("0" + (now.getMonth() + 1)).slice(-2);
        var today = (month) + "/" + (day) + "/" + now.getFullYear();
        Print_ZReport(0, today);
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


function Print_ZReport(AutoId, ShiftId, ZReportDate, z) {
    $.ajax({
        type: "POST",
        url: "/Pages/Z_Report.aspx/Print_ZReport",
        data: "{'AutoId':'" + AutoId + "','ShiftId':'" + ShiftId + "','ZReportDate':'" + ZReportDate + "'}",
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
    if (response.d == "Session") {
        window.location.href = "/Default.aspx";
        return;
    }
    else if (response.d == "false") {
        window.location.href = "/Default.aspx";
        return;
    }
    else {
        debugger;
        var JsonObj = $.parseJSON(response.d);
        var ComapnyDetail = JsonObj[0].ComapnyDetail;
        var SalesAndTaxesSummary = JsonObj[0].SalesAndTaxesSummary;
        var SaleCategories = JsonObj[0].SaleCategories;
        var LotterySaleCategories = JsonObj[0].LotterySaleCategories;
        var TotalNetSales = JsonObj[0].TotalNetSales;
        var TotalLotterySalesAmt = JsonObj[0].TotalLotterySalesAmt;
        var PayoutReport = JsonObj[0].PayoutReport;
        var TotalPayoutAmt = JsonObj[0].TotalPayoutAmt;
        var LotteryPayoutReport = JsonObj[0].LotteryPayoutReport;
        var PaymentMethodDeatils = JsonObj[0].PaymentMethodDeatils;
        var TotalAmtPaymentMethodWise = JsonObj[0].TotalAmtPaymentMethodWise;
        var TotalDiscount = JsonObj[0].TotalDiscount;
        var CardBreakOut = JsonObj[0].CardBreakOut;
        var CardTotal = JsonObj[0].CardTotal;
        var TotalPayOut = JsonObj[0].TotalPayOut;
        var TotalPayOutAmt = JsonObj[0].TotalPayOutAmt;
        var TaxWiseAmt = JsonObj[0].TaxWiseAmt;
        var TaxTotalAmt = JsonObj[0].TaxTotalAmt;
        var AllowLotterySale = JsonObj[0].AllowLotterySale;
        debugger;
        var html = '', TempValue = 0;
        html += '<tr><td style="height:10px"></td></tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center;font-size:20px"><b>' + ComapnyDetail[0].CompanyName + '</b></td>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center">' + ComapnyDetail[0].BillingAddress + '</td>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center">' + ComapnyDetail[0].AddressLine2 + '</td>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center"><strong>' + ComapnyDetail[0].TerminalName + '</strong></td>';
        html += '</tr>';
        html += '<tr><td style="height:20px"></td></tr>';
        html += '<tr>';
        html += '    <td colspan="1" style="text-align:left"><b>Z Report</b></td>';
        html += '    <td colspan="3" style="text-align:right"><b><span id="lblTime">' + ZReportDate + '</td>'; //ComapnyDetail[0].CurrentTime
        html += '</tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center">';
        html += '        <hr style=" border-top: 1px dotted black;" />';
        html += '    </td>';
        html += '</tr>';
        if (SalesAndTaxesSummary.length > 0) {
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center"><b>SALES AND TAXES SUMMARY </b></td>';
            html += '</tr>';
            html += '';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="3" style="text-align:left">No. of Transactions</td>';
            html += '    <td colspan="1" style="text-align:right">' + SalesAndTaxesSummary[0].NoOfTransactions + '</td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="3" style="text-align:left">Total Net Sales (without tax)</td>';
            if (parseFloat(SalesAndTaxesSummary[0].TotalWithoutTax) < 0) {
                var TempValue = parseFloat(SalesAndTaxesSummary[0].TotalWithoutTax) * (-1);
                html += '    <td colspan="1" style="text-align:right">-' + CSymbol + parseFloat(SalesAndTaxesSummary[0].TotalWithoutTax).toFixed(2) + '</td>';
            }
            else {
                html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(SalesAndTaxesSummary[0].TotalWithoutTax).toFixed(2) + '</td>';
            }
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="3" style="text-align:left">Tax</td>';
            html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(SalesAndTaxesSummary[0].TotalTax).toFixed(2) + '</td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="3" style="text-align:left"><b>Total Sales</b></td>';
            if (parseFloat(SalesAndTaxesSummary[0].TotalWithTax) < 0) {
                TempValue = parseFloat(SalesAndTaxesSummary[0].TotalWithTax) * (-1);
                html += '    <td colspan="1" style="text-align:right">-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</td>';
            }
            else {
                html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(SalesAndTaxesSummary[0].TotalWithTax).toFixed(2) + '</td>';
            }
            html += '</tr>';
            html += '<tr><td style="height:20px"></td></tr>';
        }
        if (SaleCategories.length > 0) {
            html += '<tr style="text-align: center;">';
            html += '    <td colspan="4" style="text-align: center;">';
            html += '        <b> SALE CATEGORIES</b>';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left">Category</td>';
            html += '    <td colspan="1" style="text-align:right">Quantity</td>';
            html += '    <td colspan="1" style="text-align:right">Net Sale</td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px solid black;" />';
            html += '    </td>';
            html += '</tr>';
            debugger;
            $.each(SaleCategories, function (index, item) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left">' + SaleCategories[index].CategoryName + '</td>';
                html += '    <td colspan="1" style="text-align:center">(' + SaleCategories[index].TotalCategoryWiseProductCnt + ')</td>';
                html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(SaleCategories[index].TotalAmt).toFixed(2) + '</td>';
                html += '</tr>';
            });
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            if (TotalNetSales.length > 0) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left"><b>Total Net Sales</b></td>';
                html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(TotalNetSales[0].TotalWithTax).toFixed(2) + '</b></td>';
                html += '</tr>';
            }
        }
        if (AllowLotterySale[0].AllowLotterySale == '1') {
            if (LotterySaleCategories.length > 0) {
                html += '<tr style="text-align: center;">';
                html += '    <td colspan="4" style="text-align: center;">';
                html += '        <b> LOTTERY SALES</b>';
                html += '    </td>';
                html += '</tr>';
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left"><b>Lottery</b></td>';
                html += '    <td colspan="1" style="text-align:right"><b>Quantity</b></td>';
                html += '    <td colspan="1" style="text-align:right"><b>Net Sale</b></td>';
                html += '</tr>';
                html += '<tr>';
                html += '    <td colspan="4" style="text-align:center">';
                html += '        <hr style=" border-top: 1px solid black;" />';
                html += '    </td>';
                html += '</tr>';
                debugger;
                $.each(LotterySaleCategories, function (index, item) {
                    html += '<tr>';
                    html += '    <td colspan="2" style="text-align:left">' + LotterySaleCategories[index].LotteryName + '</td>';
                    html += '    <td colspan="1" style="text-align:center">(' + LotterySaleCategories[index].LotterySaleQty + ')</td>';
                    html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(LotterySaleCategories[index].TotalLotterySale).toFixed(2) + '</td>';
                    html += '</tr>';
                });
                html += '<tr>';
                html += '    <td colspan="4" style="text-align:center">';
                html += '        <hr style=" border-top: 1px dotted black;" />';
                html += '    </td>';
                html += '</tr>';
                if (TotalLotterySalesAmt.length > 0) {
                    html += '<tr>';
                    html += '    <td colspan="2" style="text-align:left"><b> Lottery Sales Total</b></td>';
                    html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(TotalLotterySalesAmt[0].TotalLotterySaleAmt).toFixed(2) + '</b></td>';
                    html += '</tr>';
                }
            }

            if (LotteryPayoutReport.length > 0) {
                html += '<tr><td style="height:20px"></td></tr>';
                html += '<tr>';
                html += '    <td colspan="4" style="text-align:center"><b>LOTTERY PAY OUT</b></td>';
                html += '</tr>';
                html += '<tr>';
                html += '    <td colspan="4" style="text-align:center">';
                html += '        <hr style=" border-top: 1px dotted black;" />';
                html += '    </td>';
                html += '</tr>';
                $.each(LotteryPayoutReport, function (index, item) {
                    html += '<tr>';
                    html += '    <td colspan="2" style="text-align:left">' + LotteryPayoutReport[index].PayoutMode + '</td>';
                    if (parseFloat(LotteryPayoutReport[index].TotalPayout) < 0) {
                        TempValue = parseFloat(LotteryPayoutReport[index].TotalPayout) * (-1);
                        html += '    <td colspan="2" style="text-align:right">-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</td>';
                    }
                    else {
                        html += '    <td colspan="2" style="text-align:right">' + CSymbol + parseFloat(LotteryPayoutReport[index].TotalPayout).toFixed(2) + '</td>';
                    }
                    html += '</tr>';
                });
                //debugger;
                //if (TotalPayOutAmt.length > 0) {
                //    html += '<tr>';
                //    html += '    <td colspan="4" style="text-align:center">';
                //    html += '        <hr style=" border-top: 1px solid black;" />';
                //    html += '    </td>';
                //    html += '</tr>';
                //    html += '<tr>';
                //    html += '    <td colspan="2" style="text-align:left"> <b>Total</b></td>';
                //    html += '    <td colspan="2" style="text-align:right"><b>$' + parseFloat(TotalPayOutAmt[0].TotalPayout).toFixed(2) + '</b></td>';
                //    html += '</tr>';
                //}
            }
        }
        if (PayoutReport.length > 0) {
            html += '<tr style="text-align: center;">';
            html += '    <td colspan="4" style="text-align: center;">';
            html += '        <b> PAYOUT REPORT</b>';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left"><b>Payout Name</b></td>';
            html += '    <td colspan="1" style="text-align:right"><b>Count</b></td>';
            html += '    <td colspan="1" style="text-align:right"><b>Total Amount</b></td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px solid black;" />';
            html += '    </td>';
            html += '</tr>';
            debugger;
            $.each(PayoutReport, function (index, item) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left">' + PayoutReport[index].PayoutName + '</td>';
                html += '    <td colspan="1" style="text-align:center">(' + PayoutReport[index].NoOfPayouts + ')</td>';
                if (parseFloat(PayoutReport[index].TotalPayout) < 0) {
                    TempValue = parseFloat(PayoutReport[index].TotalPayout) * (-1);
                    html += '    <td colspan="1" style="text-align:right">-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</td>';
                }
                else {
                    html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(PayoutReport[index].TotalPayout).toFixed(2) + '</td>';
                }
                //html += '    <td colspan="1" style="text-align:right">$' + parseFloat(PayoutReport[index].TotalPayout).toFixed(2) + '</td>';
                html += '</tr>';
            });
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            if (TotalPayoutAmt.length > 0) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left"><b>Total Payout</b></td>';
                if (parseFloat(TotalPayoutAmt[0].TotalPayoutAmt) < 0) {
                    TempValue = parseFloat(TotalPayoutAmt[0].TotalPayoutAmt) * (-1);
                    html += '    <td colspan="2" style="text-align:right"><b>-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</b></td>';
                }
                else {
                    html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(TotalPayoutAmt[0].TotalPayoutAmt).toFixed(2) + '</b></td>';
                }
                html += '</tr>';
            }
        }

        if (PaymentMethodDeatils.length > 0) {
            html += '<tr><td style="height:20px"></td></tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <label><b>PAYMENT DETAILS</b></label>';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            debugger;
            $.each(PaymentMethodDeatils, function (index, item) {
                html += '<tr>';

                html += '    <td colspan="2" style="text-align:left">' + PaymentMethodDeatils[index].PaymentMethod + '</td>';
                if (parseFloat(PaymentMethodDeatils[index].TotalPaymentMethodWise) < 0) {
                    TempValue = parseFloat(PaymentMethodDeatils[index].TotalPaymentMethodWise) * (-1);
                    html += '    <td colspan="2" style="text-align:right">-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</td>';
                }
                else {
                    html += '    <td colspan="2" style="text-align:right">' + CSymbol + parseFloat(PaymentMethodDeatils[index].TotalPaymentMethodWise).toFixed(2) + '</td>';
                }
                html += '</tr>';
            });
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left"> <b>Total Payments</b></td>';
            if (parseFloat(TotalAmtPaymentMethodWise[0].TotalPaymentMethodWise) < 0) {
                TempValue = parseFloat(TotalAmtPaymentMethodWise[0].TotalPaymentMethodWise) * (-1);
                html += '    <td colspan="2" style="text-align:right"><b>-' + CSymbol + parseFloat(TempValue).toFixed(2) + '</b></td>';
            }
            else {
                html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(TotalAmtPaymentMethodWise[0].TotalPaymentMethodWise).toFixed(2) + '</b></td>';
            }
            html += '</tr>';
            html += '<tr><td style="height:10px"></td></tr>';
        }
        if (TotalDiscount.length > 0) {
            html += '<tr><td style="height:30px"></td></tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center"><b>TOTAL DISCOUNTS</b></td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left"> <b>Discount Name</b></td>';
            html += '    <td colspan="1" style="text-align:right"><b>Count</b></td>';
            html += '    <td colspan="1" style="text-align:right"><b>Amount</b></td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            $.each(TotalDiscount, function (index, item) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left">' + TotalDiscount[index].PaymentMethod + ' </td>';
                html += '    <td colspan="1" style="text-align:center">' + TotalDiscount[index].CoupanCnt + '</td>';
                html += '    <td colspan="1" style="text-align:right">' + CSymbol + parseFloat(TotalDiscount[index].TotalCoupanAmt).toFixed(2) + '</td>';
                html += '</tr>';
            });
            html += '<tr><td style="height:30px"></td></tr>';
            html += '<tr>';
        }
        html += '    <td colspan="4" style="text-align:center"><b>CREDIT CARD BREAKDOWN</b></td>';
        html += '</tr>';
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center">';
        html += '        <hr style=" border-top: 1px dotted black;" />';
        html += '    </td>';
        html += '</tr>';
        $.each(CardBreakOut, function (index, item) {
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left"> ' + CardBreakOut[index].CardTypeName + '</td>';
            html += '    <td colspan="2" style="text-align:right">' + CSymbol + parseFloat(CardBreakOut[index].CardTotal).toFixed(2) + '</td>';
            html += '</tr>';
        });
        html += '<tr>';
        html += '    <td colspan="4" style="text-align:center">';
        html += '        <hr style=" border-top: 1px solid black;" />';
        html += '    </td>';
        html += '</tr>';
        if (CardTotal.length > 0) {
            html += '<tr>';
            html += '    <td colspan="2" style="text-align:left"> <b>Total</b></td>';
            html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(CardTotal[0].CardTotal).toFixed(2) + '</b></td>';
            html += '</tr>';
        }
        //if (TotalPayOut.length > 0) {
        //    html += '<tr><td style="height:20px"></td></tr>';
        //    html += '<tr>';
        //    html += '    <td colspan="4" style="text-align:center"><b>PAY OUT</b></td>';
        //    html += '</tr>';
        //    html += '<tr>';
        //    html += '    <td colspan="4" style="text-align:center">';
        //    html += '        <hr style=" border-top: 1px dotted black;" />';
        //    html += '    </td>';
        //    html += '</tr>';
        //    $.each(TotalPayOut, function (index, item) {
        //        html += '<tr>';
        //        html += '    <td colspan="2" style="text-align:left">' + TotalPayOut[index].PayoutMode + '</td>';
        //        html += '    <td colspan="2" style="text-align:right">$' + parseFloat(TotalPayOut[index].Amount).toFixed(2) + '</td>';
        //        html += '</tr>';
        //    });
        //    if (TotalPayOutAmt.length > 0) {
        //        html += '<tr>';
        //        html += '    <td colspan="4" style="text-align:center">';
        //        html += '        <hr style=" border-top: 1px solid black;" />';
        //        html += '    </td>';
        //        html += '</tr>';
        //        html += '<tr>';
        //        html += '    <td colspan="2" style="text-align:left"> <b>Total</b></td>';
        //        html += '    <td colspan="2" style="text-align:right"><b>$' + parseFloat(TotalPayOutAmt[0].Amount).toFixed(2) + '</b></td>';
        //        html += '</tr>';
        //    }
        //}
        html += '<tr><td style="height:20px"></td></tr>';
        if (TaxWiseAmt.length > 0) {
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center"><b>TAXES</b></td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black;" />';
            html += '    </td>';
            html += '</tr>';
            $.each(TaxWiseAmt, function (index, item) {
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left">' + TaxWiseAmt[index].TaxPer + '%</td>';
                html += '    <td colspan="2" style="text-align:right">' + CSymbol + parseFloat(TaxWiseAmt[index].TaxAmt).toFixed(2) + '</td>';
                html += '</tr>';
            });
            if (TaxTotalAmt.length > 0) {
                html += '<tr>';
                html += '    <td colspan="4" style="text-align:center">';
                html += '        <hr style=" border-top: 1px solid black;" />';
                html += '    </td>';
                html += '</tr>';
                html += '<tr>';
                html += '    <td colspan="2" style="text-align:left"> <b>Total</b></td>';
                html += '    <td colspan="2" style="text-align:right"><b>' + CSymbol + parseFloat(TaxTotalAmt[0].TaxAmt).toFixed(2) + '</b></td>';
                html += '</tr>';
            }

            html += '<tr>';
            html += '    <td colspan="4" style="text-align:center">';
            html += '        <hr style=" border-top: 1px dotted black; margin-top:10px;" />';
            html += '    </td>';
            html += '</tr>';
        }
        html += '<tr>';
        html += '  <td style="height:40px; font-size:10px; text-align:center" colspan="4" > Print Date & Time: ' + ComapnyDetail[0].CurrentTime + '</td>';
        html += '</tr>';
        $('#tbl_ZReport').append(html);

    }
    if (z == 1) {
        window.print();
    }
    //document.getElementById('InvContent').innerHTML = html;
    /*window.print();*/
}


