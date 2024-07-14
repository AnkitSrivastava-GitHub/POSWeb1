var InvoLoadCnt = 0, TerminalId=0,PageNo=1;
$(document).ready(function () {
    SetCurrency();
    BindTerminal();
    BindSaleInvoiceList(1);
    setInterval(function () {
        
        if ($("#ddlTerminal").val() != '0') {
            //if (InvoLoadCnt == 0 || ($("#ddlTerminal").val() != TerminalId)) {
            BindSaleInvoiceList(PageNo);
            //    InvoLoadCnt++;
            //}
           // TerminalId = $("#ddlTerminal").val();
            BindLiveCart();
        }
        else {
            resetliveCart();
            BindSaleInvoiceList(0);
            //TerminalId = 0;
        }
    }, 2000);
});

function getCartandList() {
    resetliveCart();
    BindLiveCart();
    BindSaleInvoiceList(1);

}

var CSymbol = "";
function SetCurrency() {
    
    $.ajax({
        type: "POST",
        url: "/Pages/LiveCart.aspx/CurrencySymbol",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            
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
function BindStore() {
    $.ajax({
        type: "POST",
        url: "/Pages/LiveCart.aspx/BindStore",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            
            if (response.d == 'false') {
                swal("", "No Store found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlStore option").remove();
                $("#ddlStore").append('<option value="0">Select State</option>');
                $.each(StateList, function () {
                    $("#ddlStore").append($("<option></option>").val($(this).find("A").text()).html($(this).find("P").text()));
                });
                $("#ddlStore").select2();
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

function hideWord(number) {
    let string = String(number)
    let sliced = string.slice(-4);
    let mask = String(sliced).padStart(string.length, "*");
    return mask;
}

function BindTerminal() {
    var StoreId = $("#ddlStore").val();
    $.ajax({
        type: "POST",
        url: "/Pages/LiveCart.aspx/BindTerminal",
        data: "{'StoreId':'" + StoreId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
               
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlTerminal option").remove();
                $("#ddlTerminal").append('<option value="0">Select Terminal</option>');
                $.each(StateList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("A").text()).html($(this).find("P").text()));
                });
                $("#ddlTerminal").select2();
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

function BindLiveCart() {
    if ($("#ddlTerminal").val() != '0') {
        data = {
            StoreId: $('#ddlStore').val(),
            TerminalId: $('#ddlTerminal').val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/LiveCart.aspx/BindLiveCart",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                
                if (response.d != '') {
                    var JsonObj = $.parseJSON(response.d);

                    AddInCart(JsonObj);
                    $('#loading').hide();
                }
                else {
                    resetliveCart();
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

    }
}

function resetliveCart() {
    
    $("#tblProductDetail").html('');
    $("#spn_OrderNo").text('');
    if ($("#ddlTerminal").val() == '0') {
        $("#spn_Customer").text('');
        $("#spn_User").text('');
    }
    else {
        $("#spn_Customer").text('Walk In');
    }
    $("#totalProductCnt").text('0');
    $("#totalQuantityCnt").text('0');
    $("#lblsubtotal").html('<span class="symbol">' + CSymbol + '</span>0.00');
    $("#lblgrandtotal1").html('<span class="symbol">' + CSymbol + '</span>0.00');
    $("#lblsubtotal1").html('<span class="symbol">' + CSymbol + '</span>0.00');
    $("#lbltax").html('<span class="symbol">' + CSymbol + '</span>0.00');
    $("#lbltax").html('<span class="symbol" style="margin-right: 1px;">' + CSymbol + '</span>0.00');

}

function AddInCart(JsonObj) {
    
    $('#spn_User').text(JsonObj[0].OrderDetail[0].UserName);
    $('#spn_OrderNo').text(JsonObj[0].OrderDetail[0].OrderNo);
    if (JsonObj[0].CustomerDetail.length > 0) {
        $('#spn_Customer').text(JsonObj[0].CustomerDetail[0].Name);
    }
    else {
        $('#spn_Customer').text('');
    }
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
    $('#lbltax').text((CSymbol + parseFloat(JsonObj[0].OrderDetail[0].TotalTax).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
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
        $('#DiscRemove').hide();
    }
    else {
        $('#lbldiscount').text('0.00');
        $('#lbldiscount1').text(CSymbol + '0.00');
        $('#DiscRemove').hide();
    }

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
            
            if (parseFloat(JsonObj[0].ProductList[i].UnitPrice) != parseFloat(JsonObj[0].ProductList[i].OrgUnitPrice)) {
                product += '<p><span class="original-price">' + CSymbol + parseFloat(JsonObj[0].ProductList[i].OrgUnitPrice).toFixed(2) + '</span></p>';
            }
            else {
                product += '<p><span class="original-price" style="display:none"></span></p>';
            }
            product += '</div>';
            product += '<div class="col-md-4" style="padding:0px;text-align:right;margin-left: 20px;">';
            if (parseFloat(JsonObj[0].ProductList[i].UnitPrice) < 0) {
                product += '<p>-' + CSymbol + '<span class="spnUnitPrice">' + parseFloat(JsonObj[0].ProductList[i].UnitPrice).toFixed(2).replace('-', '') + '</span></p>';

            }
            else {
                product += '<p>' + CSymbol + '<span class="spnUnitPrice">' + parseFloat(JsonObj[0].ProductList[i].UnitPrice).toFixed(2).replace('-', '') + '</span></p>';
            }
            product += '</div>';
            product += '<div class="col-md-5" style="padding:0px; text-align:right">';
            product += '<p style="display:none"><span>Tax: ' + CSymbol + '</span><span class="spntax">' + parseFloat(JsonObj[0].ProductList[i].Tax).toFixed(2) + '</span></p>';
            product += '</div>';
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            product += '</div>';
            product += '</div>';
            product += '<div class="col-md-5">';
            product += '<div class="form-row" style="margin-top: 7px;">';
            SKUName = SKUName.replace(/'/g, "&apos;");
            if (JsonObj[0].ProductList[i].SKUId != 0) {
                product += '<lable><b>Qty: </b></lable>';
                product += '<lable style="width: 50px;font-size: 21px; margin-top: -3px;">' + JsonObj[0].ProductList[i].Quantity + '</lable>';
            }
            else {
                product += '<lable><b>Qty: </b></lable>';
                product += '<lable style="width: 50px;font-size: 21px; margin-top: -3px;" >' + JsonObj[0].ProductList[i].Quantity + '</lable>';
            }
            product += '</div></div>';
            product += '<div class="col-md-1" style="padding-left: 0px;">';
            product += '</div></div></div> ';
            product += '<div class="col-md-12"><hr style="margin:0px; margin-top: 5px;" /></div ></div > ';
        }

        $("#emptyTable").hide();
        $("#tblProductDetail").prepend(product);
    }
}

function Pagevalue(e) {
    PageNo = parseInt($(e).attr("page"));
    BindSaleInvoiceList(parseInt($(e).attr("page")));
};

function BindSaleInvoiceList(pageIndex) {
    $('#loading').show();
    data = {
        StoreId: $('#ddlStore').val(),
        TerminalId: $('#ddlTerminal').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/LiveCart.aspx/BindSaleInvoiceList",
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
}
function errorImg(input) {
    $(input).attr('src', '../Images/ProductImages/product.png');
}