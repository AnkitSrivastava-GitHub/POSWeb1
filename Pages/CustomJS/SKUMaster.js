var SKUAutoId = 0, SKUProductDeletedIds = '', SKUBarcodeDeletedIds = '';
$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    //BindProduct();

    SKUAutoId = getQueryString('PageId');
    if (SKUAutoId != null) {
        editSKUDetail(SKUAutoId);
    }
    else {
        BindProduct();
    }
  
});


var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/SKUList.aspx/CurrencySymbol",
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

function editSKUDetail(SKUAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/SKUMaster.aspx/editSKUDetail",
        data: "{'SKUAutoId':'" + SKUAutoId + "'}",
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
                var JsonObj = $.parseJSON(response.d);
                var SKUDetails = JsonObj[0].SKUDetails;
                var SKUProductList = JsonObj[0].SKUProductList;
                var SKUBarcodeList = JsonObj[0].SKUBarcodeList;
                var ProductList = JsonObj[0].PL;
                var CurrencySymbol = JsonObj[0].CurrencySymbol;
                CSymbol = CurrencySymbol[0].A;
                $('.symbol').text(CurrencySymbol[0].A);
                if (ProductList != null) {
                    debugger;
                    var PType = $("#ddlProduct"); var ProVal = 0;
                    $("#ddlProduct option:not(:first)").remove();
                    for (var k = 0; k < ProductList.length; k++) {
                        var Product = ProductList[k];
                        if (Product.IsDefault == 1) {
                            ProVal = Product.A;
                        }
                        var option = $("<option />");
                        option.html(Product.B);
                        option.val(Product.A);
                        PType.append(option);
                    }
                    
                }
                $("#ddlProduct").select2();
                
                SKUAutoId = SKUDetails[0].AutoId;
                $("#txtSKUName").val(SKUDetails[0].SKUName);
                $("#ddlStatus").val(SKUDetails[0].Status);
                $("#txtDescription").val(SKUDetails[0].Description);
                if (SKUDetails[0].SKUImagePath != '' && SKUDetails[0].SKUImagePath != null && SKUDetails[0].SKUImagePath != undefined) {
                    $("#imgPath").val(SKUDetails[0].SKUImagePath);
                    $("#imgPreview").attr('src', '/Images/ProductImages/' + SKUDetails[0].SKUImagePath);
                    $('#divimgPreview').show();
                    $('#txtextention').hide();
                }
                $.each(SKUBarcodeList, function (index, item) {
                    var Barcodetable = '';
                    Barcodetable += '<tr>';
                    Barcodetable += '<td class="Action" style="width: 50px;text-align:center"><a id="deleterow" title="Remove" onclick="deleterow1(this, \'' + 'Barcode' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                    Barcodetable += '<td class="BarcodeAutoId" style="white-space: nowrap;display:none;">' + SKUBarcodeList[index].AutoId + '</td>';
                    Barcodetable += '<td class="Barcode" style="white-space: nowrap;text-align:center">' + SKUBarcodeList[index].Barcode + '</td>';
                    Barcodetable += '<td class="ActionId" style="white-space: nowrap;;display:none;">2</td>';//Action id 2 is for update
                    Barcodetable += '</tr>';
                    $("#tblBarcodeListBody").append(Barcodetable);
                });
                $.each(SKUProductList, function (index, item) {
                    var tableHtml = '';
                    tableHtml += '<tr>';
                    tableHtml += '<td class="Action" style="width: 50px;text-align:center"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPacking1(this)" />&nbsp;&nbsp;<a id="deleterow"  title="Remove" onclick="deleterow1(this, \'' + 'Product' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                    tableHtml += '<td class="SKUItemAutoId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].AutoId + '</td>';
                    tableHtml += '<td class="ProductId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].ProductId + '</td>';
                    tableHtml += '<td class="ProductName" style="white-space: nowrap;text-align:center">' + SKUProductList[index].ProductName + '</td>';
                    tableHtml += '<td class="Unit" style="white-space: nowrap;text-align:center">' + SKUProductList[index].PackingName + '</td>';
                    tableHtml += '<td class="UnitAutoId" style="white-space: nowrap;text-align:center;display:none;">' + SKUProductList[index].ProductUnitAutoId + '</td>';
                    tableHtml += '<td class="Quantity" style="white-space: nowrap;text-align:center">' + SKUProductList[index].Quantity + '</td>';
                    tableHtml += '<td class="UnitPrice" style="white-space: nowrap;text-align:right;">' + parseFloat(SKUProductList[index].UnitPrice).toFixed(2) + '</td>';
                    tableHtml += '<td class="TotalDiscount" style="white-space: nowrap;text-align:right">0.00</td>';
                    tableHtml += '<td class="DiscountPer" style="white-space: nowrap;text-align:right">' + parseFloat(SKUProductList[index].DiscountPercentage).toFixed(2) + '</td>';
                    tableHtml += '<td class="Discount" style="white-space: nowrap;text-align:right;display:none">' + parseFloat(SKUProductList[index].Discount).toFixed(2) + '</td>';
                    tableHtml += '<td class="Tax" style="white-space: nowrap;text-align:right">' + parseFloat(SKUProductList[index].Tax).toFixed(2) + '</td>';
                    tableHtml += '<td class="TaxPercentagePerUnit" style="white-space: nowrap;text-align:right;display:none;">' + parseFloat(SKUProductList[index].TaxPercentagePerUnit).toFixed(2) + '</td>';
                    tableHtml += '<td class="TaxAutoId" style="white-space: nowrap;align-content:center;display:none;">' + SKUProductList[index].TaxAutoId + '</td>';
                    tableHtml += '<td class="Total" style="white-space: nowrap;text-align:right;">' + parseFloat(SKUProductList[index].SKUItemTotal).toFixed(2) + '</td>';
                    tableHtml += '<td class="ActionId" style="white-space: nowrap;text-align:right; display: none;">2</td>';
                    tableHtml += ' </tr>';
                    $("#tblProductListBody").append(tableHtml);
                });
                calc_totalFoot();
                $("#btnSave").hide();
                $("#btnUpdate").show();
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



function BindProduct() {
    $.ajax({
        type: "POST",
        url: "/Pages/SKUMaster.aspx/BindProduct",
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

                    var PType = $("#ddlProduct"); var ProVal = 0;
                    $("#ddlProduct option:not(:first)").remove();
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
                    $("#ddlProduct").val(ProVal).change();
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

async function BindUnitList() {
    debugger;
    if ($("#ddlProduct").val() == '0') {
        ResetProduct();
    }
    if (SKUAutoId == null || SKUAutoId == undefined) {
        SKUAutoId = 0;
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SKUMaster.aspx/BindUnitList",
        data: "{'ProductId':'" + $("#ddlProduct").val() + "','SKUAutoId':'" + SKUAutoId + "'}",
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
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UnitList = xml.find("Table");
                $("#ddlProductUnit option").remove();
                $("#ddlProductUnit").append('<option value="0" ProductAutoId="0" CostPrice="0.00" SellingPrice="0.00" TaxAutoId="0" TaxPer="0.00">Select Unit</option>');
                $.each(UnitList, function () {
                    $("#ddlProductUnit").append("<option value='" + $(this).find("AutoId").text() + "' ProductAutoId='" + $(this).find("ProductAutoId").text() + "' CostPrice='" + $(this).find("CostPrice").text() + "' SellingPrice='" + $(this).find("SellingPrice").text() + "' TaxAutoId='" + $(this).find("TaxAutoId").text() + "' TaxPer='" + $(this).find("TaxPer").text() + "'>" + $(this).find("PackingName").text() + "</option>");
                });
                //$("#ddlProductUnit").select2();
                if (UnitList.length == 1) {
                    $("#ddlProductUnit").prop('selectedIndex', 1).select2().change();
                }
                else {
                    $("#ddlProductUnit").select2();
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

function FillProductDetails() {
    debugger;
    $("#txtTotalTax").val($('#ddlProductUnit option:selected').attr('TaxPer'));
    $("#txtTaxPerUnit").val($('#ddlProductUnit option:selected').attr('TaxPer'));
    $("#txtUnitPrice").val($('#ddlProductUnit option:selected').attr('SellingPrice'));
    calculate_total('Amount');
}

function calculate_total(EventId) {

    debugger;
    var sellingPrice = 0, Discount = 0, TaxPerUnit = 0, Total = 0, Quantity = 0, PTotal = 0, PTotalTax = 0, DiscountPercentage = 0;

    if ($('#txtUnitPrice').val().trim() != '') {
        sellingPrice = parseFloat($('#txtUnitPrice').val());
    }
    
    if ($('#txtDiscount').val().trim() != '') {
        Discount = parseFloat($('#txtDiscount').val());
    }
   
    if ($('#txtDiscount').val().trim() != '.') {
        Discount = parseFloat($('#txtDiscount').val());
    }
    
    if ($('#txtDiscountPer').val().trim() != '.') {
        DiscountPercentage = parseFloat($('#txtDiscountPer').val());
    }
    if (DiscountPercentage > 100) {
        DiscountPercentage = 0;
        $('#txtDiscountPer').val('0.00');
        toastr.error("Discount percentage can't be greater than 100%.", 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
   
    if ($('#txtTaxPerUnit').val().trim() != '') {
        TaxPerUnit = parseFloat($('#txtTaxPerUnit').val());//tax is in percentage not in amount
    }
    
    if ($('#txtQuantity').val() != '') {
        Quantity = parseInt($('#txtQuantity').val());
    }
    
    if (sellingPrice < Discount) {
        $('#txtDiscount').val('0.00');
        $('#txtDiscountPer').val('0.00');
        swal('', 'Discount can not be greater than the Unit Price.', 'warning', { closeOnClickOutside: false });
        return false;
    }
    if (EventId == 'Amount') {
        $('#txtDiscountPer').val(parseFloat((Discount * 100) / ((sellingPrice == 0) ? 1 : sellingPrice)).toFixed(2));
        //$('#txtDiscountPer').focus();
    }
    else if (EventId == 'Percentage') {
        $('#txtDiscount').val(parseFloat((sellingPrice * DiscountPercentage) / 100).toFixed(2));
        Discount = isNaN(parseFloat((sellingPrice * DiscountPercentage) / 100)) ? 0 : parseFloat((sellingPrice * DiscountPercentage) / 100);
        //$('#txtDiscount').focus();
    }
    else {
        swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false }).then(function () {
            return false;
        });
        return false;
    }
    PTotal = (sellingPrice - Discount) * Quantity;
    PTotalTax = PTotal * TaxPerUnit;
    PTotalTax = PTotalTax / 100;
    PTotal = PTotal + PTotalTax;
    debugger;
    if (PTotal != undefined && PTotalTax != undefined) {
        $('#txtTotalTax').val(parseFloat(PTotalTax).toFixed(2));
        $('#txtTotal').val(parseFloat(PTotal).toFixed(2));
    }
}

function increaseValueSKU() {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value++;
    $('#txtQuantity').val(value);
    calculate_total('Amount');
}

function ChangeValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 1 : '';
    $('#txtQuantity').val(value);
    calculate_total('Amount');
}

function decreaseValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 2 : '';
    value--;
    $('#txtQuantity').val(value);
    calculate_total('Amount');
}

function deleterow1(e, table) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this " + table + ".",
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
            if (table == "Product") {
                SKUProductDeletedIds += $(e).parent().parent().find(".SKUItemAutoId").text() + ",";
            }
            else if (table == "Barcode") {
                SKUBarcodeDeletedIds += $(e).parent().parent().find(".BarcodeAutoId").text() + ",";
            }
            deleteItemrecord1(e, table);
        }
    })
}

function deleteItemrecord1(e, table) {
    $(e).closest('tr').remove();
    if (table == "Product") {
        calc_totalFoot();
        $('#btnUpdateProduct1').hide();
        $('#btnUpdateProduct').hide();
        $('#btnAddProduct').show();
        ResetProduct();
        swal("", "Product deleted successfully.", "success", { closeOnClickOutside: false });
    }
    else if (table == "Barcode") {
        swal("", "Barcode deleted successfully.", "success", { closeOnClickOutside: false });
    }
}

function AddProductInTable() {
    debugger;
    var validate = 1;
    if ($("#ddlProduct").val() == "0") {
        toastr.error('Please select product.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#ddlProduct").addClass('border-warning');
        validate = 0;
        return false;
    }
    else if ($("#ddlProductUnit").val() == "0") {
        toastr.error('Please select unit.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#ddlProductUnit").addClass('border-warning');
        validate = 0;
        return false;
    }
    else if ($("#txtQuantity").val().trim() == "") {
        toastr.error('Quantity can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").addClass('border-warning');
        validate = 0;
        return false;
    }
    else if ($('#txtDiscount').val().trim() == ".") {
        toastr.error('Please enter valid discount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscount").addClass('border-warning');
        validate = 0;
        return false;
    }
    debugger;
    $("#tblProductListBody tr").each(function () {
        var Disc = 0;
        if ($(this).find('.DiscountPer').text() != "") {
            Disc = parseFloat($(this).find('.DiscountPer').text());
        }
        if (($(this).find('.ProductId').text() == $('#ddlProduct').val()) && ($(this).find('.UnitAutoId').text() == $('#ddlProductUnit').val())
            && (Disc == parseFloat($('#txtDiscountPer').val()))) {
            //swal("", "Product already Exist", "warning", { closeOnClickOutside: false });
            $(this).find('.Quantity').text(parseInt($(this).find('.Quantity').text()) + parseInt($('#txtQuantity').val()));
            calculate_total('Amount');
            validate = 0;
            return false;
        }
       
    });
    if (validate == 1) {
        var Discount = 0, Tax = 0, Total = 0, Quantity = 0, UnitPrice = 0;
        calculate_total('Amount');

        var tableHtml = '';
        tableHtml += '<tr class="tbody">';
        tableHtml += '<td class="Action" style="width: 50px;text-align:center"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPacking(this)" />&nbsp;&nbsp;<a id="deleterow"  title="Remove" onclick="deleterow1(this, \'' + 'Product' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
        tableHtml += '<td class="SKUItemAutoId" style="white-space: nowrap;text-align:center;display:none;">0</td>';
        tableHtml += '<td class="ProductId" style="white-space: nowrap;text-align:center;display:none;">' + $("#ddlProduct").val() + '</td>';
        tableHtml += '<td class="ProductName" style="white-space: nowrap;text-align:center">' + $('#ddlProduct option:selected').text() + '</td>';
        tableHtml += '<td class="Unit" style="white-space: nowrap;text-align:center">' + $('#ddlProductUnit option:selected').text() + '</td>';
        tableHtml += '<td class="UnitAutoId" style="white-space: nowrap;text-align:center;display:none;">' + $('#ddlProductUnit').val() + '</td>';
        tableHtml += '<td class="Quantity" style="white-space: nowrap;text-align:center">' + $("#txtQuantity").val() + '</td>';
        tableHtml += '<td class="UnitPrice" style="white-space: nowrap;text-align:right;">' + /*$('#ddlProductUnit option:selected').attr('SellingPrice')*/ $('#txtUnitPrice').val().trim() + '</td>';
        tableHtml += '<td class="TotalDiscount" style="white-space: nowrap;text-align:right">0.00</td>';
        tableHtml += '<td class="DiscountPer" style="white-space: nowrap;text-align:right">' + $("#txtDiscountPer").val() + '</td>';
        tableHtml += '<td class="Discount" style="white-space: nowrap;text-align:right;display:none;">' + ($("#txtDiscount").val() == '' ? '0.00' : $("#txtDiscount").val()) + '</td>';
        tableHtml += '<td class="Tax" style="white-space: nowrap;text-align:right">' + $("#txtTotalTax").val() + '</td>';
        tableHtml += '<td class="TaxPercentagePerUnit" style="white-space: nowrap;text-align:right;display:none;">' + $("#txtTaxPerUnit").val() + '</td>';
        tableHtml += '<td class="TaxAutoId" style="white-space: nowrap;align-content:center;display:none;">' + $('#ddlProductUnit option:selected').attr('TaxAutoId') + '</td>';
        tableHtml += '<td class="Total" style="white-space: nowrap;text-align:right;">' + $("#txtTotal").val() + '</td>';
        tableHtml += '<td class="ActionId" style="white-space: nowrap;text-align:right;display: none;">1</td>';
        tableHtml += ' </tr>';
        $("#tblProductListBody").prepend(tableHtml);
    }
    calc_totalFoot();
    ResetProduct();
}

function EditPacking(evt) {
    debugger;
    var row = $(evt).parent().parent();
    $('#ddlProduct').val($(row).find('.ProductId').text()).change().select2();
    $('#txtQuantity').val($(row).find('.Quantity').text());
    $('#txtDiscount').val($(row).find('.Discount').text());
    $('#txtDiscountPer').val($(row).find('.DiscountPer').text());
    $('#ddlProductUnit').val($(row).find('.UnitAutoId').text()).change().select2();

    $('#btnUpdateProduct').attr('onclick', ' updateProductInTable(' + $(row).index() + ')');
    $('#btnUpdateProduct1').removeAttr('onclick');
    $('#btnAddProduct').hide();
    $('#btnUpdateProduct1').hide();
    $('#btnUpdateProduct').show();
    calculate_total('Amount');
}


function updateProductInTable(index) {
    $("#tblProductList tbody tr:eq(" + index + ")").remove();
    $('#btnUpdateProduct').hide();
    $('#btnAddProduct').show();
    AddProductInTable();
}

var TempSKUId = '';
function EditPacking1(evt) {
    debugger;
    var row = $(evt).parent().parent();
    $('#ddlProduct').val($(row).find('.ProductId').text()).change().select2();
    $('#txtQuantity').val($(row).find('.Quantity').text());
    /*  $('#txtUnitPrice').val($(row).find('.UnitPrice').text());*/
    $('#txtDiscount').val($(row).find('.Discount').text());
    $('#ddlProductUnit').val($(row).find('.UnitAutoId').text()).select().select2();
    debugger;
    $('#txtUnitPrice').val($(row).find('.UnitPrice').text());
    $('#btnUpdateProduct1').attr('onclick', ' updateProductInTable1(' + $(row).index() + ')');
    TempSKUId = $(row).find(".SKUItemAutoId").text();
    $('#btnAddProduct').hide();
    $('#btnUpdateProduct').hide();
    $('#btnUpdateProduct1').show();
    calculate_total('Amount');
}

function updateProductInTable1(index) {
    SKUProductDeletedIds += TempSKUId + ",";
    $("#tblProductList tbody tr:eq(" + index + ")").remove();
    $('#btnUpdateProduct1').hide();
    $('#btnUpdateProduct').hide();
    $('#btnAddProduct').show();
    AddProductInTable();
}

function ResetProduct() {
    $('#txtQuantity').val('1');
    $('#txtDiscount').val('0.00');
    $('#txtUnitPrice').val('0.00');
    $('#txtTotalTax').val('0.00');
    $('#txtTaxPerUnit').val('0.000');
    $('#txtTotal').val('0.00');
    $("#ddlProduct").val(0).select2();
    $("#ddlProductUnit option").remove();
    $("#ddlProductUnit").append('<option value="0" ProductAutoId="0" CostPrice="0.00" SellingPrice="0.00" TaxAutoId="0" TaxPer="0.00">Select Unit</option>');
    calculate_total('Amount');
}

function AddBarcodeInTable(evt) {
    debugger;
    var validate = 1, i = 0;
    if ($("#txtBarcode").val().trim() == "") {
        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").focus();
        validate = 0;
        $(evt).removeAttr('disabled');
        return false;
    }
    $("#tblBarcodeListBody tr").each(function (index, item) {
        var x = $(item).find('.Barcode').text();
        if (x == $("#txtBarcode").val().trim()) {
            validate = 0;
            IsClicked = 0;
            i++;
        }
        //alert(x);
    });
    if (i > 0) {
        toastr.error('Barcode already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").val('');
        $("#txtBarcode").focus();
        $(evt).removeAttr('disabled');
        return false;
    }

    if (validate == 1) {
        if (SKUAutoId != null) {
            SKUAutoId = SKUAutoId;
        }
        else {
            SKUAutoId = 0;
        }
        $.ajax({
            type: "POST",
            url: "/Pages/SKUMaster.aspx/ValidateBarcode",
            data: "{'Barcode':'" + $("#txtBarcode").val().trim().toUpperCase() + "','SKUId':'" + SKUAutoId + "'}",
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
                if (response.d == 'true') {
                    var Barcodetable = '';
                    Barcodetable += '<tr>';
                    Barcodetable += '<td class="Action" style="width: 50px;text-align:center"><a id="deleterow" title="Remove" onclick="deleterow1(this, \'' + 'Barcode' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                    Barcodetable += '<td class="BarcodeAutoId" style="white-space: nowrap;display:none;">0</td>';
                    Barcodetable += '<td class="Barcode" style="white-space: nowrap;text-align:center">' + $("#txtBarcode").val().trim().toUpperCase() + '</td>';
                    Barcodetable += '<td class="ActionId" style="white-space: nowrap;display:none;">1</td>';
                    Barcodetable += '</tr>';
                    $("#tblBarcodeListBody").append(Barcodetable);
                    $("#txtBarcode").val('');
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    $("#txtBarcode").val('');
                    toastr.error(response.d, 'warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                }
                IsClicked = 0;
                $('#loading').hide();
                $(evt).removeAttr('disabled');
            },
            error: function (err) {
                IsClicked = 0;
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
                $(evt).removeAttr('disabled');
            },
            failure: function (err) {
                IsClicked = 0;
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
                $(evt).removeAttr('disabled');
            }
        });
        return false;
    }
}

function InsertSKU(evt) {
    debugger;
    $('#loading').show();
    var validate = 1, SKUImage = '';
    debugger;
    if ($('#txtSKUName').val().trim() == '') {
        toastr.error('Please enter SKU name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUName").addClass('border-warning');
        $('#loading').hide();
        $(evt).removeAttr('disabled');
        return false;
    }
    SKUProductTable = new Array();
    var i = 0;
    $("#tblProductList #tblProductListBody tr").each(function (index, item) {
        if ($(item).find('.ProductId').text() != '0') {
            SKUProductTable[i] = new Object();
            SKUProductTable[i].SKUItemAutoId = $(item).find('.SKUItemAutoId').text();
            SKUProductTable[i].ProductId = $(item).find('.ProductId').text();
            SKUProductTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
            SKUProductTable[i].Quantity = $(item).find('.Quantity').text();
            SKUProductTable[i].UnitPrice = $(item).find('.UnitPrice').text();
            SKUProductTable[i].Discount = $(item).find('.Discount').text();
            SKUProductTable[i].DiscountPer = $(item).find('.DiscountPer').text().replace('%', '');
            SKUProductTable[i].ActionId = $(item).find('.ActionId').text();
            i++;
        }
    });
    if (SKUProductTable.length <= 0) {
        swal("Warning!", "Please add a product.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        $(evt).removeAttr('disabled');
        return;
    }
    var SKUTableValues = JSON.stringify(SKUProductTable);
    debugger;
    BarcodeTable = new Array();
    var j = 0;
    $("#tblBarcodeList #tblBarcodeListBody tr").each(function (index, item) {
        if ($(item).find('.Barcode').text() != '') {
            BarcodeTable[j] = new Object();
            BarcodeTable[j].BarcodeAutoId = $(item).find('.BarcodeAutoId').text();
            BarcodeTable[j].Barcode = $(item).find('.Barcode').text();
            BarcodeTable[j].ActionId = $(item).find('.ActionId').text();
            j++;
        }
    });
    if (BarcodeTable.length <= 0) {
        swal("Warning!", "Please add a barcode.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        $(evt).removeAttr('disabled');
        return;
    }
    var BarcodeTableValues = JSON.stringify(BarcodeTable);
    debugger;

    var fileUpload = $("#FuSKUImage").get(0);
    if (fileUpload != undefined && fileUpload.value != '' && fileUpload.value != null) {
        var files = fileUpload.files;
        var test = new FormData();
        for (var i = 0; i < files.length; i++) {
            test.append(files[i].name, files[i]);
        }
        $.ajax({
            url: "SKUImageHandler.ashx",
            type: "POST",
            contentType: false,
            processData: false,
            async: false,
            data: test,
            success: function (response) {
                if (response != '') {
                    SKUImage = response;
                }
            },
            error: function (response) {
                $('#loading').hide();
                $(evt).removeAttr('disabled');
                swal("Error!", "Oops! Something went wrong.Please try later.", "error");
                return false;
            }
        });
    }
    else {
        SKUImage = '';
    }

    data = {
        SKUName: $('#txtSKUName').val().trim(),
        Status: $('#ddlStatus').val(),
        Description: $('#txtDescription').val().trim(),
        SKUImage: SKUImage
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SKUMaster.aspx/InsertSKU",
        data: JSON.stringify({ dataValues: JSON.stringify(data), SKUTableValues: SKUTableValues, BarcodeTableValues: BarcodeTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "SKU added successfully.", "success", { closeOnClickOutside: false });
                ResetSKUDetails();
                $(evt).removeAttr('disabled');
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                $(evt).removeAttr('disabled');
                window.location.href = '/Default.aspx'
            }
            else {
                swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
                $('#loading').hide();
                $(evt).removeAttr('disabled');
            }
        },
        failure: function (result) {
            $(evt).removeAttr('disabled');
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        },
        error: function (result) {
            $(evt).removeAttr('disabled');
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function ResetSKUDetails() {
    $('#loading').hide();
    SKUAutoId = 0;
    SKUBarcodeDeletedIds = '';
    SKUProductDeletedIds = '';
    $('#btnUpdate').hide();
    $('#btnSave').show();
    $('#txtSKUName').val('');
    $('#ddlStatus').val('1');
    $('#txtDescription').val('');
    $('#tblBarcodeList tbody').empty();
    $('#tblProductList tbody').empty();
    $('#divimgPreview').show();
    $("#imgPreview").attr('src', '/Images/ProductImages/product.png');
    $("#FuSKUImage").val('');
    $("#imgPath").val('');
    $('#F_Discount').text('0.00');
    $('#F_Tax').text('0.00');
    $('#F_Total').text('0.00');
    ResetProduct();
}

function calc_totalFoot() {
    var Row_T_Discount = 0, DiscountPerUnit = 0, Tax = 0, TaxPercentagePerUnit = 0, RowWiseTotal = 0, Quantity = 0, UnitPrice = 0, T_Discount = 0, T_Tax = 0, T_Total = 0;
    $('#tblProductListBody tr').each(function () {
        debugger;
        UnitPrice = parseFloat($(this).find('.UnitPrice').text());
        Quantity = parseFloat($(this).find('.Quantity').text());
        DiscountPerUnit = parseFloat($(this).find('.Discount').text());
        TaxPercentagePerUnit = parseFloat($(this).find('.TaxPercentagePerUnit').text());
        Row_T_Discount = Quantity * DiscountPerUnit;
        $(this).find('.TotalDiscount').text(parseFloat(Row_T_Discount).toFixed(2));
        Tax = (UnitPrice - DiscountPerUnit) * Quantity;
        Tax = (Tax * TaxPercentagePerUnit) / 100;
        RowWiseTotal = (UnitPrice * Quantity) + Tax - Row_T_Discount;
        $(this).find('.Tax').text(parseFloat(Tax).toFixed(2));
        $(this).find('.Total').text(parseFloat(RowWiseTotal).toFixed(2));
        T_Discount += parseFloat($(this).find('.TotalDiscount').text());
        T_Tax += parseFloat($(this).find('.Tax').text());
        T_Total += parseFloat($(this).find('.Total').text());
    });
    $('#F_Discount').text(CSymbol + parseFloat(T_Discount).toFixed(2));
    $('#F_Tax').text(CSymbol + parseFloat(T_Tax).toFixed(2));
    $('#F_Total').text(CSymbol + parseFloat(T_Total).toFixed(2));
}

var verificationCode = 0;
function UpdateSKU() {
    debugger;
    $('#loading').show();
    var validate = 1;
    var SKUImage = '';
    debugger;

    if ($('#txtSKUName').val().trim() == '') {
        toastr.error('Please enter SKU name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUName").addClass('border-warning');
        $('#loading').hide();
        return false;
    }

    SKUProductTable = new Array();
    var i = 0;
    $("#tblProductList #tblProductListBody tr").each(function (index, item) {
        debugger;
        if ($(item).find('.ProductId').text() != '0') {
            debugger;
            SKUProductTable[i] = new Object();
            SKUProductTable[i].SKUItemAutoId = $(item).find('.SKUItemAutoId').text();
            SKUProductTable[i].ProductId = $(item).find('.ProductId').text();
            SKUProductTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
            SKUProductTable[i].Quantity = $(item).find('.Quantity').text();
            SKUProductTable[i].UnitPrice = $(item).find('.UnitPrice').text();
            SKUProductTable[i].Discount = $(item).find('.Discount').text();
            SKUProductTable[i].DiscountPer = $(item).find('.DiscountPer').text().replace('%', '');
            SKUProductTable[i].ActionId = $(item).find('.ActionId').text();
            i++;
        }
    });
    if (SKUProductTable.length <= 0) {
        swal("Error!", "Please add a product.", "error", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var SKUTableValues = JSON.stringify(SKUProductTable);

    BarcodeTable = new Array();
    var j = 0;
    $("#tblBarcodeList #tblBarcodeListBody tr").each(function (index, item) {
        debugger;
        if ($(item).find('.Barcode').text() != '') {
            debugger;
            BarcodeTable[j] = new Object();
            BarcodeTable[j].BarcodeAutoId = $(item).find('.BarcodeAutoId').text();
            BarcodeTable[j].Barcode = $(item).find('.Barcode').text().toUpperCase();
            BarcodeTable[j].ActionId = $(item).find('.ActionId').text();
            j++;
        }
    });
    if (BarcodeTable.length <= 0) {
        swal("Error!", "Please add a barcode.", "error", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var BarcodeTableValues = JSON.stringify(BarcodeTable);

    var fileUpload = $("#FuSKUImage").get(0);
    if (fileUpload != undefined && fileUpload.value != '' && fileUpload.value != null) {
        var files = fileUpload.files;
        var test = new FormData();
        for (var i = 0; i < files.length; i++) {
            test.append(files[i].name, files[i]);
        }
        $.ajax({
            url: "SKUImageHandler.ashx",
            type: "POST",
            contentType: false,
            processData: false,
            async: false,
            data: test,
            success: function (response) {
                if (response != '') {
                    SKUImage = response;
                }
            },
            error: function (response) {
                $('#loading').hide();
                swal("Error!", "Oops! Something went wrong.Please try later.", "error", { closeOnClientOutside: false });
                return false;
            }
        });
    }
    else {
        //SKUImage = $("#imgPath").val();
        /*SKUImage = '';*/
        if ($('#imgPreview').attr('src') == '') {
            SKUImage = '';
        }
        else {
            if ($('#imgPreview').attr('src') == '../Images/ProductImages/product.png') {
                SKUImage = '';
            }
            else {
                SKUImage = $("#imgPath").val();
            }
        }

    }

    data = {
        SKUAutoId: SKUAutoId,
        SKUProductDeletedIds: SKUProductDeletedIds,
        SKUBarcodeDeletedIds: SKUBarcodeDeletedIds,
        SKUName: $('#txtSKUName').val().trim(),
        Status: $('#ddlStatus').val(),
        SKUImage: SKUImage,
        Description: $('#txtDescription').val().trim(),
        verificationCode: verificationCode,
    }

    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/SKUMaster.aspx/UpdateSKU",
        data: JSON.stringify({ dataValues: JSON.stringify(data), SKUTableValues: SKUTableValues, BarcodeTableValues: BarcodeTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Warning!', 'Some error occured. Please try again.', 'warning', { closeOnClickOutside: false });
                $('#loading').hide();
            }
            else {
                //ResetSKUDetails();
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ResponseMessage = xml.find("Table");
                if ($(ResponseMessage).find('ResponseCode').text() == '0') {
                    var TextString = '';
                    TextString = $(ResponseMessage).find('ResponseMessage').text();
                    TextString += '<br/><br/><b>Do you want to proceed?</b>';
                    var span = document.createElement("span");
                    span.innerHTML = TextString;
                    swal({
                        title: "Confirmation!",
                        content: span,
                        allowOutsideClick: "false",
                        //icon: "warning",
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
                            debugger;
                            verificationCode = 1;
                            UpdateSKU();
                        }
                        else {
                            debugger;
                            verificationCode = 0;
                            window.location.reload();

                        }
                    });
                }
                else if ($(ResponseMessage).find('ResponseCode').text() == '1') {
                    $('#loading').hide();
                    swal("Success!", $(ResponseMessage).find('ResponseMessage').text(), "success", { closeOnClickOutside: false }).then(function (isConfirm) {
                        if (isConfirm) {
                            window.location.reload();
                        }
                    });
                }
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

function LoadImage(input) {
    var flag = false;
    if ($(input).val().trim() != '') {
        var ext = "." + $(input).val().substr($(input).val().lastIndexOf('.') + 1);;
        if ($(input)[0].files[0].size > 10485760) {
            swal("Error!", "Image size must be less than 10MB.", "error", { closeOnClientOutside: false });
            flag = 'false'
            $(input).val('');
            return false;
        }
        var str = '.png,.jpg,.jpeg,.gif,.bmp';
        var strarray = str.split(',');
        for (var i = 0; i < strarray.length; i++) {
            if (strarray[i] == ext.toLowerCase()) {
                flag = 'True'
            }
        }
        if (flag == 'True') {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("#imgPreview").attr("src", e.target.result);
                };
                reader.readAsDataURL(input.files[0]);
                $('#divimgPreview').show();
                $('#txtextention').hide();
            }
        }
        else {
            $(input).val('');
            $("#imgPreview").attr("src", '../Images/ProductImages/product.png');
            $('#divimgPreview').show();
            $('#txtextention').show();
            swal("Error!", "Please select valid file type.", "error", { closeOnClickOutside: false });
            return;
        }
    }
    else {
        $("#imgPreview").attr("src", '../Images/ProductImages/product.png');
        $('#divimgPreview').show();
        $('#txtextention').show();
    }
}