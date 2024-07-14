var POAutoId = 0;
$(document).ready(function () {
    SetCurrency();
    BindProduct();
    $('#txtDate').css("background-color", "white");
    $('#txtDate').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        minDate: 0
    });
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('#txtDate').val(today);

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
    POAutoId = getQueryString('PageId');
    if (POAutoId != null) {
        editPODetail(POAutoId);
    }
});

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
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function editPODetail(POAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/editPODetail",
        data: "{'POAutoId':'" + POAutoId + "'}",
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
                var POItemDetails = xml.find("Table1");
                POAutoId = $(PODetails).find("AutoId").text();
                $("#ddlVendor").val($(PODetails).find("VendorId").text()).select2();
                $("#txtDate").val($(PODetails).find("PoDate").text());
                $("#txtRemark").val($(PODetails).find("Remark").text());
                $.each(POItemDetails, function (index, item) {
                    var TableHtml = '';
                    TableHtml += '<tr>';
                    if ($(PODetails).find("Status").text() == '2') {
                        TableHtml += '<td class="Action" style="width: 50px; text-align: center;"></td>';
                    }
                    else {
                        //TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><a id="deleterow"  title="Remove" onclick="deleterow11(this)"><span class="fa fa-trash" style="color: red;"></span></a>&nbsp;&nbsp;<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" /></td>';
                        TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" />&nbsp;&nbsp;<a id="deleterow"  title="Remove" onclick="deleterow11(this)"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                    }
                    TableHtml += '<td class="PoItemAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('AutoId').text() + '</td>';
                    TableHtml += '<td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('ProductId').text() + '</td>';
                    TableHtml += '<td class="VendorProductCode" style="white-space: nowrap; text-align: center;">' + $(this).find('VendorProductCode').text() + '</td>';
                    TableHtml += '<td class="ProductName" style="white-space: nowrap; text-align: center">' + $(this).find('ProductName').text() + '</td>';
                    TableHtml += '<td class="UnitType" style="white-space: nowrap; text-align: center">' + $(this).find('PackingName').text() + '</td>';
                    TableHtml += '<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('PackingId').text() + '</td>';
                    TableHtml += '<td class="Quantity" style="white-space: nowrap; text-align: center">' + $(this).find('RequiredQty').text() + '</td>';
                    TableHtml += '<td class="CostPrice" style="white-space: nowrap; text-align: right">' + $(this).find('CostPrice').text() + '</td>';
                    TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: right">' + $(this).find('UnitPrice').text() + '</td>';
                    TableHtml += '<td class="SecUnitPrice" style="white-space: nowrap; text-align: right">' + $(this).find('SecUnitPrice').text() + '</td>';
                    TableHtml += '<td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">2</td>';
                    TableHtml += '</tr>';
                    $('#tblPOListBody').prepend(TableHtml);
                });
                calQty();
                ResetPOItem();
                //$("#btnSave").hide();
                //$("#btnUpdate").show();  PIMAutoId
            }
            if ($(PODetails).find("Status").text() == '2' && $(PODetails).find("PIMAutoId").text() != 0) {
                $("#ddlStatus").val('1');
                $("#ddlVendor").attr('disabled', 'disabled');
                $("#txtDate").attr('disabled', 'disabled');
                $('#txtDate').css("background-color", "#eee");
                $("#txtRemark").attr('disabled', 'disabled');
                $("#ddlStatus").attr('disabled', 'disabled');
                $("#ddlProduct").attr('disabled', 'disabled');
                $("#ddlUnitType").attr('disabled', 'disabled');
                $("#txtQuantity").attr('disabled', 'disabled');
                $("#txtBarcode").attr('disabled', 'disabled');
                $("#txtVProductCode").attr('disabled', 'disabled');

                $('#headingfirst').css("display", "none");
                $('#firstform').css("display", "none");
                $('#firstform2').css("display", "none");



                $("#btnAdd").attr('disabled', 'disabled');
                $("#btnSave").hide();
                $("#btnUpdate").hide();
                $("#btnInvGenerated").show();
                $("#btnInvGenerated").hide();
                $("#btnReset").hide();
                $("#btnInvGenerated").attr('disabled', 'disabled');
                $("#btnReset").attr('disabled', 'disabled');
                $('.Action').hide();
                $(".F_POTotal").removeAttr('colspan', '4');
                $(".F_POTotal").attr('colspan', '3');
            }
            else if ($(PODetails).find("Status").text() == '1' && $(PODetails).find("PIMAutoId").text() != 0) {
                $("#ddlStatus").val('1');
                $("#ddlVendor").attr('disabled', 'disabled');
                $("#txtDate").attr('disabled', 'disabled');
                $('#txtDate').css("background-color", "#eee");
                $("#txtRemark").attr('disabled', 'disabled');
                $("#ddlStatus").attr('disabled', 'disabled');
                $("#ddlProduct").attr('disabled', 'disabled');
                $("#ddlUnitType").attr('disabled', 'disabled');
                $("#txtQuantity").attr('disabled', 'disabled');
                $("#txtBarcode").attr('disabled', 'disabled');
                $("#txtVProductCode").attr('disabled', 'disabled');

                $('#headingfirst').css("display", "none");
                $('#firstform').css("display", "none");
                $('#firstform2').css("display", "none");



                $("#btnAdd").attr('disabled', 'disabled');
                $("#btnSave").hide();
                $("#btnUpdate").hide();
                $("#btnInvGenerated").show();
                $("#btnInvGenerated").hide();
                $("#btnReset").hide();
                $("#btnInvGenerated").attr('disabled', 'disabled');
                $("#btnReset").attr('disabled', 'disabled');
                $('.Action').hide();
                $(".F_POTotal").removeAttr('colspan', '4');
                $(".F_POTotal").attr('colspan', '3');
            }
            else {
                $("#ddlStatus").val($(PODetails).find("Status").text());
                $("#btnSave").hide();
                $("#btnUpdate").show();
                $("#btnInvGenerated").hide();
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

function deleterow11(evt) {
    swal({
        title: "Are you sure?",
        text: "You want to delete Product.",
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
            a = $(evt).parent().parent();
            //$(a).find('.ActionId').text('0');
            $(a).remove();
            //$(a).hide();
            calQty();
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

function BindUnitList() {
    debugger;
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
                debugger;
                $("#ddlUnitType option").remove();
                $("#ddlUnitType").append('<option value="0">Select Unit</option>');
                $.each(UnitList, function () {
                    $("#ddlUnitType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("PackingName").text()));
                });
                //$("#ddlUnitType").select2();
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
function FillCode(e) {
    var text = e.value;
    $("#txtVProductCode").val(text.trim()).change();
}

function FillProduct(e) {
    if ($("#txtVProductCode").val().trim()=='') {

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

function FillProductByBarcode() {
    debugger
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
                            CloseBarcode();
                            swal('Warning', 'Product not found.', 'warning', { timer: 1500, button: false, closeOnClickOutside: true });
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

function CloseBarcode() {
    $('#txtBarcode').val('');
    $('#txtBarcode').focus();
}

function SubmitUnit() {
    debugger;
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
        $("#txtQuantity").addClass('border-warning');
        $('#loading').hide();
        return false;
    }
    var i = 0;
    $("#tblPOListBody tr").each(function () {
        if (($(this).find('.ProductAutoId').text() == $('#ddlProduct').val()) && ($(this).find('.UnitAutoId').text() == $('#ddlUnitType').val())) {
            $(this).find('.Quantity').text((isNaN(parseInt($(this).find('.Quantity').text())) ? 0 : parseInt($(this).find('.Quantity').text())) + parseInt($('#txtQuantity').val()));
            /* $(this).find('.UnitPrice').text(parseFloat($('#txtUnitPrice').val()).toFixed(2));*/
            i += 1;
            calQty();
            ResetPOItem();
        }
    });
    if (i == 0) {
        var VendorProductCode = '';
        VendorProductCode = $('#txtVProductCode').val();
        var TableHtml = '';
        TableHtml += '<tr>';
        //TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><a id="deleterow"  title="Remove" onclick="deleterow1(this)"><span class="fa fa-trash" style="color: red;"></span></a>&nbsp;&nbsp;<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" /></td>';
        TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditPO(this)" />&nbsp;&nbsp;<a id="deleterow"  title="Remove" onclick="deleterow1(this)"><span class="fa fa-trash" style="color: red;"></span></a></td>';
        TableHtml += '<td class="PoItemAutoId" style="white-space: nowrap; text-align: center; display: none;">0</td>';
        TableHtml += '<td class="VendorProductCode" style="white-space: nowrap; text-align: center;">' + VendorProductCode + '</td>';
        TableHtml += '<td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $('#ddlProduct').val() + '</td>';
        TableHtml += '<td class="ProductName" style="white-space: nowrap; text-align: center">' + $('#ddlProduct option:selected').text() + '</td>';
        TableHtml += '<td class="UnitType" style="white-space: nowrap; text-align: center">' + $('#ddlUnitType option:selected').text() + '</td>';
        TableHtml += '<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $('#ddlUnitType').val() + '</td>';
        TableHtml += '<td class="Quantity" style="white-space: nowrap; text-align: center">' + parseInt($('#txtQuantity').val()) + '</td>';
        TableHtml += '<td class="CostPrice" style="white-space: nowrap; text-align: right">' + $('#txtCostPrice').val() + '</td>';
        TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: right">' + $('#txtUnitPrice1').val() + '</td>';
        TableHtml += '<td class="SecUnitPrice" style="white-space: nowrap; text-align: right">' + $('#txtSecUnitPrice').val() + '</td>';
        TableHtml += '<td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">1</td>';
        TableHtml += '</tr>';
        $('#tblPOListBody').prepend(TableHtml);
        calQty();
        ResetPOItem();
        $('#ddlVendor').attr('disabled', 'disabled');
        CloseBarcode();
    }
}

function EditPO(evt) {
    debugger;
    var row = $(evt).parent().parent();
    $('#txtVProductCode').val($(row).find('.VendorProductCode').text());
    $('#ddlProduct').val($(row).find('.ProductAutoId').text()).change().select2();
    $('#ddlUnitType').val($(row).find('.UnitAutoId').text()).change().select2();
    $('#txtQuantity').val($(row).find('.Quantity').text());

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
        $("#txtQuantity").addClass('border-warning');
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
    $('#txtUnitPrice1').val('0.00');
    $('#txtSecUnitPrice').val('0.00');
    $('#txtVProductCode').val('');
    $('#txtBarcode').val('');
    $('#ddlVendor').removeAttr('disabled', 'disabled');
}

function calQty() {
    var T_Qty = 0,i=0;
    $('#tblPOListBody tr').each(function () {
        if ($(this).find('.ActionId').text() != '0') {
            T_Qty += parseInt($(this).find('.Quantity').text());
        }
        i++;
    });
    $("#RowCount").text(i);
    $('#F_Qty').text(isNaN(T_Qty) ? 0 : T_Qty);
}

function deleterow1(e) {
    swal({
        title: "Are you sure?",
        text: "You want to delete Product.",
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
            $(e).closest('tr').remove();
            swal('Success!', 'PO Items deleted successfully.', 'success', { closeOnClickOutside: false });
            calQty();
            ResetPOItem();
            $('#btnAdd').show();
            $('#btnUpdateList').hide();


        }
    })
}

function InsertPO() {
    $('#loading').show();
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    if ($('#txtDate').val() == '') {
        toastr.error('Please Select PO Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    data = {
        VendorAutoId: $('#ddlVendor').val(),
        PoDate: $('#txtDate').val(),
        Status: $('#ddlStatus').val(),
        Remark: $('#txtRemark').val().trim(),
    }
    PoItemTable = new Array();
    var i = 0;
    $("#tblPOList #tblPOListBody tr").each(function (index, item) {
        PoItemTable[i] = new Object();
        PoItemTable[i].POItemAutoId = $(item).find('.PoItemAutoId').text();
        PoItemTable[i].ProductAutoId = $(item).find('.ProductAutoId').text();
        PoItemTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
        PoItemTable[i].Quantity = $(item).find('.Quantity').text();
        PoItemTable[i].ActionId = $(item).find('.ActionId').text();
        PoItemTable[i].UnitPrice = parseFloat($(item).find('.UnitPrice').text());
        PoItemTable[i].SecUnitPrice = parseFloat($(item).find('.SecUnitPrice').text());
        PoItemTable[i].VendorProductCode = $(item).find('.VendorProductCode').text();
        i++;
    });
    if (PoItemTable.length <= 0) {
        swal("Warning", "Please add a PO Item.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var PoItemTableValues = JSON.stringify(PoItemTable);
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/InsertPO",
        data: JSON.stringify({ dataValues: JSON.stringify(data), PoItemTableValues: PoItemTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                ResetPO();
                swal("Success!", "PO created successfully.", "success", { closeOnClickOutside: false });
                $('#loading').hide();
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
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        },
        error: function (result) {
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function ResetPO() {
    $('#ddlVendor').val('0').select2();
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('#txtDate').val(today);
    $('#ddlStatus').val('1');
    $('#txtRemark').val('');
    $('#ddlProduct').val('0').select2();
    $("#ddlUnitType option").remove();
    $("#ddlVendor").removeAttr('disabled');
    $("#txtDate").removeAttr('disabled');
    $("#txtRemark").removeAttr('disabled');
    $("#ddlStatus").removeAttr('disabled');
    $("#ddlProduct").removeAttr('disabled');
    $("#ddlUnitType").removeAttr('disabled');
    $("#txtQuantity").removeAttr('disabled');
    $("#btnAdd").removeAttr('disabled');
    $("#ddlUnitType").append('<option value="0">Select Unit</option>');
    $('#ddlUnitType').val('0').select2();
    $('#txtQuantity').val('');
    $('#txtUnitPrice1').val('');
    $('#txtSecUnitPrice').val('');
    $('#txtVProductCode').val('');
    $('#btnUpdate').hide();
    $('#btnInvGenerated').hide();
    $('#btnSave').show();
    $('#tblPOListBody').empty();
    calQty();
}

function UpdatePO() {
    debugger;
    $('#loading').show();
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    if ($('#txtDate').val() == '') {
        toastr.error('Please Select PO Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    data = {
        POAutoId: POAutoId,
        VendorAutoId: $('#ddlVendor').val(),
        PoDate: $('#txtDate').val(),
        Status: $('#ddlStatus').val(),
        Remark: $('#txtRemark').val().trim(),
    }
    PoItemTable = new Array();
    var i = 0, j = 0;
    $("#tblPOList #tblPOListBody tr").each(function (index, item) {
        PoItemTable[i] = new Object();
        PoItemTable[i].POItemAutoId = $(item).find('.PoItemAutoId').text();
        PoItemTable[i].ProductAutoId = $(item).find('.ProductAutoId').text();
        PoItemTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
        PoItemTable[i].Quantity = $(item).find('.Quantity').text();
        PoItemTable[i].ActionId = $(item).find('.ActionId').text();
        PoItemTable[i].UnitPrice = parseFloat($(item).find('.UnitPrice').text());
        PoItemTable[i].SecUnitPrice = parseFloat($(item).find('.SecUnitPrice').text());
        PoItemTable[i].VendorProductCode = $(item).find('.VendorProductCode').text();
        if ($(item).find('.ActionId').text() != '0') {
            j++;
        }
        i++;
    });
    if (PoItemTable.length <= 0 || j == 0) {
        swal("Error!", "Please add a PO Item.", "error", { closeOnClickOutside: false });
        $('#loading').hide();
        return;
    }
    var PoItemTableValues = JSON.stringify(PoItemTable);
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/UpdatePO",
        data: JSON.stringify({ dataValues: JSON.stringify(data), PoItemTableValues: PoItemTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                ResetPO();
                swal("Success!", "PO Item details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                    window.location.href = '/Pages/POList.aspx';
                });;
                $('#loading').hide();
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
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        },
        error: function (result) {
            swal('Error!', response.d, 'error', { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}
