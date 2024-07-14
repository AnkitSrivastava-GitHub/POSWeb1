var SchemeSKUId = 0, SchemeId = 0;
$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    //BindSKU();
    var SchemeAutoId = getQueryString('PageId');
    if (SchemeAutoId != null) {
        editSchemeDetail(SchemeAutoId);
    }
    else {
        BindSKU();
    }
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        min: true,
        selectYears: true,
        selectMonths: true,
    });

    $(window).keydown(function (e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            return false;
        }
    });
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeMaster.aspx/CurrencySymbol",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            debugger;

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

function editSchemeDetail(SchemeAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeMaster.aspx/BindSchemeDetails",
        data: "{'SchemeAutoId':'" + SchemeAutoId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClientOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var JsonObj = $.parseJSON(response.d);
                var SKUDetails = JsonObj[0].SKUDetails;
                var SKUProductList = JsonObj[0].SKUProductList;
                var SKUList = JsonObj[0].SKUList;
                var CurrencySymbol = JsonObj[0].CurrencySymbol;
                CSymbol = CurrencySymbol[0].A;
                $('.symbol').text(CurrencySymbol[0].A);
                //var xmldoc = $.parseXML(response.d);
                //var xml = $(xmldoc);
                //var SKUDetails = xml.find("Table");
                //var SKUProductList = xml.find("Table1");
                //var SKUList = xml.find("Table2");

                $("#ddlSKU option").remove();
                if (SKUList.length > 0) {
                    $("#ddlSKU").append('<option value="0">Select SKU/Product</option>');
                    $.each(SKUList, function (index, item) {
                        $("#ddlSKU").append($("<option></option>").val(SKUList[index].AutoId).html(SKUList[index].SKUName));
                    });
                }
                $("#ddlSKU").select2();

                SchemeId = SKUDetails[0].AutoId;
                $("#txtSchemeName").val(SKUDetails[0].SchemeName);
                $("#ddlSKU").val(SKUDetails[0].SKUAutoId).select2();
                $("#ddlSchemeStatus").val(SKUDetails[0].Status);
                $("#txtSKUUnitPrice").val(parseFloat(SKUDetails[0].SKUPrice).toFixed(2));
                $("#txtQuantity").val(SKUDetails[0].Quantity);
                $("#txtFromDate").val(SKUDetails[0].FromDate);
                $("#txtToDate").val(SKUDetails[0].ToDate);
                $("#txtQuantity").val(SKUDetails[0].Quantity);
                var SchemeDays = (SKUDetails[0].SchemeDaysString).split(',');
                debugger;
                $("input:checkbox[name=DayNames]").each(function () {
                    if (SchemeDays.includes($(this).val())) {
                        $(this).attr('checked', true);
                    }
                });
                if (SchemeDays.length == 7) {
                    debugger;
                    $('#chkAllDays').attr('checked', true);
                }
                if (SKUProductList.length > 0) {
                    $.each(SKUProductList, function (index, item) {
                        debugger;
                        var tableHtml = '';
                        tableHtml += '<tr>';
                        //tableHtml += '<td class="Action" style="width: 50px;text-align:center"><a id="deleterow"  title="Remove" onclick=""><span class="fa fa-times" style="color: blue;"></span></a></td>';
                        tableHtml += '<td class="SchemeItemAutoId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].AutoId + '</td>';
                        tableHtml += '<td class="ProductId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].ProductId + '</td>';
                        tableHtml += '<td class="ProductName" style="white-space: nowrap;text-align:center">' + SKUProductList[index].ProductName + '</td>';
                        tableHtml += '<td class="Unit" style="white-space: nowrap;text-align:center">' + SKUProductList[index].PackingName + '</td>';
                        tableHtml += '<td class="Quantity" style="white-space: nowrap;text-align:center">' + SKUProductList[index].Quantity + '</td>';
                        tableHtml += '<td class="UnitAutoId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].PackingId + '</td>';
                        tableHtml += '<td class="OrgUnitPrice" style="white-space: nowrap;text-align:right">' + parseFloat(SKUProductList[index].SellingPrice).toFixed(2) + '</td>';
                        tableHtml += '<td class="AmtUnitDiscount" style="white-space: nowrap;text-align:right;width:10%">';
                        tableHtml += '<input type="text" id="txtAmtUnitDisc" class="form-control input-sm" onclick="this.select();" oncopy="return false" onpaste="return false" oncut="return false" onchange="validateDiscount(\'' + 'amt' + '\',this)" style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="6" value="0" /></td>';
                        tableHtml += '<td class="PerUnitDiscount" style="white-space: nowrap;text-align:right;width:10%">';
                        tableHtml += '<input type="text" id="txtPerUnitDisc" class="form-control input-sm" onclick="this.select();" oncopy="return false" onpaste="return false" oncut="return false" onchange="validateDiscount(\'' + 'per' + '\',this)" style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="5" value="0" /></td>';
                        tableHtml += '<td class="UnitPrice" style="white-space: nowrap;text-align:right;width:10%">';
                        tableHtml += '<input type="text" id="txtUnitPrice" class="form-control input-sm" oncopy="return false" onpaste="return false" oncut="return false" readonly style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="10" value="' + SKUProductList[index].UnitPrice + '" /></td>';
                        tableHtml += '<td class="Discount" style="white-space: nowrap;text-align:right;display:none;">' + parseFloat(SKUProductList[index].Discount).toFixed(2) + '</td>';
                        tableHtml += '<td class="Tax" style="white-space: nowrap;text-align:right"></td>';
                        /*  tableHtml += '<td class="TaxAutoId" style="white-space: nowrap;align-content:center;display:none;">' + SKUProductList[index].TaxAutoId + '</td>';*/
                        tableHtml += '<td class="TaxPer" style="white-space: nowrap;align-content:center;display:none;">' + SKUProductList[index].TaxPer + '</td>';
                        tableHtml += '<td class="Total" style="white-space: nowrap;text-align:right;"></td>';
                        tableHtml += '<td class="ActionId" style="white-space: nowrap;text-align:right; display: none;">2</td>';
                        tableHtml += ' </tr>';
                        $("#tblSchemeProductListBody").append(tableHtml);
                    });
                    //calc_SchemeValues2();
                    //calc_SchemeValue2();
                    CalSchemeDiscount('update');
                }
                //else {
                //    swal('', 'There is no active product in selected Scheme', 'warning');
                //}
                $("#btnSave").hide();
                $("#btnUpdate").show();
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

function isAllday() {
    debugger;
    if ($("input:checkbox[name=DayNames]:checked").length == 7) {
        //$('#chkAllDays').('checked', true);
        $('#chkAllDays').prop('checked', true);
    }
    else {
        $('#chkAllDays').removeAttr('checked');
    }
}

function BindSKU() {
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeMaster.aspx/BindSKU",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                debugger;
                var ProductList = $.parseJSON(response.d);

                if (ProductList != null) {
                    debugger;

                    var PType = $("#ddlSKU"); var ProVal = 0;
                    $("#ddlSKU option:not(:first)").remove();
                    for (var k = 0; k < ProductList.length; k++) {
                        var Product = ProductList[k];
                        if (Product.IsDefault == 1) {
                            ProVal = Product.A;
                        }
                        var option = $("<option />");
                        option.html(Product.P);
                        option.val(Product.A);
                        PType.append(option);
                    }
                    $("#ddlSKU").select2();
                    $("#ddlSKU").val(ProVal).change();
                }
            }
        },
        failure: function (result) {
            debugger;
            console.log(result.d);
        },
        error: function (result) {
            debugger;
            console.log(result.d);
        }
    });
}

function BindSKUDetails() {
    if ($("#ddlSKU").val() == '0') {
        $('#txtSKUUnitPrice').val('0.00');
        $('#txtSchemePrice').val('0.00');
        $('#F_UnitPrice').text(CSymbol + '0.00');
        $('#F_Tax').text(CSymbol + '0.00');
        $('#F_Total').text(CSymbol + '0.00');
        $('#tblSchemeProductListBody').empty();
    }
    else {
        $.ajax({
            type: "POST",
            url: "/Pages/SchemeMaster.aspx/BindSKUDetails",
            data: "{'SKUId':'" + $("#ddlSKU").val() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No SKU/product found!", "warning", { closeOnClientOutside: false });
                } else if (response.d == "Session") {
                    location.href = '/';
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SKUUnitPrice = xml.find("Table");
                    var SKUProductList = xml.find("Table1");
                    SchemeSKUId = parseInt($("#ddlSKU").val());
                    if (SKUUnitPrice.length > 0) {
                        $('#txtSKUUnitPrice').val($(SKUUnitPrice).find('SKUPrice').text());
                        $('#txtSchemePrice').val($(SKUUnitPrice).find('SKUPrice').text());
                    }
                    $("#tblSchemeProductListBody").empty();
                    if (SKUProductList.length > 0) {
                        $.each(SKUProductList, function (index, item) {
                            debugger;
                            var tableHtml = '';
                            tableHtml += '<tr>';
                            //tableHtml += '<td class="Action" style="width: 50px;text-align:center"><a id="deleterow"  title="Remove" onclick=""><span class="fa fa-times" style="color: blue;"></span></a></td>';
                            tableHtml += '<td class="SchemeItemAutoId" style="white-space: nowrap;text-align:center;display:none;">0</td>';
                            tableHtml += '<td class="ProductId" style="white-space: nowrap;text-align:center;display:none;">' + $(this).find("ProductId").text() + '</td>';
                            tableHtml += '<td class="ProductName" style="white-space: nowrap;text-align:center">' + $(this).find("ProductName").text() + '</td>';
                            tableHtml += '<td class="Unit" style="white-space: nowrap;text-align:center">' + $(this).find("PackingName").text() + '</td>';
                            tableHtml += '<td class="Quantity" style="white-space: nowrap;text-align:center">' + $(this).find("Quantity").text() + '</td>';
                            tableHtml += '<td class="UnitAutoId" style="white-space: nowrap;text-align:center;display:none;">' + $(this).find("PackingId").text() + '</td>';
                            tableHtml += '<td class="OrgUnitPrice" style="white-space: nowrap;text-align:center">' + $(this).find("UnitPrice").text() + '</td>';
                            tableHtml += '<td class="AmtUnitDiscount" style="white-space: nowrap;text-align:right;width:10%">';
                            tableHtml += '<input type="text" id="txtAmtUnitDisc" class="form-control input-sm" oncopy="return false" onclick="this.select();"onpaste="return false" oncut="return false" onchange="validateDiscount(\'' + 'amt' + '\',this)" style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="6" value="0" /></td>';
                            tableHtml += '<td class="PerUnitDiscount" style="white-space: nowrap;text-align:right;width:10%">';
                            tableHtml += '<input type="text" id="txtPerUnitDisc" class="form-control input-sm" oncopy="return false" onclick="this.select();"onpaste="return false" oncut="return false" onchange="validateDiscount(\'' + 'per' + '\',this)" style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="5" value="0" /></td>';
                            tableHtml += '<td class="UnitPrice" style="white-space: nowrap;text-align:right;width:10%">';
                            tableHtml += '<input type="text" id="txtUnitPrice" maxlength="8" oncopy="return false" onpaste="return false" readonly oncut="return false" class="form-control input-sm"  style="text-align:right;width:100%;" onkeypress="return isNumberDecimalKey(event,this)" value="' + $(this).find("SKUItemUnitPrice").text() + '" /></td>';
                            tableHtml += '<td class="Discount" style="white-space: nowrap;text-align:right;display:none;">' + parseFloat($(this).find("Discount").text()).toFixed(2) + '</td>';
                            tableHtml += '<td class="Tax" style="white-space: nowrap;text-align:right"></td>';
                            /* tableHtml += '<td class="TaxAutoId" style="white-space: nowrap;align-content:center;display:none;">' + $(this).find("TaxAutoId").text() + '</td>';*/
                            tableHtml += '<td class="TaxPer" style="white-space: nowrap;align-content:center;display:none;">' + $(this).find("TaxPer").text() + '</td>';
                            tableHtml += '<td class="Total" style="white-space: nowrap;text-align:right;"></td>';
                            tableHtml += '<td class="ActionId" style="white-space: nowrap;text-align:right; display: none;">1</td>';
                            tableHtml += ' </tr>';
                            $("#tblSchemeProductListBody").append(tableHtml);
                        });
                        CalSchemeDiscount('new');
                    }
                    else {
                        swal('', 'There is no active product in selected SKU', 'warning', { closeOnClientOutside: false });
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

function increaseValueSKU() {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value++;
    $('#txtQuantity').val(value);
    //calc_SchemeValues();
    //calc_SchemeValue();
}

function ChangeValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 1 : '';
    $('#txtQuantity').val(value);
    //calc_SchemeValues();
    //calc_SchemeValue();
}

function decreaseValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 2 : '';
    value--;
    $('#txtQuantity').val(value);
    //calc_SchemeValues();
    //calc_SchemeValue();
}

//function calc_SchemeValue() {
//    debugger;
//    var T_Total = 0, Quantity = 0, Subtotal = 0, T_Tax = 0, T_Total, RowWiseTax = 0, RowWiseTotal = 0, UnitP = 0, DiscountedValue = 0;
//    $('#tblSchemeProductListBody tr').each(function () {
//        debugger;
//        RowWiseTax = 0;
//        RowWiseTotal = 0;

//        if (isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val()))) {
//            UnitPrice = 0;
//            $(this).find('.UnitPrice input:eq(0)').val('0.00');
//        }
//        else {
//            UnitPrice = isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitPrice input:eq(0)').val()));
//            $(this).find('.UnitPrice input:eq(0)').val(parseFloat(UnitPrice).toFixed(2));
//        }
//        if (isNaN(parseFloat($(this).find('.Unitprime').text()))) {
//            Unitprime = 0;
//            $(this).find('.Unitprime').text('0.00');
//        }
//        else {
//            Unitprime = isNaN(parseFloat($(this).find('.Unitprime').text())) ? 0 : (parseFloat($(this).find('.Unitprime').text()));

//        }
//        if (isNaN(parseFloat($(this).find('.Quantity').text()))) {
//            Quantity = 0;
//            $(this).find('.Quantity').text('0.00');
//        }
//        else {
//            Quantity = isNaN(parseFloat($(this).find('.Quantity').text())) ? 0 : (parseFloat($(this).find('.Quantity').text()));

//        }
//        //------------Discount Unit Price in Doler--------------------

//        if (($(this).find('.UnitDiscountDL input:eq(0)').val()) == 0) {
//            UnitDiscountDL = 0.00;
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(0.00))
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            UnitDiscount = 0;
//        }
//        else if (($(this).find('.UnitDiscountDL input:eq(0)').val()) > Unitprime) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            swal('', 'Discount can not be greater than the Original Unit Price', 'warning');
//        }
//        else {
//            UnitDiscountDL = isNaN(parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val()));
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//        }

//        //------------Discount Unit Price in Percentge -------------

//        //if (($(this).find('.UnitDiscount input:eq(0)').val()) == 0) {
//        //    Diffrenceamount = (Unitprime - UnitPrice);
//        //    UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//        //    $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));

//        //}
//        //else if (($(this).find('.UnitDiscount input:eq(0)').val()) > 100) {
//        //    Diffrenceamount = (Unitprime - UnitPrice);
//        //    UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//        //    $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//        //    swal('', "Discount percentage can't be greater than 100 %", 'warning');
//        //}
//        //else {
//        //    UnitDiscount = isNaN(parseFloat($(this).find('.UnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscount input:eq(0)').val()));

//        //}


//        DiscountedValue = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));

//        UnitPrice = parseFloat(Unitprime).toFixed(2) - DiscountedValue;
//        Subtotal = isNaN(parseFloat(UnitPrice * Quantity).toFixed(2)) ? 0 : (parseFloat(UnitPrice * Quantity).toFixed(2));


//        if (isNaN(parseFloat($(this).find('.TaxPer').text()))) {
//            TaxPer = 0;
//            $(this).find('.TaxPer').text('0.00');
//        }
//        else {
//            TaxPer = isNaN(parseFloat($(this).find('.TaxPer').text())) ? 0 : (parseFloat($(this).find('.TaxPer').text()));
//        }
//        RowWiseTax = parseFloat(Subtotal * TaxPer / 100).toFixed(2);
//        RowWiseTotal = parseFloat(Subtotal) + parseFloat(RowWiseTax);

//        $(this).find('.UnitPrice input').val(parseFloat(UnitPrice).toFixed(2));
//        $(this).find('.Tax').text(parseFloat(RowWiseTax).toFixed(2));
//        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));

//        UnitP += UnitPrice;
//        T_Tax = parseFloat(T_Tax) + parseFloat(RowWiseTax);
//        T_Total = parseFloat(T_Total) + parseFloat(RowWiseTotal);
//    });
//    $('#F_UnitPrice').text(CSymbol+ parseFloat(UnitP).toFixed(2));
//    $('#F_Tax').text(CSymbol+ parseFloat(T_Tax).toFixed(2));
//    $('#F_Total').text(CSymbol+ parseFloat(T_Total).toFixed(2));
//    $("#txtSchemePrice").val(parseFloat(T_Total).toFixed(2));
//}
//function calc_SchemeValues() {
//    debugger;
//    var T_Total = 0, Quantity = 0, Subtotal = 0, T_Tax = 0, T_Total, RowWiseTax = 0, RowWiseTotal = 0, UnitP = 0, DiscountedValue = 0;
//    $('#tblSchemeProductListBody tr').each(function () {
//        debugger;
//        RowWiseTax = 0;
//        RowWiseTotal = 0;

//        if (isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val()))) {
//            UnitPrice = 0;
//            $(this).find('.UnitPrice input:eq(0)').val('0.00');
//        }
//        else {
//            UnitPrice = isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitPrice input:eq(0)').val()));
//            $(this).find('.UnitPrice input:eq(0)').val(parseFloat(UnitPrice).toFixed(2));
//        }
//        if (isNaN(parseFloat($(this).find('.Unitprime').text()))) {
//            Unitprime = 0;
//            $(this).find('.Unitprime').text('0.00');
//        }
//        else {
//            Unitprime = isNaN(parseFloat($(this).find('.Unitprime').text())) ? 0 : (parseFloat($(this).find('.Unitprime').text()));

//        }
//        if (isNaN(parseFloat($(this).find('.Quantity').text()))) {
//            Quantity = 0;
//            $(this).find('.Quantity').text('0.00');
//        }
//        else {
//            Quantity = isNaN(parseFloat($(this).find('.Quantity').text())) ? 0 : (parseFloat($(this).find('.Quantity').text()));

//        }
//        //------------Discount Unit Price in Doler--------------------

//        if (($(this).find('.UnitDiscountDL input:eq(0)').val()) == 0) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));

//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//        }
//        else if (($(this).find('.UnitDiscountDL input:eq(0)').val()) > Unitprime) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            swal('', 'Discount can not be greater than the Unit Price', 'warning');
//        }
//        else {
//            UnitDiscountDL = isNaN(parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val()));

//        }

//        //------------Discount Unit Price in Percentge -------------

//        if (($(this).find('.UnitDiscount input:eq(0)').val()) == 0) {
//            //Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = 0.00;
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//        }
//        else if (($(this).find('.UnitDiscount input:eq(0)').val()) > 100) {
//            Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = (Diffrenceamount / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//            swal('', "Discount percentage can't be greater than 100 %", 'warning');
//        }
//        else {
//            UnitDiscount = isNaN(parseFloat($(this).find('.UnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscount input:eq(0)').val()));
//            UnitDiscountDL = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//        }


//        DiscountedValue = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));

//        UnitPrice = parseFloat(Unitprime).toFixed(2) - DiscountedValue;
//        Subtotal = isNaN(parseFloat(UnitPrice * Quantity).toFixed(2)) ? 0 : (parseFloat(UnitPrice * Quantity).toFixed(2));


//        if (isNaN(parseFloat($(this).find('.TaxPer').text()))) {
//            TaxPer = 0;
//            $(this).find('.TaxPer').text('0.00');
//        }
//        else {
//            TaxPer = isNaN(parseFloat($(this).find('.TaxPer').text())) ? 0 : (parseFloat($(this).find('.TaxPer').text()));
//        }
//        RowWiseTax = parseFloat(Subtotal * TaxPer / 100).toFixed(2);
//        RowWiseTotal = parseFloat(Subtotal) + parseFloat(RowWiseTax);

//        $(this).find('.UnitPrice input').val(parseFloat(UnitPrice).toFixed(2));
//        $(this).find('.Tax').text(parseFloat(RowWiseTax).toFixed(2));
//        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));

//        UnitP += UnitPrice;
//        T_Tax = parseFloat(T_Tax) + parseFloat(RowWiseTax);
//        T_Total = parseFloat(T_Total) + parseFloat(RowWiseTotal);
//    });
//    $('#F_UnitPrice').text(CSymbol+ parseFloat(UnitP).toFixed(2));
//    $('#F_Tax').text(CSymbol+ parseFloat(T_Tax).toFixed(2));
//    $('#F_Total').text(CSymbol+ parseFloat(T_Total).toFixed(2));
//    $("#txtSchemePrice").val(parseFloat(T_Total).toFixed(2));
//}

function validateDiscount(para, e) {
    debugger;
    if (!isNaN(parseFloat($(e).val()))) {
        if (para == 'amt') {
            debugger;
            if (parseFloat($(e).parent().parent().find('.OrgUnitPrice').text()) >= parseFloat($(e).val())) {
                CalSchemeDiscount(para);
            }
            else {
                $(e).val('0.00');
                toastr.error("Discount amount can't be greater than original unit price.", 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                return false;
            }
        }
        else if (para == 'per') {
            debugger;
            if (parseFloat($(e).val()) <= 100) {
                CalSchemeDiscount(para);
            }
            else {
                $(e).val('0.00');
                toastr.error("Percentage can't be greater than 100.", 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                return false;
            }
        }
    }
    else {
        $(e).val('0.00');
        toastr.error('Please fill valid discount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }

}

function CalSchemeDiscount(para) {
    var RowWiseTax = 0, RowWiseTotal = 0, SchemePrice = 0, T_Tax = 0, T_Total = 0, OrgUnitPrice = 0, UnitPrice = 0, TaxPer = 0, DiscPer = 0, DiscAmt = 0, Qty = 0;
    $('#tblSchemeProductListBody tr').each(function (index, item) {
        debugger;
        OrgUnitPrice = isNaN(parseFloat($(this).find('.OrgUnitPrice').text())) ? 0 : (parseFloat($(this).find('.OrgUnitPrice').text()));
        TaxPer = isNaN(parseFloat($(this).find('.TaxPer').text())) ? 0 : (parseFloat($(this).find('.TaxPer').text()));
        Qty = isNaN(parseFloat($(this).find('.Quantity').text())) ? 0 : (parseFloat($(this).find('.Quantity').text()));

        if (para == 'amt') {
            debugger;
            DiscAmt = isNaN(parseFloat($(this).find('.AmtUnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.AmtUnitDiscount input:eq(0)').val()));
            DiscPer = (DiscAmt * 100) / OrgUnitPrice;
        }
        else if (para == 'per') {
            debugger;
            DiscPer = isNaN(parseFloat($(this).find('.PerUnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.PerUnitDiscount input:eq(0)').val()));
            DiscAmt = (OrgUnitPrice * DiscPer) / 100;
        }
        else if (para == 'new') {
            DiscAmt = isNaN(parseFloat($(this).find('.Discount').text())) ? 0 : (parseFloat($(this).find('.Discount').text()));
            DiscPer = (DiscAmt * 100) / OrgUnitPrice;
        }
        else if (para == 'update') {
            UnitPrice = isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitPrice input:eq(0)').val()));
            DiscAmt = parseFloat(OrgUnitPrice) - parseFloat(UnitPrice);
            DiscPer = (DiscAmt * 100) / OrgUnitPrice;
        }

        UnitPrice = OrgUnitPrice - DiscAmt;
        RowWiseTax = (UnitPrice * TaxPer) / 100;
        RowWiseTax = RowWiseTax * Qty;
        RowWiseTotal = parseFloat(UnitPrice * Qty) + parseFloat(RowWiseTax);

        $(this).find('.AmtUnitDiscount input:eq(0)').val(parseFloat(DiscAmt).toFixed(2));
        $(this).find('.PerUnitDiscount input:eq(0)').val(parseFloat(DiscPer).toFixed(2));
        $(this).find('.UnitPrice input').val(parseFloat(UnitPrice).toFixed(2));
        $(this).find('.Tax').text(parseFloat(RowWiseTax).toFixed(2));
        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));

        SchemePrice += UnitPrice * Qty;
        T_Tax = parseFloat(T_Tax) + parseFloat(RowWiseTax);
        T_Total = parseFloat(T_Total) + parseFloat(RowWiseTotal);
    });
    $('#F_UnitPrice').text(CSymbol + parseFloat(SchemePrice).toFixed(2));
    $('#F_Tax').text(CSymbol + parseFloat(T_Tax).toFixed(2));
    $('#F_Total').text(CSymbol + parseFloat(T_Total).toFixed(2));
    $("#txtSchemePrice").val(parseFloat(T_Total).toFixed(2));
}

function InsertScheme() {
    $('#loading').show();
    if ($('#txtSchemeName').val().trim() == '') {
        toastr.error('Please enter Scheme name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSchemeName").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlSKU').val() == '0') {
        toastr.error('Please select SKU/Product.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        //$("#txtDescription").addClass('border-warning');
        $('#loading').hide();
        return false;
    }

    if (($('#txtFromDate').val().trim() == '' && $('#txtToDate').val().trim() != '') || ($('#txtFromDate').val().trim() != '' && $('#txtToDate').val().trim() == '')) {
        toastr.error('Please fill both Scheme start date and end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFromDate").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    //if ($('#txtToDate').val().trim()== '') {
    //    toastr.error('Please enter Scheme end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtToDate").addClass('border-warning');
    //    $('#loading').hide();
    //    return false;
    //}
    debugger;
    if (Date.parse($('#txtFromDate').val().trim()) > Date.parse($('#txtToDate').val().trim())) {
        toastr.error('Start date can not be greater than end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if ($('#txtSKUUnitPrice').val().trim() == '') {
        toastr.error('SKU Unit Price not recognized.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUUnitPrice").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if ($('#txtSchemePrice').val().trim() == '') {
        toastr.error('Scheme Price not recognized.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSchemePrice").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (parseInt($('#txtQuantity').val().trim()) < 1) {
        toastr.error('Quantity can not be less than 1.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    debugger;
    var SchemeDays = [], SchemeDaysString = '';
    $("input:checkbox[name=DayNames]:checked").each(function () {
        debugger;
        SchemeDays.push($(this).val());
    });
    debugger;
    SchemeDaysString = SchemeDays.join();
    if (SchemeDaysString == '') {
        toastr.error('Please select atleast one day.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        // $("#F_Total").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (parseFloat($('#F_Total').text().replace('$', '')) == 0) {
        toastr.error('Total price can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        // $("#F_Total").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    data = {
        SKUId: $('#ddlSKU').val(),
        SchemeName: $('#txtSchemeName').val().trim(),
        Status: $('#ddlSchemeStatus').val(),
        Quantity: $('#txtQuantity').val().trim(),
        FromDate: $('#txtFromDate').val().trim(),
        ToDate: $('#txtToDate').val().trim(),
        SchemeDaysString: SchemeDaysString

    }
    SchemeProductTable = new Array();
    var i = 0;
    $("#tblSchemeProductList #tblSchemeProductListBody tr").each(function (index, item) {
        /* if ($(item).find('.SKUItemAutoId').text() != '0') {*/
        SchemeProductTable[i] = new Object();
        SchemeProductTable[i].SchemeItemAutoId = $(item).find('.SchemeItemAutoId').text();
        SchemeProductTable[i].ProductId = $(item).find('.ProductId').text();
        SchemeProductTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
        SchemeProductTable[i].Quantity = $(item).find('.Quantity').text();
        SchemeProductTable[i].UnitPrice = $(item).find('.UnitPrice input:eq(0)').val();
        SchemeProductTable[i].ActionId = $(item).find('.ActionId').text();
        i++;
        /*}*/
    });
    if (SchemeProductTable.length <= 0) {
        swal("Error!", "Please add a product.", "error", { closeOnClientOutside: false });
        $('#loading').hide();
        return;
    }
    var SchemeSKUTableValues = JSON.stringify(SchemeProductTable);
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeMaster.aspx/InsertScheme",
        data: JSON.stringify({ dataValues: JSON.stringify(data), SchemeSKUTableValues: SchemeSKUTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                //$('#tblProductDetail tbody').empty();
                ResetSchemeDetails();
                swal("Success!", "Scheme added successfully.", "success", { closeOnClickOutside: false });
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                $('#loading').hide();
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

function UpdateScheme() {
    $('#loading').show();
    if ($('#txtSchemeName').val().trim() == '') {
        toastr.error('Please enter Scheme name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSchemeName").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlSKU').val() == '0') {
        toastr.error('Please select SKU.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        //$("#txtDescription").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if ($('#txtSKUUnitPrice').val().trim() == '') {
        toastr.error('SKU Unit Price not recognized.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUUnitPrice").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if ($('#txtSchemePrice').val().trim() == '') {
        toastr.error('Scheme Price not recognized.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSchemePrice").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (parseInt($('#txtQuantity').val().trim()) < 1) {
        toastr.error('Quantity can not be less than 1.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (parseFloat($('#F_Total').text().replace(CSymbol, '')) == 0) {
        toastr.error('Total price can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        // $("#F_Total").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (($('#txtFromDate').val().trim() == '' && $('#txtToDate').val().trim() != '') || ($('#txtFromDate').val().trim() != '' && $('#txtToDate').val().trim() == '')) {
        toastr.error('Please fill both Scheme start date and end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFromDate").addClass('border-warning');
        $('#loading').hide();
        return false;
    }

    //if ($('#txtFromDate').val().trim() == '') {
    //    toastr.error('Please enter Scheme start date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtFromDate").addClass('border-warning');
    //    $('#loading').hide();
    //    return false;
    //}
    //if ($('#txtToDate').val().trim() == '') {
    //    toastr.error('Please enter Scheme end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtToDate").addClass('border-warning');
    //    $('#loading').hide();
    //    return false;
    //}
    debugger;
    if (Date.parse($('#txtFromDate').val().trim()) > Date.parse($('#txtToDate').val().trim())) {
        toastr.error('Start date can not be greater than end date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    debugger;
    var SchemeDays = [], SchemeDaysString = '';
    $("input:checkbox[name=DayNames]:checked").each(function () {
        debugger;
        SchemeDays.push($(this).val());
    });

    SchemeDaysString = SchemeDays.join();
    if (SchemeDaysString == '') {
        toastr.error('Please select atleast one day.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        // $("#F_Total").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    if (SchemeId != 0 && SchemeId != '') {
        data = {
            SchemeId: SchemeId,
            SKUAutoId: $('#ddlSKU').val(),
            SchemeName: $('#txtSchemeName').val().trim(),
            Status: $('#ddlSchemeStatus').val(),
            Quantity: $('#txtQuantity').val().trim(),
            FromDate: $('#txtFromDate').val().trim(),
            ToDate: $('#txtToDate').val().trim(),
            SchemeDaysString: SchemeDaysString
        }
        SchemeProductTable = new Array();
        var i = 0;
        $("#tblSchemeProductList #tblSchemeProductListBody tr").each(function (index, item) {
            /* if ($(item).find('.SKUItemAutoId').text() != '0') {*/
            SchemeProductTable[i] = new Object();
            SchemeProductTable[i].SchemeItemAutoId = $(item).find('.SchemeItemAutoId').text();
            SchemeProductTable[i].ProductId = $(item).find('.ProductId').text();
            SchemeProductTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
            SchemeProductTable[i].Quantity = $(item).find('.Quantity').text();
            SchemeProductTable[i].UnitPrice = $(item).find('.UnitPrice input:eq(0)').val();
            SchemeProductTable[i].ActionId = $(item).find('.ActionId').text();
            i++;
            /*}*/
        });
        if (SchemeProductTable.length <= 0) {
            swal("Error!", "Please add a product.", "error", { closeOnClientOutside: false });
            $('#loading').hide();
            return;
        }
        var SchemeSKUTableValues = JSON.stringify(SchemeProductTable);
        $.ajax({
            type: "POST",
            url: "/Pages/SchemeMaster.aspx/UpdateScheme",
            data: JSON.stringify({ dataValues: JSON.stringify(data), SchemeSKUTableValues: SchemeSKUTableValues }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'true') {
                    //$('#tblProductDetail tbody').empty();
                    $('#loading').hide();
                    ResetSchemeDetails();
                    swal("Success!", "Scheme updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        window.location.reload();
                    });

                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal('Error!', response.d, 'error', { closeOnClientOutside: false });
                    $('#loading').hide();
                }
            },
            failure: function (result) {
                swal('Error!', response.d, 'error', { closeOnClientOutside: false });
                $('#loading').hide();
            },
            error: function (result) {
                swal('Error!', response.d, 'error', { closeOnClientOutside: false });
                $('#loading').hide();
            }
        });
    }
    else {
        swal('Error!', 'Scheme not updated.', 'error', { closeOnClientOutside: false });
    }
}
function ResetSchemeDetails() {
    //$("input:checkbox[name=DayNames]").each(function () {
    //    debugger;
    //    $(this).prop('checked', false);
    //});
    $("input:checkbox[name=AllDays]").prop('checked', false).change();
    $('#btnUpdate').hide();
    $('#btnSave').show();
    $('#txtSchemeName').val('');
    $('#ddlSchemeStatus').val('1');
    $('#ddlSKU').val('0').select2();
    $('#txtQuantity').val('1');
    $('#txtSKUUnitPrice').val('0.00');
    $('#txtSchemePrice').val('0.00');
    $('#F_UnitPrice').text(CSymbol + '0.00');
    $('#F_Tax').text(CSymbol + '0.00');
    $('#F_Total').text(CSymbol + '0.00');
    $('#tblSchemeProductListBody').empty();
    $('#txtFromDate').val('');
    $('#txtToDate').val('');
}

function selectAll() {
    debugger;
    if ($("input:checkbox[name=AllDays]").is(':checked')) {
        $("input:checkbox[name=DayNames]").each(function () {
            debugger;
            $(this).prop('checked', true).change();
        });
    }
    else {
        $("input:checkbox[name=DayNames]").each(function () {
            debugger;
            $(this).prop('checked', false).change();
        });
    }

}

//function calc_SchemeValue2() {
//    debugger;
//    var T_Total = 0, Quantity = 0, Subtotal = 0, T_Tax = 0, T_Total, RowWiseTax = 0, RowWiseTotal = 0, UnitP = 0, DiscountedValue = 0;
//    $('#tblSchemeProductListBody tr').each(function () {
//        debugger;
//        RowWiseTax = 0;
//        RowWiseTotal = 0;

//        if (isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val()))) {
//            UnitPrice = 0;
//            $(this).find('.UnitPrice input:eq(0)').val('0.00');
//        }
//        else {
//            UnitPrice = isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitPrice input:eq(0)').val()));
//            $(this).find('.UnitPrice input:eq(0)').val(parseFloat(UnitPrice).toFixed(2));
//        }
//        if (isNaN(parseFloat($(this).find('.Unitprime').text()))) {
//            Unitprime = 0;
//            $(this).find('.Unitprime').text('0.00');
//        }
//        else {
//            Unitprime = isNaN(parseFloat($(this).find('.Unitprime').text())) ? 0 : (parseFloat($(this).find('.Unitprime').text()));

//        }
//        if (isNaN(parseFloat($(this).find('.Quantity').text()))) {
//            Quantity = 0;
//            $(this).find('.Quantity').text('0.00');
//        }
//        else {
//            Quantity = isNaN(parseFloat($(this).find('.Quantity').text())) ? 0 : (parseFloat($(this).find('.Quantity').text()));

//        }
//        //------------Discount Unit Price in Doler--------------------

//        if (($(this).find('.UnitDiscountDL input:eq(0)').val()) == 0) {
//            UnitDiscountDL = 0.00;
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(0.00))
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//        }
//        else if (($(this).find('.UnitDiscountDL input:eq(0)').val()) > Unitprime) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            swal('', 'Discount can not be greater than the Original Unit Price', 'warning');
//        }
//        else {
//            UnitDiscountDL = isNaN(parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val()));
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//        }

//        //------------Discount Unit Price in Percentge -------------

//        if (($(this).find('.UnitDiscount input:eq(0)').val()) == 0) {
//            Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));

//        }
//        else if (($(this).find('.UnitDiscount input:eq(0)').val()) > 100) {
//            Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//            swal('', "Discount percentage can't be greater than 100 %", 'warning');
//        }
//        else {
//            UnitDiscount = isNaN(parseFloat($(this).find('.UnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscount input:eq(0)').val()));

//        }


//        DiscountedValue = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));

//        UnitPrice = parseFloat(Unitprime).toFixed(2) - DiscountedValue;
//        Subtotal = isNaN(parseFloat(UnitPrice * Quantity).toFixed(2)) ? 0 : (parseFloat(UnitPrice * Quantity).toFixed(2));


//        if (isNaN(parseFloat($(this).find('.TaxPer').text()))) {
//            TaxPer = 0;
//            $(this).find('.TaxPer').text('0.00');
//        }
//        else {
//            TaxPer = isNaN(parseFloat($(this).find('.TaxPer').text())) ? 0 : (parseFloat($(this).find('.TaxPer').text()));
//        }
//        RowWiseTax = parseFloat(Subtotal * TaxPer / 100).toFixed(2);
//        RowWiseTotal = parseFloat(Subtotal) + parseFloat(RowWiseTax);

//        $(this).find('.UnitPrice input').val(parseFloat(UnitPrice).toFixed(2));
//        $(this).find('.Tax').text(parseFloat(RowWiseTax).toFixed(2));
//        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));

//        UnitP += UnitPrice;
//        T_Tax = parseFloat(T_Tax) + parseFloat(RowWiseTax);
//        T_Total = parseFloat(T_Total) + parseFloat(RowWiseTotal);
//    });
//    $('#F_UnitPrice').text(CSymbol+ parseFloat(UnitP).toFixed(2));
//    $('#F_Tax').text(CSymbol+ parseFloat(T_Tax).toFixed(2));
//    $('#F_Total').text(CSymbol+ parseFloat(T_Total).toFixed(2));
//    $("#txtSchemePrice").val(parseFloat(T_Total).toFixed(2));
//}
//function calc_SchemeValues2() {
//    debugger;
//    var T_Total = 0, Quantity = 0, Subtotal = 0, T_Tax = 0, T_Total, RowWiseTax = 0, RowWiseTotal = 0, UnitP = 0, DiscountedValue = 0;
//    $('#tblSchemeProductListBody tr').each(function () {
//        debugger;
//        RowWiseTax = 0;
//        RowWiseTotal = 0;

//        if (isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val()))) {
//            UnitPrice = 0;
//            $(this).find('.UnitPrice input:eq(0)').val('0.00');
//        }
//        else {
//            UnitPrice = isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitPrice input:eq(0)').val()));
//            $(this).find('.UnitPrice input:eq(0)').val(parseFloat(UnitPrice).toFixed(2));
//        }
//        if (isNaN(parseFloat($(this).find('.Unitprime').text()))) {
//            Unitprime = 0;
//            $(this).find('.Unitprime').text('0.00');
//        }
//        else {
//            Unitprime = isNaN(parseFloat($(this).find('.Unitprime').text())) ? 0 : (parseFloat($(this).find('.Unitprime').text()));

//        }
//        if (isNaN(parseFloat($(this).find('.Quantity').text()))) {
//            Quantity = 0;
//            $(this).find('.Quantity').text('0.00');
//        }
//        else {
//            Quantity = isNaN(parseFloat($(this).find('.Quantity').text())) ? 0 : (parseFloat($(this).find('.Quantity').text()));

//        }
//        //------------Discount Unit Price in Doler--------------------

//        if (($(this).find('.UnitDiscountDL input:eq(0)').val()) == 0) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            UnitDiscount = (UnitDiscountDL / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));

//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//        }
//        else if (($(this).find('.UnitDiscountDL input:eq(0)').val()) > Unitprime) {
//            UnitDiscountDL = (Unitprime - UnitPrice);
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//            swal('', 'Discount can not be greater than the Unit Price', 'warning');
//        }
//        else {
//            UnitDiscountDL = isNaN(parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscountDL input:eq(0)').val()));

//        }

//        //------------Discount Unit Price in Percentge -------------

//        if (($(this).find('.UnitDiscount input:eq(0)').val()) == 0) {
//            Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = 0.00;
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//        }
//        else if (($(this).find('.UnitDiscount input:eq(0)').val()) > 100) {
//            Diffrenceamount = (Unitprime - UnitPrice);
//            UnitDiscount = (Diffrenceamount / Unitprime * 100);
//            $(this).find('.UnitDiscount input:eq(0)').val(parseFloat(UnitDiscount).toFixed(2));
//            swal('', "Discount percentage can't be greater than 100 %", 'warning');
//        }
//        else {
//            UnitDiscount = isNaN(parseFloat($(this).find('.UnitDiscount input:eq(0)').val())) ? 0 : (parseFloat($(this).find('.UnitDiscount input:eq(0)').val()));
//            UnitDiscountDL = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));
//            $(this).find('.UnitDiscountDL input:eq(0)').val(parseFloat(UnitDiscountDL).toFixed(2));
//        }


//        DiscountedValue = isNaN(parseFloat((Unitprime * UnitDiscount) / 100).toFixed(2)) ? 0 : (parseFloat(Unitprime * (UnitDiscount) / 100).toFixed(2));

//        UnitPrice = parseFloat(Unitprime).toFixed(2) - DiscountedValue;
//        Subtotal = isNaN(parseFloat(UnitPrice * Quantity).toFixed(2)) ? 0 : (parseFloat(UnitPrice * Quantity).toFixed(2));


//        if (isNaN(parseFloat($(this).find('.TaxPer').text()))) {
//            TaxPer = 0;
//            $(this).find('.TaxPer').text('0.00');
//        }
//        else {
//            TaxPer = isNaN(parseFloat($(this).find('.TaxPer').text())) ? 0 : (parseFloat($(this).find('.TaxPer').text()));
//        }
//        RowWiseTax = parseFloat(Subtotal * TaxPer / 100).toFixed(2);
//        RowWiseTotal = parseFloat(Subtotal) + parseFloat(RowWiseTax);

//        $(this).find('.UnitPrice input').val(parseFloat(UnitPrice).toFixed(2));
//        $(this).find('.Tax').text(parseFloat(RowWiseTax).toFixed(2));
//        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));

//        UnitP += UnitPrice;
//        T_Tax = parseFloat(T_Tax) + parseFloat(RowWiseTax);
//        T_Total = parseFloat(T_Total) + parseFloat(RowWiseTotal);
//    });
//    $('#F_UnitPrice').text(CSymbol+ parseFloat(UnitP).toFixed(2));
//    $('#F_Tax').text(CSymbol+ parseFloat(T_Tax).toFixed(2));
//    $('#F_Total').text(CSymbol+ parseFloat(T_Total).toFixed(2));
//    $("#txtSchemePrice").val(parseFloat(T_Total).toFixed(2));
//}
