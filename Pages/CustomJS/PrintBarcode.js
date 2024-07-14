$(document).ready(function () {
    SetCurrency();
    BindSKU();
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

function bindEnableField(e) {
    $('#spn_msg').text('');
    if ($(e).val() != 0) {
        $('#ddlProduct').removeAttr('disabled');
        $('#txtQty').removeAttr('disabled');
        $('#Add').removeAttr('disabled');
        if ($(e).val() == 2) {
            $('#spn_msg').text('Add only 12 Digits Barcode Product.');
        }
    }
    else if ($(e).val() == 0) {
        $('#ddlProduct').attr('disabled', 'disabled')
        $('#txtQty').attr('disabled', 'disabled');
        $('#Add').attr('disabled', 'disabled');
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

function deleterecordB(e) {
    debugger
    swal({
        title: "Are you sure?",
        text: "You want to delete this product.",
        icon: "warning",
        showCancelButton: true,
        allowOutsideClick: false,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No, Cancel.",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes, Delete it.",
                value: true,
                visible: true,
                className: "",
                closeModal: true
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            $(e).closest('tr').remove();
            if ($("#tblList tbody tr").length == 0) {
                $('#ddlLabelOption').removeAttr('disabled');
            }
            swal("", "Product deleted successfully.", "success");
        }
    })
}
function AddinList() {
    debugger
    if ($("#ddlProduct").val() == 0 || $("#ddlProduct").val() == '') {
        swal('Warning', 'Please select Product.', 'warning', { closeOnClickOutside: false });
        $("#ddlProduct").addClass('border-warning');
        return;
    }
    if ($("#txtQty").val().trim() == 0 || $("#txtQty").val().trim() == '') {
        swal('Warning', 'Please enter Print Quantity.', 'warning', { closeOnClickOutside: false });
        $("#txtQty").addClass('border-warning');
        return;
    }
    var qty = $("#txtQty").val();
    var ProductId = $("#ddlProduct").val();
    $.ajax({
        type: "POST",
        url: "/Pages/PrintBarcode.aspx/AddinList",
        data: "{'ProductId':'" + ProductId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d != "Session Expired") {
                var xmldoc = $.parseXML(response.d);
                var items = $(xmldoc).find("Table");
                var itemsBar = $(xmldoc).find("Table1");
                $("#emptyTable").hide();
                var cnt = 0;
                if (itemsBar.length > 0) {
                    debugger;
                    if (Number(itemsBar.find("BarcodeCNT").text()) > 1) {
                        debugger;
                        $("#tblBarcode tbody tr").remove();
                        var row = $("#tblBarcode thead tr").clone(true);
                        if (itemsBar.length > 0) {
                            $("#EmptyTable").hide();
                            $.each(items, function (i) {
                                $(".Barcode", row).text($(this).find("Barcode").text());
                                $(".Count", row).text($(this).find("BarcodeCNT").text());
                                $(".Action", row).html('<input type="radio" name="radio" group="radio" onclick="MultiPackingBarcode(\'' + $(this).find("AutoId").text() + '\');"/>');
                                $("#tblBarcode tbody").append(row);
                                row = $("#tblBarcode tbody tr:last").clone(true);
                                if (cnt == 0) {
                                    $("#BarcodeCnt").text($(this).find("BarcodeCNT").text());
                                    cnt++;
                                }
                            });
                            $("#ProductId").text(itemsBar.find("ProductId").text());
                            $("#ProductName").text(itemsBar.find("ProductName").text());
                            $("#showBarcodeModal").modal("show");
                            $("#ddlLabelOption").attr('disabled', true);
                        }
                        else {
                            $("#EmptyTable").show();
                        }
                    }
                    else {
                        debugger;
                        if (items.find("Barcode").text().length < 9 && $('#ddlLabelOption').val() == 2) {
                            swal('Warning', 'Please select only 12 digits of barcode product.', 'warning', { closeOnClickOutside: false });
                        }
                        else {
                            var row = $("#tblSafeCashList thead tr").clone(true);
                            $(".action", row).html("<a id='btnDeleteSafe' onclick='deleterecordB(this)' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                            $(".ProductId", row).text(items.find("ProductId").text());
                            $(".ProductName", row).text(items.find("ProductName").text());
                            $(".Barcode", row).text(items.find("Barcode").text());
                            $(".Qty", row).text(qty);
                            $(".SRP", row).text(items.find("Price").text());
                            if ($('#tblSafeCashList tbody tr').length > 0) {
                                $('#tblSafeCashList tbody tr:first').before(row);
                            }
                            else {
                                $('#tblSafeCashList tbody').append(row);
                            }
                            $("#showBarcodeModal").modal("hide");
                            toastr.success('Product added successfully.', 'success', { closeOnClickOutside: false });
                            $("#btnprint").show();
                            $("#ddlProduct").val(0).change();
                            $("#txtQty").val('');
                            $("#ddlLabelOption").attr('disabled', true);
                        }
                    }
                }
                else {
                    location.reload();
                }
            }
        },
        failure: function (result) {
            swal("Error!", result.d, "error");
        },
        error: function (result) {
            swal("Error!", result.d, "error");
        }
    });
}

function MultiPackingBarcode(ProductId) {
    debugger
    var qty = $("#txtQty").val();
    $.ajax({
        type: "POST",
        url: "/Pages/PrintBarcode.aspx/MultiBarcode",
        data: "{'ProductId':'" + ProductId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger
            if (response.d != "Session Expired") {
                var xmldoc = $.parseXML(response.d);
                var items = $(xmldoc).find("Table");
                $("#emptyTable").hide();
                if (items.length > 0) {
                    if (items.find("Barcode").text().length != 12 && $('#ddlLabelOption').val() == 2) {
                        swal('Warning', 'Please select only 12 digits of barcode product.', 'warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                    }
                    else {
                        var row = $("#tblSafeCashList thead tr").clone(true);
                        $(".action", row).html("<a id='btnDeleteSafe' onclick='deleterecordB(this)' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $(".ProductId", row).text(items.find("ProductId").text());
                        $(".ProductName", row).text(items.find("ProductName").text());
                        $(".Barcode", row).text(items.find("Barcode").text());
                        $(".Qty", row).text(qty);
                        $(".SRP", row).text(items.find("Price").text());
                        if ($('#tblSafeCashList tbody tr').length > 0) {
                            $('#tblSafeCashList tbody tr:first').before(row);
                        }
                        else {
                            $('#tblSafeCashList tbody').append(row);
                        }
                        $("#showBarcodeModal").modal("hide");
                        toastr.success('Product added successfully.', 'success', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                        $("#btnprint").show();
                        $("#ddlProduct").val(0).change();
                        $("#txtQty").val('');
                    }
                }
                else {
                    location.reload();
                }
            }
        },
        failure: function (result) {
            swal("Error!", result.d, "error");
        },
        error: function (result) {
            swal("Error!", result.d, "error");
        }
    });
}
function printtemplate() {
    Print();
}
function Print() {
    debugger;
    if ($('#tblSafeCashList tbody tr').length > 0) {
        var BarcodeDetails = [];
        $("#tblSafeCashList tbody tr").each(function (i) {

            BarcodeDetails.push({
                'ProductId': $(this).find('.ProductId').text(),
                'ProductName': $(this).find('.ProductName').text(),
                'Barcode': $(this).find('.Barcode').text(),
                'Qty': $(this).find('.Qty').text()
            });

        });
        localStorage.setItem('BarcodeDetails', JSON.stringify(BarcodeDetails));

        if ($("#ddlLabelOption").val() == '1') {
            $('#PopPrintTemplate').modal('hide');
            window.open("/Pages/Barcode/Barcode2.html", "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
        }
        else if ($("#ddlLabelOption").val() == '2') {
            $('#PopPrintTemplate').modal('hide');
            window.open("/Pages/Barcode/Barcode3.html", "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
        }
        else if ($("#ddlLabelOption").val() == '3') {
            $('#PopPrintTemplate').modal('hide');
            window.open("/Pages/Barcode/Barcode4.html", "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
        }

    }
    else {
        swal('Warning', 'No items Added into the Table.', 'warning', { positionClass: 'toast-top-center', containerId: 'toast-top-right' });
    }
}

function resetField() {
    $("#ddlLabelOption").val(0).change();
    $("#ddlProduct").val(0).change();
    $("#txtQty").val('');
    $("#ddlLabelOption").removeAttr('disabled', 'disabled');
    $('#ddlProduct').attr('disabled', 'disabled');
    $('#txtQty').attr('disabled', 'disabled');
    $('#Add').attr('disabled', 'disabled');
    $("#tblSafeCashList tbody tr").remove();
    $('#btnprint').hide();
}