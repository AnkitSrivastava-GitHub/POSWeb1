var InvoiceAutoId = 0;
$(document).ready(function () {
    SetCurrency();
    Enable();
    BindProduct();
    $('#txtPurchaseDate').css("background-color", "white");
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
    $('.date').val(today);

    $("#txtBarcode").on("keypress", function (e) {
        if (e.key == 'Enter') {
            FillProductByBarcode();
        }
    });

    $("#txtVProductCode").on("keypress", function (e) {
        if (e.key == 'Enter') {
            FillProduct();
        }
    });

    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    InvoiceAutoId = getQueryString('PageId');
    if (InvoiceAutoId != null) {
        editInvoiceDetail(InvoiceAutoId);
    }
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/DirectInvoiceGenerate.aspx/CurrencySymbol",
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

function disable() {
    $("#ddlVendor").attr('disabled', true);
    $("#txtRemark").attr('disabled', true);
    $("#txtInvoiceNo").attr('disabled', true);
    $("#txtBarcode").attr('disabled', true);
    $("#txtVProductCode").attr('disabled', true);
    $("#ddlProduct").attr('disabled', true);
    $("#ddlUnitType").attr('disabled', true);
    $("#txtQuantity").attr('disabled', true);
    $("#txtUnitPrice").attr('disabled', true);
    $("#btnAdd").attr('disabled', true);
    $("#btnReset").attr('disabled', true);
    $("#txtPurchaseDate").attr('disabled', true);
    $("#panel-heading").css("display", "none");
    $("#panel-Body1").css("display", "none");
    $("#panel-Body2").css("display", "none");
    $("#btnReset").hide();
}

function Enable() {
    $("#ddlVendor").removeAttr('disabled', true);
    $("#txtRemark").removeAttr('disabled', true);
    $("#txtInvoiceNo").removeAttr('disabled', true);
    $("#txtBarcode").removeAttr('disabled', true);
    $("#txtVProductCode").removeAttr('disabled', true);
    $("#ddlProduct").removeAttr('disabled', true);
    $("#ddlUnitType").removeAttr('disabled', true);
    $("#txtQuantity").removeAttr('disabled', true);
    $("#txtUnitPrice").removeAttr('disabled', true);
    $("#btnAdd").removeAttr('disabled', true);
    $("#btnReset").removeAttr('disabled', true);
    $("#txtPurchaseDate").removeAttr('disabled', true);
}

function CloseBarcode() {
    $('#txtBarcode').val('');
    $('#txtBarcode').focus();
}

function editInvoiceDetail(InvoiceAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/DirectInvoiceGenerate.aspx/editInvoiceDetail",
        data: "{'InvoiceAutoId':'" + InvoiceAutoId + "'}",
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
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var PODetails = xml.find("Table");
                var InvoiceItemDetails = xml.find("Table1");
                InvoiceAutoId = $(PODetails).find("InvoiceId").text();
                $("#ddlVendor").val($(PODetails).find("VendorAutoId").text()).select2();
                disable();
                $("#txtPurchaseDate").val($(PODetails).find("InvoiceDate").text());
                $("#txtPurchaseDate").css("background-color", "#eee")
                $("#headername").text("Purchase Invoice Details");
                //$("#ddlStatus").val($(PODetails).find("Status").text());
                $("#txtRemark").val($(PODetails).find("Remark").text());
                $("#txtInvoiceNo").val($(PODetails).find("InvoiceNo").text());
                $.each(InvoiceItemDetails, function (index, item) {
                    var TableHtml = '';
                    TableHtml += '<tr>';
                    TableHtml += '<td class="Action" style="width: 50px; text-align: center; display: none;"></td>';  //<a id="deleterow"  title="Remove" onclick="deleterow1(this)"><span class="fa fa-trash" style="color: red;"></span></a>&nbsp;&nbsp;<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" />
                    TableHtml += '<td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('ProductId').text() + '</td>';
                    TableHtml += '<td class="VendorProductCode" style="white-space: nowrap; text-align: center;">' + $(this).find('VendorProductCode').text() + '</td>';
                    TableHtml += '<td class="ProductName" style="white-space: nowrap; text-align: center">' + $(this).find('ProductName').text() + '</td>';
                    TableHtml += '<td class="UnitType" style="white-space: nowrap; text-align: center">' + $(this).find('PackingName').text() + '</td>';
                    TableHtml += '<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('Packingid').text() + '</td>';
                    TableHtml += '<td class="Quantity" style="white-space: nowrap; text-align: center;">' + $(this).find('ReceivedQty').text() + '</td>';
                    TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: right;">' + $(this).find('UnitPrice').text() + '</td>';
                    TableHtml += '<td class="Total" style="white-space: nowrap; text-align: right">0</td>';
                    TableHtml += '<td class="CostPrice" style="white-space: nowrap; text-align: right;">' + $(this).find('CostPrice').text() + '</td>';
                    TableHtml += '<td class="Taxper" style="white-space: nowrap; display: none;">' + $(this).find('TaxPer').text() + '</td>';
                    TableHtml += '<td class="UnitPrice1" style="white-space: nowrap;text-align: right ">' + parseFloat($(this).find('ProductUnitPrice').text()).toFixed(2) + '</td>';
                    TableHtml += '<td class="SecUnitPrice" style="white-space: nowrap; text-align: right">' + parseFloat($(this).find('SecUnitPrice').text()).toFixed(2) + '</td>';
                    TableHtml += '<td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">1</td>';
                    TableHtml += '</tr>';
                    $('#tblPOListBody').prepend(TableHtml);
                });
                calQty();
                $("#btnSave").hide();
                $('.Action').hide();
                $('.F_POTotal').attr('colspan', '3');
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

function BindProduct() {
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/BindProduct",
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
                var List = $.parseJSON(response.d);

                if (List[0].ProductList != null) {
                    debugger;
                    var ProductList = List[0].ProductList;
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
                    $("#ddlProduct").select2();
                    $("#ddlProduct").val(ProVal).change();
                }

                if (List[0].VendorList != null) {
                    debugger;
                    var VendorList = List[0].VendorList;
                    var VType = $("#ddlVendor"); var VenVal = 0;
                    $("#ddlVendor option:not(:first)").remove();
                    for (var k = 0; k < VendorList.length; k++) {
                        var Vendor = VendorList[k];
                        if (Vendor.IsDefault == 1) {
                            VenVal = Vendor.A;
                        }
                        var option = $("<option />");
                        option.html(Vendor.P);
                        option.val(Vendor.A);
                        VType.append(option);
                    }
                    $("#ddlVendor").select2();
                    $("#ddlVendor").val(VenVal).change();
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

function FillCode(e) {
    var text = e.value;
    $("#txtVProductCode").val(text.trim()).change();
}

function FillProduct(e) {
    if ($("#txtVProductCode").val().trim() == '') {

    }
    else {
        //if ($('#ddlVendor').val() == '0') {
        //    toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        //    $('#loading').hide();
        //    return false;
        //}
        var VenderProductCode = $(e).val();
        data = {
            VendorAutoId: $('#ddlVendor').val(),
            VenderProductCode: VenderProductCode
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POMaster.aspx/FillProductByVendor",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No Product found!", "warning", { closeOnClickOutside: false });
                } else if (response.d == "Session") {
                    location.href = '/';
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var ProductList = xml.find("Table");
                    $.each(ProductList, function () {
                        $("#ddlProduct").val($(this).find("AutoId").text()).change();
                    });

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

function FillPrice() {
    if ($("#ddlUnitType").val() == 0) {
        $('#txtCostPrice').val('0.00');
        $('#txtUnitPrice1').val('0.00');
        $('#txtSecUnitPrice').val('0.00');
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/BindUnitPrice",
        data: "{'ProductUnitId':'" + $("#ddlUnitType").val() + "','ProductId':'" + $("#ddlProduct").val() + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger
            if (response.d == 'false') {
                swal("", "No unit details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UnitPriceList = xml.find("Table");
                $.each(UnitPriceList, function () {
                    $("#txtCostPrice").val($(this).find("CostPrice").text());
                    $("#txtUnitPrice1").val($(this).find("SellingPrice").text());
                    $("#txtSecUnitPrice").val($(this).find("SecondaryUnitPrice").text());
                });
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

function BindUnitList() {
    debugger
    $("#ddlUnitType").val('0').change();
    if ($("#ddlUnitType").val() == 0) {
        $('#txtCostPrice').val('0.00');
        $('#txtUnitPrice1').val('0.00');
        $('#txtSecUnitPrice').val('0.00');
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/BindUnitList",
        data: "{'ProductId':'" + $("#ddlProduct").val() + "','VendorId':'" + $('#ddlVendor').val() + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No unit details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UnitList = xml.find("Table");
                var VendorProductCode = xml.find("Table1");
                $("#ddlUnitType option").remove();
                $("#ddlUnitType").append('<option value="0" Taxper="0">Select Unit</option>');
                $.each(UnitList, function () {
                    $("#ddlUnitType").append('<option value="' + $(this).find("AutoId").text() + '" Taxper="' + $(this).find("TaxPer").text() + '">' + $(this).find("PackingName").text() + '</option>');
                });
                if (UnitList.length == 1) {
                    $("#ddlUnitType").prop("selectedIndex", 1).select2();
                }
                else {
                    $("#ddlUnitType").prop("selectedIndex", 0).select2();
                }
                FillPrice();
                if (VendorProductCode.length > 0) {
                    $("#txtVProductCode").val($(VendorProductCode).find('VendorProductCode').text());
                }
                else {
                    $("#txtVProductCode").val('');
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

function AddPoItem() {
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlProduct').val() == '0') {
        toastr.error('Please Select Product.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlUnitType').val() == '0') {
        toastr.error('Please select Unit.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#txtQuantity').val() == '' || parseInt($('#txtQuantity').val()) == 0) {
        toastr.error('Please fill Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtUnitPrice').val() == '' || parseFloat($('#txtUnitPrice').val()) == 0) {
        toastr.error('Please Enter Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtUnitPrice").focus();
        $('#loading').hide();
        return false;
    }
    else if (($('#txtUnitPrice').val()) == '.') {
        toastr.error('Please enter valid Unit Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtUnitPrice").focus();
        $('#loading').hide();
        return false;
    }
    var i = 0;
    $("#tblPOListBody tr").each(function () {
        if (($(this).find('.ProductAutoId').text() == $('#ddlProduct').val()) && ($(this).find('.UnitAutoId').text() == $('#ddlUnitType').val())) {
            $(this).find('.Quantity').text((isNaN(parseInt($(this).find('.Quantity').text())) ? 0 : parseInt($(this).find('.Quantity').text())) + parseInt($('#txtQuantity').val()));
            $(this).find('.UnitPrice').text(parseFloat($('#txtUnitPrice').val()).toFixed(2));
            //$(this).find('.UnitPrice1').text(parseFloat($('#txtUnitPrice1').val()).toFixed(2));
            i += 1;
            calQty();
            ResetPOItem();
        }
    });
    if (i == 0) {
        var VendorProductCode = '';
        $('.Action').show();
        VendorProductCode = $('#txtVProductCode').val();
        var TableHtml = '';
        TableHtml += '<tr>';
        //TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><a id="deleterow"  title="Remove" onclick="deleterow1(this)"><span class="fa fa-trash" style="color: red;"></span></a>&nbsp;&nbsp;<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" /></td>';
        TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" />&nbsp;&nbsp;<a id="deleterow"  title="Remove" onclick="deleterow1(this)"><span class="fa fa-trash" style="color: red;"></span></a></td>';
        TableHtml += '<td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $('#ddlProduct').val() + '</td>';
        TableHtml += '<td class="VendorProductCode" style="white-space: nowrap; text-align: center;">' + VendorProductCode + '</td>';
        TableHtml += '<td class="ProductName" style="white-space: nowrap; text-align: center">' + $('#ddlProduct option:selected').text() + '</td>';
        TableHtml += '<td class="UnitType" style="white-space: nowrap; text-align: center">' + $('#ddlUnitType option:selected').text() + '</td>';
        TableHtml += '<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $('#ddlUnitType').val() + '</td>';
        TableHtml += '<td class="Quantity" style="white-space: nowrap; text-align: center;">' + parseInt($('#txtQuantity').val()) + '</td>';
        TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: right;">' + parseFloat($('#txtUnitPrice').val()).toFixed(2) + '</td>';
        TableHtml += '<td class="Total" style="white-space: nowrap; text-align: right">0</td>';
        TableHtml += '<td class="Taxper" style="white-space: nowrap; display: none;">' + $('#ddlUnitType option:selected').attr('TaxPer') + '</td>';
        TableHtml += '<td class="CostPrice" style="white-space: nowrap; text-align: right">' + $('#txtCostPrice').val() + '</td>';
        TableHtml += '<td class="UnitPrice1" style="white-space: nowrap; text-align: right">' + $('#txtUnitPrice1').val() + '</td>';
        TableHtml += '<td class="SecUnitPrice" style="white-space: nowrap; text-align: right">' + $('#txtSecUnitPrice').val() + '</td>';
        TableHtml += '<td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">1</td>';
        TableHtml += '</tr>';
        $('#tblPOListBody').prepend(TableHtml);
        //$('.F_POTotal').attr('colspan', '4');
        calQty();
        ResetPOItem();
        CloseBarcode();
        //$('#ddlVendor').attr('disabled', 'disabled');
    }

}

function FillProductByBarcode() {
    var Barcode = $('#txtBarcode').val();
    if (Barcode != "") {
        data = {
            Barcode: Barcode,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/POMaster.aspx/FillProductByBarcode",
            data: JSON.stringify({ dataValues: JSON.stringify(data) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No Product found!", "warning", { closeOnClickOutside: false });
                } else if (response.d == "Session") {
                    location.href = '/';
                }
                else {
                    debugger
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var ProductList = xml.find("Table");
                    if (ProductList.length == 1) {
                        $.each(ProductList, function () {
                            $("#ddlProduct").val($(this).find("ProductId").text()).change();
                        });
                        CloseBarcode();
                    }
                    else {
                        $('#spnProductName').text('');
                        $(".UnitList").remove();
                        if (ProductList.length > 1) {
                            var html = "";
                            $.each(ProductList, function () {
                                $('#spnProductName').text($(this).find("ProductName").text());
                                html += '<div class="col-lg-3 UnitList">';
                                html += '<input style="display:none" id="' + $(this).find("UnitID").text() + '" value="' + $(this).find("ProductId").text() + '" />';
                                html += '<input style="height: 20px;width: 20px;" type="radio"  name="UnitList" value="' + $(this).find("UnitID").text() + '" />&nbsp;&nbsp;&nbsp;' +
                                    '<label for= "UnitList" >' + $(this).find("PackingName").text() + '</label>';
                                html += '</div>';
                            });
                            $('.ProductUnit').append(html);
                            $("#ModalProduct").modal("show");
                            $('#txtBarcode').blur(); 
                        }
                        else {
                            swal('Warning', 'Product not found.', 'warning', { timer: 1500, button: false, closeOnClickOutside: true });
                            CloseBarcode();
                            $('#txtBarcode').focus();
                        }
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

function SubmitUnit() {
    if ($('input[name="UnitList"]:checked').length > 0) {
        debugger;
        CloseBarcode();
        var Product = $('input[name="UnitList"]:checked').val();
        var Unit = $('#' + Product + '').val();
        $("#ddlProduct").val(Unit).change();
        $("#ddlUnitType").val(Product).change();
        $("#ModalProduct").modal("hide");
    }
    else {
        CloseBarcode();
        toastr.error('Please Select a unit.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
}

function EditPO(evt) {
    debugger;
    var row = $(evt).parent().parent();
    $('#txtVProductCode').val($(row).find('.VendorProductCode').text());
    $('#ddlProduct').val($(row).find('.ProductAutoId').text()).change().select2();
    $('#ddlUnitType').val($(row).find('.UnitAutoId').text()).change().select2();
    $('#txtQuantity').val($(row).find('.Quantity').text());
    $('#txtUnitPrice').val($(row).find('.UnitPrice').text());

    $('#btnUpdateList').attr('onclick', ' updateProductInTable(' + $(row).index() + ')');
    $('#btnAdd').hide();
    $('#btnUpdateList').show();
}

function updateProductInTable(index) {
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlProduct').val() == '0') {
        toastr.error('Please Select Product.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlUnitType').val() == '0') {
        toastr.error('Please select Unit.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#txtQuantity').val() == '' || parseInt($('#txtQuantity').val()) == 0) {
        toastr.error('Please fill Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtUnitPrice').val() == '' || parseFloat($('#txtUnitPrice').val()) == 0) {
        toastr.error('Please Enter Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtUnitPrice").focus();
        $('#loading').hide();
        return false;
    }
    else if (($('#txtUnitPrice').val()) == '.') {
        toastr.error('Please enter valid Unit Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtUnitPrice").focus();
        $('#loading').hide();
        return false;
    }
    $("#tblPOListBody tr:eq(" + index + ")").remove();
    $('#btnUpdateList').hide();
    $('#btnAdd').show();
    AddPoItem();
}

function ResetPOItem() {
    $('#ddlProduct').val('0').select2();
    $("#ddlUnitType option").remove();
    $("#ddlUnitType").append('<option value="0">Select Unit</option>');
    $('#ddlUnitType').val('0').select2();
    $('#txtQuantity').val('');
    $('#txtCostPrice').val('0.00');
    $('#txtUnitPrice').val('0.00');
    $('#txtVProductCode').val('');
    $('#txtUnitPrice1').val('0.00');
    $('#txtSecUnitPrice').val('0.00');
    CloseBarcode();
}

function calQty() {
    var T_Qty = 0, GrandTotal = 0,i=0;
    $('#tblPOListBody tr').each(function () {
        if ($(this).find('.ActionId').text() != '0') {
            T_Qty += parseInt($(this).find('.Quantity').text());
            $(this).find('.Total').text(parseFloat((isNaN(parseInt($(this).find('.Quantity').text())) ? 0 : parseInt($(this).find('.Quantity').text())) * (isNaN(parseFloat($(this).find('.UnitPrice').text())) ? 0 : parseFloat($(this).find('.UnitPrice').text()))).toFixed(2));
            GrandTotal += (isNaN(parseInt($(this).find('.Quantity').text())) ? 0 : parseInt($(this).find('.Quantity').text())) * (isNaN(parseFloat($(this).find('.UnitPrice').text())) ? 0 : parseFloat($(this).find('.UnitPrice').text()));
        }
        i++;
    });
    $("#RowCount").text(i);
    $('#F_Qty').text(isNaN(T_Qty) ? 0 : T_Qty);
    $('#F_GrandTotal').text((isNaN(parseFloat(GrandTotal).toFixed(2)) ? 0 : parseFloat(GrandTotal).toFixed(2)));
}

function deleterow1(e) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this Product.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
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
            $(e).closest('tr').remove();
            swal('Success!', 'Item deleted successfully.', 'success', { closeOnClickOutside: false });
            calQty();
            ResetPOItem();
            $('#btnAdd').show();
            $('#btnUpdateList').hide();

        }
    })
}

function rollDice() {
    return (Math.floor(100000000 + Math.random() * 900000000));
}

function GenDirectInvoice() {
    $('#loading').show();
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#txtInvoiceNo').val().trim() == '') {
        toastr.error('Please Enter Invoice Number.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtInvoiceNo").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtPurchaseDate').val().trim() == '') {
        toastr.error('Please Enter Purchase Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtPurchaseDate").focus();
        $('#loading').hide();
        return false;
    }
    var RNum = rollDice();
    data = {
        BatchNo: RNum,
        VendorAutoId: $('#ddlVendor').val(),
        InvoiceNo: $('#txtInvoiceNo').val().trim(),
        PurchaseDate: $('#txtPurchaseDate').val(),
        Remark: $('#txtRemark').val().trim(),
    }
    InvoiceItemTable = new Array();
    var i = 0;
    $("#tblPOList #tblPOListBody tr").each(function (index, item) {
        InvoiceItemTable[i] = new Object();
        InvoiceItemTable[i].ProductAutoId = $(item).find('.ProductAutoId').text();
        InvoiceItemTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
        InvoiceItemTable[i].Quantity = $(item).find('.Quantity').text();
        InvoiceItemTable[i].UnitPrice = $(item).find('.UnitPrice').text();
        InvoiceItemTable[i].Taxper = $(item).find('.Taxper').text();
        InvoiceItemTable[i].ProductUnitPrice = parseFloat($(item).find('.UnitPrice1').text());
        InvoiceItemTable[i].SecUnitPrice = parseFloat($(item).find('.SecUnitPrice').text());
        InvoiceItemTable[i].VendorProductCode = $(item).find('.VendorProductCode').text();
        //InvoiceItemTable[i].ActionId = $(item).find('.ActionId').text();
        i++;
    });
    if (InvoiceItemTable.length <= 0) {
        swal("Warning", "Please add atleast 1 Product.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var InvoiceItemTableValues = JSON.stringify(InvoiceItemTable);
    $.ajax({
        type: "POST",
        url: "/Pages/DirectInvoiceGenerate.aspx/GenDirectInvoice",
        data: JSON.stringify({ dataValues: JSON.stringify(data), InvoiceItemTableValues: InvoiceItemTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                Reset();
                debugger;
                swal("Success!", "Invoice generated successfully.", "success", { closeOnClickOutside: false });
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                debugger;
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

function Reset() {
    Enable();
    $('#ddlVendor').val('0').select2();
    $('#ddlProduct').val('0').select2();
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('.Date').val(today);
    $("#ddlUnitType option").remove();
    $("#ddlUnitType").append('<option value="0" Taxper="0">Select Unit</option>');
    $('#ddlUnitType').val('0').select2();
    $('#txtQuantity').val('');
    $('#txtInvoiceNo').val('');
    $('#txtRemark').val('');
    $('#txtUnitPrice').val('0.00');
    $('#txtCostPrice').val('0.00');
    $('#txtUnitPrice1').val('0.00');
    $('#txtSecUnitPrice').val('0.00');
    $('#tblPOListBody').empty();
    $("#btnSave").show();
    $("#btnUpdate").hide();
    calQty();
    CloseBarcode();
}

function UpdateDirectInvoice() {
    $('#loading').show();
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#txtInvoiceNo').val().trim() == '') {
        toastr.error('Please Enter Invoice Number.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtInvoiceNo").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtPurchaseDate').val().trim() == '') {
        toastr.error('Please Enter Purchase Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtPurchaseDate").focus();
        $('#loading').hide();
        return false;
    }
    else if (InvoiceAutoId == 0) {
        $('#loading').hide();
        swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false }).then(function () {
            window.location.href = '/Pages/InvoiceList.aspx';
        });
    }
    data = {
        InvoiceAutoId: InvoiceAutoId,
        VendorAutoId: $('#ddlVendor').val(),
        InvoiceNo: $('#txtInvoiceNo').val().trim(),
        PurchaseDate: $('#txtPurchaseDate').val(),
        Remark: $('#txtRemark').val().trim(),
    }
    InvoiceItemTable = new Array();
    var i = 0;
    $("#tblPOList #tblPOListBody tr").each(function (index, item) {
        InvoiceItemTable[i] = new Object();
        InvoiceItemTable[i].ProductAutoId = $(item).find('.ProductAutoId').text();
        InvoiceItemTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
        InvoiceItemTable[i].Quantity = $(item).find('.Quantity').text();
        InvoiceItemTable[i].UnitPrice = $(item).find('.UnitPrice').text();
        InvoiceItemTable[i].Taxper = $(item).find('.Taxper').text();
        InvoiceItemTable[i].ProductUnitPrice = parseFloat($(item).find('.UnitPrice1').text());
        InvoiceItemTable[i].SecUnitPrice = parseFloat($(item).find('.SecUnitPrice').text());
        InvoiceItemTable[i].VendorProductCode = $(item).find('.VendorProductCode').text();
        //InvoiceItemTable[i].ActionId = $(item).find('.ActionId').text();
        i++;
    });
    if (InvoiceItemTable.length <= 0) {
        swal("Error!", "Please add a invoice item.", "error", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var InvoiceItemTableValues = JSON.stringify(InvoiceItemTable);
    $.ajax({
        type: "POST",
        url: "/Pages/DirectInvoiceGenerate.aspx/UpdateDirectInvoice",
        data: JSON.stringify({ dataValues: JSON.stringify(data), InvoiceItemTableValues: InvoiceItemTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                Reset();
                $('#loading').hide();
                swal("Success!", "Invoice details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                    window.location.href = '/Pages/InvoiceList.aspx';
                });
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
