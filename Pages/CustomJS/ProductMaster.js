$(document).ready(function () {
    SetCurrency();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    UserAutoId = getQueryString('PageId');
    if (UserAutoId != null) {
        editProductDetail(UserAutoId);
    }
    else {
        BindDropDowns();
        $("#hdnProductId").val('0');
    }
    ManageStock();
    BindStoreList();
    $("#ddlStatus").select2();
    $("#ddlWebAvailability").select2();
    $("#ddlManageStock").select2();
    $("#ddlStatuspacking").select2();
    $("#ddltax").select2();
});
var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/CurrencySymbol",
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

function process(input) {
    let value = input.value;
    let numbers = value.replace(/[^0-9\.]/g, '');
    input.value = numbers;
}

function IsDuplicateBarcode() {
    debugger;
    $('#loading').show();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    UserAutoId = getQueryString('PageId');
    if (UserAutoId != null) {
        data = {
            ProductAutoId: UserAutoId,
            Barcode: $("#txtBarcode").val().trim(),
        }
    }
    else {
        data = {
            ProductAutoId: 0,
            Barcode: $("#txtBarcode").val().trim(),
        }
    }
    debugger;

    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/ValidateBarcode",
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
            if (response.d == 'true') {
                $('#loading').hide();
                $('#btnAddBarcode').removeAttr('disabled');
                debugger;
                if (UserAutoId != null) {
                    AddBarcodeInDB();
                }
                else {
                    AddBarcodeInTable();
                }
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                $('#btnAddBarcode').removeAttr('disabled');
                window.location.href = '/Default.aspx'
            }
            else {
                $('#loading').hide();
                $("#txtBarcode").val('');
                toastr.error(response.d, 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                $('#btnAddBarcode').removeAttr('disabled');
                $("#txtBarcode").focus();

            }
            $('#loading').hide();
            $('#btnAddBarcode').removeAttr('disabled');
        },
        error: function (err) {
            $('#btnAddBarcode').removeAttr('disabled');
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            $('#btnAddBarcode').removeAttr('disabled');
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/ProductMaster.aspx/BindDropDowns",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
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
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClientOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Category = xml.find("Table");
                var Brand = xml.find("Table1");
                var Tax = xml.find("Table2");
                var AgeRestriction = xml.find("Table3");
                var Department = xml.find("Table4");
                var VendorList = xml.find("Table5");
                var ProductGroupList = xml.find("Table6");
                var MeasurementUnitList = xml.find("Table7");

                $("#ddlDept option").remove();
                $.each(Department, function () {
                    $("#ddlDept").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text().trim()));
                });
                $("#ddlDept").select2();


                $("#ddlbrand option").remove();
                $.each(Brand, function () {
                    $("#ddlbrand").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("BrandName").text().trim()));
                });
                var Brandtext = 'Other Brand';
                $("#ddlbrand option:contains(" + Brandtext + ")").attr("selected", true);
                $("#ddlbrand").select2();

                $("#ddlcategory option").remove();
                $.each(Category, function () {
                    $("#ddlcategory").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CategoryName").text().trim()));
                });
                var Cattext = 'Other Category';
                $("#ddlcategory option:contains(" + Cattext + ")").attr("selected", true);
                $("#ddlcategory").select2();

                $("#ddltax option").remove();
                $.each(Tax, function () {
                    $("#ddltax").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TaxName").text().trim()));
                });

                $("#ddlAgeRestriction option").remove();
                $.each(AgeRestriction, function () {
                    $("#ddlAgeRestriction").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("AgeRestrictionName").text().trim()));
                });
                var AgeText = 'No Age Restriction';
                $("#ddlAgeRestriction option:contains(" + AgeText + ")").attr("selected", true);
                $("#ddlAgeRestriction").select2();

                $("#ddlVendor option").remove();
                debugger;
                $("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $.each(VendorList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text().trim()));
                });
                //var text1 = 'Other Vendor';
                //$("#ddlVendor option:contains(" + text1 + ")").attr("selected", true);
                $("#ddlVendor").select2();
                debugger;
                $("#ddlGroup option").remove();
                $("#ddlGroup").append('<option value="0">New Group</option>');
                $.each(ProductGroupList, function () {
                    $("#ddlGroup").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("GroupName").text().trim()));
                });
                $("#ddlGroup").select2();

                $.each(MeasurementUnitList, function () {
                    $("#ddlMeasureUnit").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UnitName").text().trim()));
                });
                //var text12 = 'ML';
                //$("#ddlMeasureUnit option:contains(" + text12 + ")").attr("selected", true);
                $("#ddlMeasureUnit").val('1').select2();

                $('#loading').hide();
            }
        },
        failure: function (response) {
            alert(response.d);
            $('#loading').hide();
        },
        error: function (response) {
            alert(response.d);
            $('#loading').hide();
        }
    });
}

function Reset() {
    if ($("#hdnProductId").val() == '0') {
        $("#ddlbrand").val(1).select2();
        $("#ddlcategory").val(1).select2();
        $("#txtProductName").val('');
        $("#txtProductSize").val('');
        $("#ddlDept").val('1').select2();
        $("#txtDescription").val('');
        $("#filePhoto").val('');
        $("#txtInStock").val('0');
        $("#txtLowStock").val('0');
        $("#ddltax").val('1').select2();
        $("#ddlMeasureUnit").val('1').select2();
        $("#imgPreview").attr('src', '../Images/ProductImages/product.png');
        $("#ddlAgeRestriction").val(1).select2();
        $("#tblVendorProductList tbody tr").remove();
        $("#tblBarcodeList tbody tr").remove();
        VendorProductReset();
        BindStoreList();
        $("#ddlStatus").val(1);
        ResetPacking();
        $("#ddlManageStock").val('0').select2().change();
        $("#tblExpensesList tbody tr").remove();
        $("#btnSave").show();
        $("#btnUpdate").hide();
        $("#divupdate").hide();
        $("#btnAddPacking").hide();
        $("#btnUpdatePacking").hide();
        $("#btnInsertPacking").show();
        $("#EmptyTable").hide();
        $("#tblPackingList tbody tr").remove();
    }
    else {
        window.location.href = '/Pages/ProductMaster.aspx'
    }

}

function readURL(input) {
    debugger;
    var flag = false;
    if ($(input).val() != '' && $(input).val() != 'NaN' && $(input).val() != 'undefined') {
        var ext = "." + $(input).val().substr($(input).val().lastIndexOf('.') + 1);;
        var str = '.png,.jpg,.jpeg,.bmp';
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
                    $('#imgPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        else {
            swal("Error!", "Please select valid file type.", "error", { closeOnClickOutside: false });
            $('#imgPreview').attr('src', '../Images/ProductImages/product.png');
            $(input).val('');
            return;
        }
    }
    else {
        $('#imgPreview').attr('src', '../Images/ProductImages/product.png');
        $(input).val('');
    }
}
function readURL1(input) {
    debugger;
    var flag = false;
    if ($(input).val() != '' && $(input).val() != 'NaN' && $(input).val() != 'undefined') {
        var ext = "." + $(input).val().substr($(input).val().lastIndexOf('.') + 1);;
        var str = '.png,.jpg,.jpeg,.bmp';
        var strarray = str.split(',');
        for (var i = 0; i < strarray.length; i++) {
            if (strarray[i] == ext.toLowerCase()) {
                flag = 'True'
            }
        }
        debugger;
        if (flag == 'True') {
            if (input.files && input.files[0]) {
                debugger;
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#PackingimgPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        else {
            swal("Error!", "Please select valid file type.", "error", { closeOnClickOutside: false });
            $('#PackingimgPreview').attr('src', '../Images/ProductImages/product.png');
            $(input).val('');
            return;
        }
    }
    else {
        $('#PackingimgPreview').attr('src', '../Images/ProductImages/product.png');
        $(input).val('');
    }
}

function IsValidInteger(e) {
    if ($(e).val().trim() == '') {
        $(e).val(0)
        $(e).focus();
    }
}

function IsValidDecimal(e) {
    if ($(e).val().trim() == '') {
        $(e).val('0.00')
        $(e).focus();
    }
}

function ManageStock() {
    if ($("#ddlManageStock").val() == 1) {
        $(".ManageStock").show();
    }
    else {
        $(".ManageStock").hide();
    }
}


function InsertPacking() {

    $('#loading').show();
    var validate = 1, i = 0, j = 0;
    //if ($("#txtPackingName").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Packing Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}

    if ($("#txtNoOfPieces").val().trim() == '' || parseInt($("#txtNoOfPieces").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('No. of Pieces Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    //if ($("#txtbarcode").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Barcode Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    //if ($("#txtCostPrice").val().trim() == '.') {
    //    $('#loading').hide();
    //    toastr.error('Please enter valid Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if (parseFloat($("#txtSellingPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSellingPrice").val().trim() == '.') {
        $('#loading').hide();
        toastr.error('Please enter valid Unit Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSecondaryUnitPrice").val().trim() == '' || parseFloat($("#txtSecondaryUnitPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Secondary Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    $("#tblPackingList tr").each(function (item, index) {
        var x = $(index).find('.NoOfPieces').text();
        if (parseInt(x) == parseInt($("#txtNoOfPieces").val().trim())) {
            validate = 0;
            i++;
        }
        //var y = $(index).find('.Barcode').text();
        //if (y == $("#txtbarcode").val().trim()) {
        //    validate = 0;
        //    j++;
        //}
    });
    if (i > 0) {
        $('#loading').hide();
        toastr.error('Packing already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtNoOfPieces").focus();
        return false;
    }
    //if (j > 0) {
    //    $('#loading').hide();
    //    toastr.error('Barcode already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtbarcode").focus();
    //    return false;
    //}
    debugger;
    //var ImageName = '';
    //if ($("#F_UnitImage").val() != "") {
    //    debugger;
    //    var fileUpload = $("#F_UnitImage").get(0);
    //    var files = fileUpload.files;
    //    var test = new FormData();
    //    for (var i = 0; i < files.length; i++) {
    //        test.append(files[i].name, files[i]);
    //    }
    //    $.ajax({
    //        url: "UploadPackingImage.ashx",
    //        type: "POST",
    //        contentType: false,
    //        processData: false,
    //        async: false,
    //        data: test,
    //        success: function (value) {
    //            console.log(value);
    //            ImageName = value;
    //            $('#loading').hide();
    //        },
    //        error: function (err) {

    //        }
    //    });
    //}
    //else if ($("#PackingimgPath").val() != '' && $("#PackingimgPath").val() != null) {
    //    ImageName = $("#PackingimgPath").val();
    //}
    //else {
    //    ImageName = '';
    //}
    if (validate == 1) {
        debugger;
        AddPackingInTable();
    }
    else {
        toastr.error('Some error occured.Please try again!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
}

function AddPackingInTable() {
    debugger;
    var row = $("#tblPackingList thead tr:first-child").clone(true);
    $(".Action", row).html("<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditPacking1(this)'>&nbsp;&nbsp;<a title='Delete' onclick='DeletePacking(this)'><span class='fa fa-trash' style='color: red;'></span></a>");
    //< i class= 'fa fa-trash' style = 'color:red' title = 'Delete' onclick = 'DeletePacking(this)' > "
    //+ "</i>&nbsp;&nbsp;" + "

    $(".Packing", row).html(parseInt($("#txtNoOfPieces").val().trim()) + ' Piece');
    $(".NoOfPieces", row).html(parseInt($("#txtNoOfPieces").val().trim()));
    /*$(".Barcode", row).html($("#txtbarcode").val().trim());*/
    $(".CP", row).html(parseFloat($("#txtCostPrice").val().trim()).toFixed(2)).css('text-align', 'right');
    $(".SP", row).html(parseFloat($("#txtSellingPrice").val().trim()).toFixed(2)).css('text-align', 'right');
    $(".SecondaryUnitPrice", row).html(parseFloat($("#txtSecondaryUnitPrice").val().trim()).toFixed(2)).css('text-align', 'right');
    //$(".TaxId", row).html($("#ddltax").val());
    //$(".Tax", row).html($("#ddltax option:selected").text());
    //$(".WebAvailability", row).html($("#ddlWebAvailability option:selected").text());
    //$(".ImageName", row).html(ImageName);
    //if (ImageName != '') {
    //    $(".PreviewImage", row).html('<a style="cursor:pointer;" onclick="ViewImage( \'' + ImageName + '\')">View</a>');
    //}
    //else {
    //    $(".PreviewImage", row).html('<span>No Image</span>');
    //}

    $(".Status", row).html($("#ddlStatuspacking option:selected").text());
    $("#tblPackingList").append(row);
    row = $("#tblPackingList tbody tr:last-child").clone(true);
    $('#loading').hide();
    ResetPacking();
}

function EditPacking1(e) {
    debugger;
    ResetPacking();
    debugger;
    var tr = $(e).parent().parent();
    $("#txtPackingName").val($(tr).find(".Packing").text());
    $("#txtNoOfPieces").val($(tr).find(".NoOfPieces").text());
    //$("#txtPieceSize").val($(tr).find(".PieceSize").text());
    $("#txtSecondaryUnitPrice").val($(tr).find(".SecondaryUnitPrice").text());
    $("#ddlWebAvailability").val($(tr).find(".WebAvailability").text());
    $("#txtbarcode").val($(tr).find(".Barcode").text());
    $("#txtCostPrice").val($(tr).find(".CP").text());
    $("#txtSellingPrice").val($(tr).find(".SP").text());
    //$("#ddltax").val($(tr).find(".TaxId").text());
    if ($(tr).find(".Status").text().trim() == 'Active') {
        $("#ddlStatuspacking").val(1).select2();

    }
    else {
        $("#ddlStatuspacking").val(0).select2();

    }
    $('#PackingimgPreview').attr('src', '../Images/ProductImages/' + $(tr).find(".ImageName").text());
    $('#PackingimgPath').val($(tr).find(".ImageName").text());

    $('#btnUpdatePacking1').show();
    $('#btnInsertPacking').hide();
    $('#btnUpdatePacking1').attr('onclick', ' UpdatePacking1(' + $(tr).index() + ')');
}

function UpdatePacking1(index) {
    debugger;
    var i = 0;
    $("#tblPackingList tbody tr").each(function () {
        debugger;
        var x = $(this).find('.NoOfPieces').text();
        if (parseInt(x) == parseInt($("#txtNoOfPieces").val().trim()) && $(this).index() != index) {
            debugger;
            validate = 0;
            i++;
        }
        //var y = $(index).find('.Barcode').text();
        //if (y == $("#txtbarcode").val().trim()) {
        //    validate = 0;
        //    j++;
        //}
    });
    if (i > 0) {
        $('#loading').hide();
        toastr.error('Packing already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtNoOfPieces").focus();
        return false;
    }
    else {
        $("#tblPackingList tbody tr:eq(" + index + ")").remove();
        $('#btnUpdatePacking1').hide();
        $('#btnInsertPacking').show();
        InsertPacking();
    }
}

function ResetPacking() {
    $("#txtPackingName").val('');
    //$("#txtbarcode").val('');
    $("#txtCostPrice").val('0.00');
    $("#txtSellingPrice").val('0.00');
    $("#txtNoOfPieces").val('0');
    //$("#F_UnitImage").val('').change();
    //$("#ddlWebAvailability").val('Yes');
    $("#txtSecondaryUnitPrice").val('0.00');
    ///$("#ddltax").val('1').select2();
    $("#ddlStatuspacking").val(1).select2();
    $("#lblpackingautoid").val('0');
    if ($("#hdnProductId").val() == '0') {
        $("#btnAddPacking").hide();
        $("#btnInsertPacking").show();
    }
    else {
        $("#btnAddPacking").show();
        $("#btnInsertPacking").hide();
    }
    $("#btnUpdatePacking").hide();
    $("#btnUpdatePacking1").hide();

}

function DeletePacking(e) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this Packing.",
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
            ConfirmDeletePacking(e);
        }
    })
}

function ConfirmDeletePacking(e) {
    $(e).closest('tr').remove();
    $('#loading').hide();
    ResetPacking();
    swal("", "Packing deleted successfully.", "success", { closeOnClientOutside: false });
}

function InsertProduct() {
    debugger;
    $('#loading').show();
    var validate = 1;
    var i = 0, j = 0;
    if ($("#txtProductShortName").val().trim() != '' && $("#txtProductShortName").val().trim().length > 30) {
        $('#loading').hide();
        toastr.error('Product Short name can be only of 30 character.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#txtProductName").val().trim() == '') {
        $('#loading').hide();

        toastr.error('Product Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#txtProductSize").val().trim() == '' || parseFloat($("#txtProductSize").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Product QTY Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if (isNaN(parseFloat($("#txtProductSize").val().trim()))) {
        $('#loading').hide();
        $("#txtProductSize").val('');
        toastr.error('Product QTY is not in valid format.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#ddlMeasureUnit").val().trim() == '0' || $("#ddlMeasureUnit").val().trim() == 0) {
        $('#loading').hide();
        toastr.error('Product Size Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#ddlManageStock").val().trim() == '1' && parseInt($("#txtInStock").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Current Stock QTY Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#ddlManageStock").val().trim() == '1' && (parseInt($("#txtInStock").val().trim()) < parseInt($("#txtLowStock").val().trim()))) {
        $('#loading').hide();
        toastr.error("Alert Stock Qty can't be greater than open stock.", 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    debugger;
    BarcodeTable = new Array();
    var j = 0, k = 0;
    $("#tblBarcodeList #tblBarcodeListBody tr").each(function (index, item) {
        debugger;
        if ($(item).find('.Barcode').text() != '') {
            BarcodeTable[j] = new Object();
            BarcodeTable[j].BarcodeAutoId = $(item).find('.BarcodeAutoId').text();
            BarcodeTable[j].Barcode = $(item).find('.Barcode').text();
            BarcodeTable[j].ActionId = 0;
            j++;
        }
    });
    if (BarcodeTable.length <= 0) {
        $('#loading').hide();
        toastr.error('Please add a barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;

        //swal("Error!", "Please add a barcode.", "error", { closeOnClickOutside: false });
        //$('#loading').hide();
        //return;
    }
    var BarcodeTableValues = JSON.stringify(BarcodeTable);

    datatable = new Array();
    $("#tblPackingList tbody tr").each(function (index, item) {
        datatable[i] = new Object();
        datatable[i].Packing = $(item).find('.Packing').text();
        datatable[i].NoOfPieces = $(item).find('.NoOfPieces').text();
        datatable[i].PieceSize = '';
        datatable[i].Barcode = '';
        datatable[i].CP = $(item).find('.CP').text();
        datatable[i].SP = $(item).find('.SP').text();
        datatable[i].SecondaryUnitPrice = $(item).find('.SecondaryUnitPrice').text();
        datatable[i].TaxId = 0;
        datatable[i].WebAvailability = '';
        datatable[i].ImageName = '';
        datatable[i].MS = 0;
        datatable[i].InStock = 0;
        datatable[i].LowStock = 0;
        if ($(item).find('.Status').text().trim() == 'Active') {
            datatable[i].Status = 1;
        }
        else {
            datatable[i].Status = 0;
        }
        i++;
    });

    if (i == 0) {
        $('#loading').hide();
        toastr.error('Atleast 1 Packing Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }

    VendorProductdatatable = new Array();
    $("#tblVendorProductList tbody tr").each(function (index, item) {
        debugger;
        VendorProductdatatable[k] = new Object();
        VendorProductdatatable[k].VendorId = $(item).find('.VendorId').text();
        VendorProductdatatable[k].VendorProductCode = $(item).find('.VendorProductCode').text();
        VendorProductdatatable[k].OtherVPC = '';
        k++;
    });

    var StoreIds = [], StoreIdsList = '';
    $("input:checkbox[name=Store]:checked").each(function () {
        debugger;
        StoreIds.push($(this).val());
    });
    StoreIdsList = StoreIds.join();
    //if (StoreIdsList == null || StoreIdsList == '') {
    //    $('#loading').hide();
    //    toastr.error('Please Select Atleast one Store.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    $('#btnSave').removeAttr('disabled');
    //    return false;
    //}
    if (validate == 1) {
        var viewImage = 0;
        var logo;
        var timeStamp = Date.parse(new Date());

        if ($("#filePhoto").val() != "") {
            logo = timeStamp + '_' + $("#filePhoto").val().split('\\').pop();
        }
        else {
            logo = "product.png";
        }

        data = {
            Brand: $("#ddlbrand").val(),
            DeptId: $("#ddlDept").val(),
            Catgory: $("#ddlcategory").val(),
            Product: $("#txtProductName").val().trim(),
            AgeRestriction: $("#ddlAgeRestriction").val(),
            VendorId: $("#ddlVendor").val(),
            ProductSize: $("#txtProductSize").val().trim(),
            GroupId: $("#ddlGroup").val(),
            MS: $("#ddlManageStock").val(),
            IS: $("#txtInStock").val().trim(),
            AS: $("#txtLowStock").val().trim(),
            Status: $("#ddlStatus").val(),
            MeasurementUnit: $("#ddlMeasureUnit").val(),
            StoreIdsList: StoreIdsList,
            Image: logo,
            viewImage: 1,
            Description: $("#txtDescription").val().trim(),
            TaxId: $("#ddltax").val(),
            WebAvailability: $("#ddlWebAvailability").val(),
            ProductShortName: $("#txtProductShortName").val().trim()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/InsertProduct",
            data: JSON.stringify({ dataValue: JSON.stringify(data), TableValues: JSON.stringify(datatable), VendorProductList: JSON.stringify(VendorProductdatatable), BarcodeTableValues: JSON.stringify(BarcodeTable) }),
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
                    if ($("#filePhoto").val() != "") {
                        var fileUpload = $("#filePhoto").get(0);
                        var files = fileUpload.files;
                        var test = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            test.append(files[i].name, files[i]);
                        }
                        $.ajax({
                            url: "ProductImageHandler.ashx?timestamp=" + timeStamp + "",
                            type: "POST",
                            contentType: false,
                            processData: false,
                            data: test,
                            success: function (result) {
                                debugger;
                                $('#loading').hide();
                                $('#btnSave').removeAttr('disabled');
                                console.log(result)
                            },
                            error: function (err) {

                            }
                        });
                    }
                    swal("Success", "Product added successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                        BindDropDowns();
                        $('#btnSave').removeAttr('disabled');
                    });
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
                }
                $('#loading').hide();
                $('#btnSave').removeAttr('disabled');
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
                $('#btnSave').removeAttr('disabled');
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
                $('#btnSave').removeAttr('disabled');
            }
        })
    }
}

function editProductDetail(id) {
    debugger;
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/EditProductDetail",
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
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Department = xml.find("Table");
                var Category = xml.find("Table1");
                var Brand = xml.find("Table2");
                var Tax = xml.find("Table3");
                var AgeRestriction = xml.find("Table4");
                var ProductDetail = xml.find("Table5");
                var UnitDetail = xml.find("Table6");
                var VendorList = xml.find("Table7");
                var ProductGroupList = xml.find("Table8");
                var VendorProductCodeList = xml.find("Table9");
                //var VendorList = xml.find("Table10");
                var AssignedStoreList = xml.find("Table10");
                var MeasurementUnitList = xml.find("Table11");
                var BarcodeList = xml.find("Table12");

                $("#btnAddVendor").hide();
                $("#btnUpdateVendor").hide();
                $("#btnAddVendor1").show();
                $("#btnUpdateVendor1").hide();

                $("#ddlDept option").remove();
                $.each(Department, function () {
                    $("#ddlDept").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text().trim()));
                });
                $("#ddlDept").select2();

                $("#ddlbrand option").remove();
                $.each(Brand, function () {
                    $("#ddlbrand").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("BrandName").text().trim()));
                });
                $("#ddlbrand").select2();

                $("#ddlcategory option").remove();
                $.each(Category, function () {
                    $("#ddlcategory").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CategoryName").text().trim()));
                });
                $("#ddlcategory").select2();

                $("#ddltax option").remove();
                $.each(Tax, function () {
                    $("#ddltax").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TaxName").text().trim()));
                });

                $("#ddlAgeRestriction option").remove();
                $.each(AgeRestriction, function () {
                    $("#ddlAgeRestriction").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("AgeRestrictionName").text().trim()));
                });

                $("#ddlVendor option").remove();
                $("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $.each(VendorList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text().trim()));
                });
                $("#ddlVendor").select2();

                $("#ddlGroup option").remove();
                $("#ddlGroup").append('<option value="0">New Group</option>');
                $.each(ProductGroupList, function () {
                    $("#ddlGroup").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("GroupName").text().trim()));
                });
                $("#ddlGroup").select2();

                //$("#ddlVendor option").remove();
                //debugger;
                //$("#ddlVendor").append('<option value="0">Select Vendor</option>');
                //$.each(VendorList, function () {
                //    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text().trim()));
                //});
                //var text1 = 'No Vendor';
                //$("#ddlVendor option:contains(" + text1 + ")").attr("selected", true);
                //$("#ddlVendor").select2();

                ///$("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $("#ddlMeasureUnit option").remove();
                $.each(MeasurementUnitList, function () {
                    $("#ddlMeasureUnit").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UnitName").text().trim()));
                });
                $("#ddlMeasureUnit").select2();
                debugger;
                $("#hdnProductId").val(id);
                $("#ddlDept").val($(ProductDetail).find('DeptId').text()).select2();
                $("#ddlbrand").val($(ProductDetail).find('BrandId').text()).select2();
                $("#ddlcategory").val($(ProductDetail).find('CategoryId').text()).select2();
                $("#ddlVendor").val($(ProductDetail).find('VendorId').text()).select2();
                $("#txtProductName").val($(ProductDetail).find('ProductName').text());
                $("#txtProductShortName").val($(ProductDetail).find('ProductShortName').text());
                $("#ddlAgeRestriction").val($(ProductDetail).find('AgeRestrictionId').text());
                $("#ddlStatus").val($(ProductDetail).find('ProductStatus').text()).select2();
                $("#ddlGroup").val($(ProductDetail).find('GroupId').text()).select2();
                $("#txtDescription").val($(ProductDetail).find('Description').text());
                $("#txtProductSize").val($(ProductDetail).find('Size').text());
                $("#ddltax").val($(ProductDetail).find('TaxId').text()).select2();
                //$("#ddlMeasureUnit").val($(ProductDetail).find('MeasurementUnit').text()).select2();

                var MeasureUnitText = $(ProductDetail).find('MeasurementUnit').text();
                $("#ddlMeasureUnit option:contains(" + MeasureUnitText + ")").attr("selected", true);
                $("#ddlMeasureUnit").select2();

                $("#ddlManageStock").val($(ProductDetail).find('ManageStock').text()).select2().change();
                $("#txtInStock").val($(ProductDetail).find('InstockQty').text());
                $("#txtLowStock").val($(ProductDetail).find('AlertQty').text());
                $("#txtInStock").attr('disabled', 'disabled');
                if ($(ProductDetail).find('ImagePath').text() != '' && $(ProductDetail).find('ImagePath').text() != null && $(ProductDetail).find('ImagePath').text() != undefined) {
                    $("#imgPath").val($(ProductDetail).find('ImagePath').text());
                    $('#imgPreview').attr('src', "../Images/ProductImages/" + $(ProductDetail).find('ImagePath').text());
                    $("#hdnimage").val($(ProductDetail).find('ImagePath').text());
                }
                if (VendorProductCodeList.length > 0) {
                    $("#tblVendorProductList tbody tr").remove();
                    $.each(VendorProductCodeList, function () {
                        var row = $("#tblVendorProductList thead tr:first-child").clone(true);
                        $(".Action", row).html("<i class='fa fa-trash' style ='color:red' title='Delete' onclick='DeleteVenodrProductRow1(" + $(this).find('AutoId').text() + ")' ></i>&nbsp;&nbsp;<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditVendor1(" + $(this).find('AutoId').text() + ",this)' />").css('background-color', 'white');
                        $(".VendorId", row).html($(this).find('VendorId').text()).css('background-color', 'white');
                        $(".VendorName", row).html($(this).find('VendorName').text()).css('background-color', 'white');
                        $(".VendorProductCode", row).html($(this).find('VendorProductCode').text()).css('background-color', 'white');
                        $("#tblVendorProductList").append(row);
                        row = $("#tblVendorProductList tbody tr:last-child").clone(true);
                        $('#loading').hide();
                    });
                    $("#ddlVendor").val('0').select2();
                    $("#txtVenProductCode").val('');
                    $("#btnUpdateVendor").hide();
                    $("#btnAddVendor").hide();
                }
                var BarcodeListlength = BarcodeList.length;
                if (BarcodeList.length > 0) {
                    $("#tblBarcodeList tbody tr").remove();
                    $.each(BarcodeList, function () {
                        var row = $("#tblBarcodeList thead tr:first-child").clone(true);
                        if (BarcodeListlength == 1) {
                            var action = '<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditBarcode1(this)" />';
                        }
                        else {
                            var action = '<i class="fa fa-trash" style ="color:red" title="Delete" onclick="DeleteBarcode1(this)"></i>';
                            action = action + '&nbsp;&nbsp;<img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditBarcode1(this)" />';
                        }

                        $(".Action", row).html(action).css('background-color', 'white');
                        $(".BarcodeAutoId", row).html('0').css('background-color', 'white');
                        $(".Barcode", row).html($(this).find('Barcode').text()).css('background-color', 'white');
                        $(".ActionId", row).html('0').css('background-color', 'white');
                        $("#tblBarcodeList").append(row);
                        row = $("#tblBarcodeList tbody tr:last-child").clone(true);
                        $('#loading').hide();
                    });
                    $("#txtBarcode").val('');
                }
                var StoreIds = [];
                var html = "";
                //html += '<div class="col-md-6" id="divAllStore">';
                //html += '<input class="form-check-input"  type="checkbox" onchange="selectAll()" name="AllStore" value="0" id="AllflexCheckDefault">';
                //html += '&nbsp;&nbsp;<span class="form-check-label" for="flexCheckDefault">All Stores</span>';
                //html += '</div>';
                $.each(AssignedStoreList, function () {
                    html += '<div class="col-md-6">';
                    html += '<input class="form-check-input" type="checkbox" onclick="ChangeProductStatus(' + $(this).find('AutoId').text() + ',this)" name="Store" value="' + $(this).find('StoreId').text() + '" >';
                    html += '&nbsp;&nbsp;<span class="form-check-label" for="flexCheckDefault">' + $(this).find('StoreName').text() + '</span>';
                    html += '</div>';
                    if ($(this).find('Status').text() == '1') {
                        StoreIds.push($(this).find('StoreId').text());
                    }
                });
                $('#DivStoreList').html(html);
                $('#DivStoreListHead').hide();

                debugger;
                $("input:checkbox[name=Store]").each(function () {
                    debugger;
                    if (StoreIds.includes($(this).val())) {
                        $(this).prop('checked', true);
                    }
                });
                if (UnitDetail.length > 0) {
                    $("#EmptyTable").hide();
                    $("#tblPackingList tbody tr").remove();
                    var row = $("#tblPackingList thead tr:first-child").clone(true);
                    $.each(UnitDetail, function () {
                        $(".Action", row).html("<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditPacking(" + $(this).find("AutoId").text() + ")'>");
                        $(".Packing", row).html($(this).find("PackingName").text());
                        $(".NoOfPieces", row).html($(this).find("NoOfPieces").text());
                        $(".Barcode", row).html($(this).find("Barcode").text());
                        $(".CP", row).html($(this).find("CostPrice").text()).css('text-align', 'right');
                        $(".SP", row).html($(this).find("SellingPrice").text()).css('text-align', 'right');
                        $(".SecondaryUnitPrice", row).html($(this).find("SecondaryUnitPrice").text()).css('text-align', 'right');
                        $(".TaxId", row).html($(this).find("TaxAutoId").text());
                        $(".Tax", row).html($(this).find("TaxName").text());
                        $(".WebAvailability", row).html($(this).find("IsShowOnWeb").text());
                        if ($(this).find("ImageName").text() != '') {
                            $(".PreviewImage", row).html('<a style="cursor:pointer;" onclick="ViewImage(\'' + $(this).find("ImageName").text() + '\')">View</a>');
                            $(".ImageName", row).html($(this).find("ImageName").text());
                        }
                        else {
                            $(".PreviewImage", row).html('No Image');
                            $(".ImageName", row).html('');
                        }

                        if ($(this).find("Status").text() == '1') {
                            $(".Status", row).html('Active');
                        }
                        else {
                            $(".Status", row).html('Inactive');
                        }
                        $("#tblPackingList").append(row);
                        row = $("#tblPackingList tbody tr:last-child").clone(true);
                    });
                    $("#tblPackingList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblPackingList").hide();
                }

                $(".ManageStatus").show();
                $("#btnSave").hide();
                $("#btnUpdate").show();
                $("#divupdate").show();
                $("#btnAddPacking").show();
                $("#btnUpdatePacking").hide();
                $("#btnInsertPacking").hide();

                $("#btnAddBarcode").hide();
                $("#btnAddBarcode1").show();
                $("#btnBarcodeUpdate").hide();
                $("#btnBarcodeUpdate1").hide();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });

}

function UpdateProduct() {
    debugger;
    $('#loading').show();
    var validate = 1;
    var i = 0;
    if ($("#txtProductShortName").val().trim() != '' && $("#txtProductShortName").val().trim().length > 30) {
        $('#loading').hide();
        toastr.error('Product Short name can be only of 30 character.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        $('#btnSave').removeAttr('disabled');
        return false;
    }
    if ($("#txtProductName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Product Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtProductSize").val().trim() == '' || parseFloat($("#txtProductSize").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Product QTY Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (isNaN(parseFloat($("#txtProductSize").val().trim()))) {
        $('#loading').hide();
        $("#txtProductSize").val('');
        toastr.error('Product QTY is not in valid format.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlMeasureUnit").val().trim() == '0' || $("#ddlMeasureUnit").val().trim() == 0) {
        $('#loading').hide();
        toastr.error('Product Size Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    //if ($("#ddlManageStock").val() == '1' && parseInt($("#txtInStock").val().trim()) == 0) {
    //    $('#loading').hide();
    //    toastr.error('Current Stock QTY Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    //if ($("#ddlManageStock").val().trim() == '1' && (parseInt($("#txtInStock").val().trim()) < parseInt($("#txtLowStock").val().trim()))) {
    //    $('#loading').hide();
    //    toastr.error("Alert Stock Qty can't be greater than open stock.", 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if (validate == 1) {

        var viewImage = 0;
        var logo;
        var timeStamp = Date.parse(new Date());
        if ($("#filePhoto").val() != "") {
            logo = timeStamp + '_' + $("#filePhoto").val().split('\\').pop()
        }
        else {
            if ($('#imgPreview').attr('src') == '') {
                logo = 'product.png';
            }
            else {
                if ($('#imgPreview').attr('src') == '../Images/ProductImages/product.png') {
                    logo = 'product.png';
                } else {
                    logo = $("#hdnimage").val();
                }

            }
        }
        data = {
            DeptId: $("#ddlDept").val(),
            AutoId: $("#hdnProductId").val(),
            Brand: $("#ddlbrand").val(),
            Catgory: $("#ddlcategory").val(),
            Product: $("#txtProductName").val().trim(),
            AgeRestriction: $("#ddlAgeRestriction").val(),
            VendorId: $("#ddlVendor").val(),
            ProductSize: $("#txtProductSize").val().trim(),
            GroupId: $("#ddlGroup").val(),
            MS: $("#ddlManageStock").val(),
            IS: $("#txtInStock").val().trim(),
            AS: $("#txtLowStock").val().trim(),
            MeasurementUnit: $("#ddlMeasureUnit").val(),
            Image: logo,
            viewImage: 1,
            Status: $("#ddlStatus").val(),
            Description: $("#txtDescription").val().trim(),
            TaxId: $("#ddltax").val(),
            WebAvailability: $("#ddlWebAvailability").val(),
            ProductShortName: $("#txtProductShortName").val().trim()
        }

        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/UpdateProduct",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    if ($("#filePhoto").val() != "") {
                        var fileUpload = $("#filePhoto").get(0);
                        var files = fileUpload.files;
                        var test = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            test.append(files[i].name, files[i]);
                        }
                        $.ajax({
                            url: "ProductImageHandler.ashx?timestamp=" + timeStamp + "",
                            type: "POST",
                            contentType: false,
                            processData: false,
                            data: test,
                            success: function (result) {
                                debugger;
                                $('#loading').hide();
                                console.log(result)
                            },
                            error: function (err) {

                            }
                        });
                    }
                    $('#loading').hide();
                    swal("Success!", "Product details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        ///Reset();
                        window.location.reload();
                    });
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClientOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function EditPacking(PackingAutoId) {
    data = {
        AutoId: PackingAutoId,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/EditPacking",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
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
            else if (response.d == 'false') {
                swal("Warning!", "Some error occured.", "warning", { closeOnClientOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UnitDetail = xml.find("Table");
                debugger;
                $("#lblpackingautoid").val($(UnitDetail).find("AutoId").text());
                $("#txtPackingName").val($(UnitDetail).find("PackingName").text());
                $("#txtNoOfPieces").val($(UnitDetail).find("NoOfPieces").text());
                $("#txtbarcode").val($(UnitDetail).find("Barcode").text());
                $("#txtCostPrice").val($(UnitDetail).find("CostPrice").text()).css('text-align', 'right');
                $("#txtSellingPrice").val($(UnitDetail).find("SellingPrice").text()).css('text-align', 'right');
                $("#txtSecondaryUnitPrice").val($(UnitDetail).find("SecondaryUnitPrice").text()).css('text-align', 'right');
                $("#ddltax").val($(UnitDetail).find("TaxAutoId").text()).select2();
                $("#ddlWebAvailability").val($(UnitDetail).find("IsShowOnWeb").text());
                $("#ddlStatuspacking").val($(UnitDetail).find("Status").text()).select2();
                if ($(UnitDetail).find(" ImageName").text() != '') {
                    $("#PackingimgPreview").attr('src', '../Images/ProductImages/' + $(UnitDetail).find(" ImageName").text());
                    $("#PackingimgPath").val($(UnitDetail).find("ImageName").text());
                }
                $("#btnAddPacking").hide();
                $("#btnInsertPacking").hide();
                $("#btnUpdatePacking").show();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}
var verificationCode = 0
function UpdatePacking() {
    debugger;
    $('#loading').show();
    var validate = 1, i = 0;
    //if ($("#txtPackingName").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Packing Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtNoOfPieces").val().trim() == '' || parseInt($("#txtNoOfPieces").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('No. of Pieces Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#txtPackingName').val(parseInt($("#txtNoOfPieces").val().trim()) + ' Piece');
    //if ($("#txtbarcode").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Barcode Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    //$("#tblPackingList tbody tr").each(function () {
    //    debugger;
    //    var x = $(this).find('.NoOfPieces').text();
    //    if (parseInt(x) == parseInt($("#txtNoOfPieces").val().trim())) {
    //        debugger;
    //        validate = 0;
    //        i++;
    //    }
    //    //var y = $(index).find('.Barcode').text();
    //    //if (y == $("#txtbarcode").val().trim()) {
    //    //    validate = 0;
    //    //    j++;
    //    //}
    //});
    //if (i > 0) {
    //    $('#loading').hide();
    //    toastr.error('Packing already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtNoOfPieces").focus();
    //    return false;
    //}
    if (parseFloat($("#txtSellingPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSecondaryUnitPrice").val().trim() == '' || parseFloat($("#txtSecondaryUnitPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Secondary Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    //var ImageName = '';
    //if ($("#F_UnitImage").val() != "") {
    //    debugger;
    //    var fileUpload = $("#F_UnitImage").get(0);
    //    var files = fileUpload.files;
    //    var test = new FormData();
    //    for (var i = 0; i < files.length; i++) {
    //        test.append(files[i].name, files[i]);
    //    }
    //    $.ajax({
    //        url: "UploadPackingImage.ashx",
    //        type: "POST",
    //        contentType: false,
    //        processData: false,
    //        async: false,
    //        data: test,
    //        success: function (value) {
    //            console.log(value);
    //            ImageName = value;
    //            $('#loading').hide();
    //        },
    //        error: function (err) {

    //        }
    //    });
    //}
    //else if ($("#PackingimgPath").val().trim() != "") {
    //    ImageName = $("#PackingimgPath").val();
    //}
    //else {
    //    ImageName = "";
    //}
    if (validate == 1) {
        data = {
            ProductAutoId: $("#hdnProductId").val(),
            AutoId: $("#lblpackingautoid").val(),
            Packing: $("#txtPackingName").val().trim(),
            NoOfPieces: $("#txtNoOfPieces").val().trim(),
            PieceSize: '',
            Barcode: '',
            CP: $("#txtCostPrice").val().trim(),
            SP: $("#txtSellingPrice").val().trim(),
            SecondaryUnitPrice: $("#txtSecondaryUnitPrice").val().trim(),
            Tax: $("#ddltax").val(),
            ImageName: '',
            WebAvailability: 'Yes',
            MS: 0,
            InStock: 0,
            LowStock: 0,
            Status: $("#ddlStatuspacking").val(),
            verificationCode: verificationCode,
        }

        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/UpdatePacking",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'false') {
                    swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
                    //ResetPacking();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else if (response.d == 'Unit already exist.') {
                    $('#loading').hide();
                    verificationCode = 0;
                    toastr.error(response.d, 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                    ResetPacking();
                }
                else {
                    $('#loading').hide();
                    debugger;
                    // $("#txtbarcode").val('');
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var ResponseMessage = xml.find("Table");
                    if ($(ResponseMessage).find('responseCode').text() == '0') {
                        var TextString = '';
                        //if ($(ResposeTable).find('ResponseMessage').text().split(', ').length == 1) {
                        //    TextString += '<br/>Below product has multiple packing and its cost price, unit price and secondary unit price will not update.<br/>';
                        //}
                        //else {
                        //    TextString += '<br/>Below products have multiple packing and their cost price, unit price and secondary unit price will not update.<br/>';
                        //}
                        //TextString += $(ResposeTable).find('ResponseMessage').text();
                        //TextString += '<br/><br/><b>Do you want to proceed?</b>';
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
                                UpdatePacking();
                            }
                            else {
                                debugger;
                                verificationCode = 0;
                                ResetPacking();

                            }
                        });
                    }
                    else if ($(ResponseMessage).find('responseCode').text() == '1') {
                        verificationCode = 0;
                        swal("Success!", $(ResponseMessage).find('ResponseMessage').text(), "success", { closeOnClickOutside: false }).then(function () {
                            window.location.reload();
                        });
                    }
                    //BindPacking();
                    //swal("Success!", "Packing updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                    //    window.location.reload();
                    //});
                    //swal("Error!", response.d, "error", { closeOnClientOutside: false });
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
        })
    }
}

function AddPacking() {
    debugger;
    $('#loading').show();
    var validate = 1;
    //if ($("#txtPackingName").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Packing Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}

    if ($("#txtNoOfPieces").val().trim() == '' || parseInt($("#txtNoOfPieces").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('No. of Pieces Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $("#txtPackingName").val(parseInt($("#txtNoOfPieces").val().trim()) + ' Piece');
    //if ($("#txtbarcode").val().trim() == '') {
    //    $('#loading').hide();
    //    toastr.error('Barcode Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if (parseFloat($("#txtSellingPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSecondaryUnitPrice").val().trim() == '' || parseFloat($("#txtSecondaryUnitPrice").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Secondary Unit Price Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    var i = 0, j = 0;
    $("#tblPackingList tr").each(function (item, index) {
        var x = $(index).find('.Packing').text();
        if (x.trim() == $("#txtPackingName").val().trim()) {
            validate = 0;
            i++;
        }
        //var y = $(index).find('.Barcode').text();
        //if (y.trim() == $("#txtbarcode").val().trim()) {
        //    validate = 0;
        //    j++;
        //}
    });
    if (i > 0) {
        $('#loading').hide();
        toastr.error('Packing already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtPackingName").focus();
        return false;
    }
    //if (j > 0) {
    //    $('#loading').hide();
    //    toastr.error('Barcode already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    $("#txtbarcode").focus();
    //    return false;
    //}
    //var ImageName = '';
    //if ($("#F_UnitImage").val() != "") {
    //    debugger;
    //    var fileUpload = $("#F_UnitImage").get(0);
    //    var files = fileUpload.files;
    //    var test = new FormData();
    //    for (var i = 0; i < files.length; i++) {
    //        test.append(files[i].name, files[i]);
    //    }
    //    $.ajax({
    //        url: "UploadPackingImage.ashx",
    //        type: "POST",
    //        contentType: false,
    //        processData: false,
    //        async: false,
    //        data: test,
    //        success: function (value) {
    //            console.log(value);
    //            ImageName = value;
    //            $('#loading').hide();
    //        },
    //        error: function (err) {

    //        }
    //    });
    //}
    if (validate == 1) {
        data = {
            ProductAutoId: $("#hdnProductId").val(),
            Packing: $("#txtPackingName").val().trim(),
            NoOfPieces: $("#txtNoOfPieces").val().trim(),
            PieceSize: '',
            Barcode: '',
            CP: $("#txtCostPrice").val().trim(),
            SP: $("#txtSellingPrice").val().trim(),
            SecondaryUnitPrice: $("#txtSecondaryUnitPrice").val().trim(),
            Tax: $("#ddltax").val(),
            MS: 0,
            ImageName: '',
            WebAvailability: $("#ddlWebAvailability").val(),
            InStock: 0,
            LowStock: 0,
            Status: $("#ddlStatuspacking").val(),
        }

        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/AddPacking",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    $('#loading').hide();
                    BindPacking();
                    swal("Success!", "Packing added successfully.", "success", { closeOnClientOutside: false });
                    ResetPacking();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    $("#txtbarcode").val('');
                    toastr.error(response.d, 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });

                    //swal("Error!", response.d, "error", { closeOnClientOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            }
        })
    }
}

function BindPacking() {
    $('#loading').show();
    data = {
        AutoId: $("#hdnProductId").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/editProductDetail",
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
                var UnitDetail = xml.find("Table6");

                if (UnitDetail.length > 0) {
                    $("#EmptyTable").hide();
                    $("#tblPackingList tbody tr").remove();
                    var row = $("#tblPackingList thead tr:first-child").clone(true);
                    $.each(UnitDetail, function () {
                        $(".Action", row).html("<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditPacking(" + $(this).find("AutoId").text() + ")'>");
                        $(".Packing", row).html($(this).find("PackingName").text());
                        $(".NoOfPieces", row).html($(this).find("NoOfPieces").text());
                        //$(".PieceSize", row).html($(this).find("SizeOfSinglePiece").text());
                        $(".Barcode", row).html($(this).find("Barcode").text());
                        $(".CP", row).html($(this).find("CostPrice").text()).css('text-align', 'right');
                        $(".SP", row).html($(this).find("SellingPrice").text()).css('text-align', 'right');
                        $(".SecondaryUnitPrice", row).html($(this).find("SecondaryUnitPrice").text()).css('text-align', 'right');
                        $(".TaxId", row).html($(this).find("TaxAutoId").text());
                        $(".Tax", row).html($(this).find("TaxName").text());
                        $(".WebAvailability", row).html($(this).find("IsShowOnWeb").text());
                        //if ($(this).find("ManageStock").text() == '1') {
                        //    $(".MS", row).html('Yes');
                        //}
                        //else {
                        //    $(".MS", row).html('No');
                        //}
                        if ($(this).find("ImageName").text() != '') {
                            $(".PreviewImage", row).html('<a style="cursor:pointer;" onclick="ViewImage(\'' + $(this).find("ImageName").text() + '\')">View</a>');
                            $(".ImageName", row).html($(this).find("ImageName").text());
                        }
                        else {
                            $(".PreviewImage", row).html('No Image');
                            $(".ImageName", row).html('');
                        }
                        //$(".InStock", row).html($(this).find("AvailableQty").text());
                        //$(".LowStock", row).html($(this).find("AlertQty").text());
                        if ($(this).find("Status").text() == '1') {
                            $(".Status", row).html('Active');
                        }
                        else {
                            $(".Status", row).html('Inactive');
                        }

                        $("#tblPackingList").append(row);
                        row = $("#tblPackingList tbody tr:last-child").clone(true);
                    });
                    $("#tblPackingList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblPackingList").hide();
                }
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });

}

function ViewImage(ImageName) {
    debugger;
    $('#imgPackingImage').attr('src', '/Images/ProductImages/' + ImageName);
    $('#ModalPackingImage').modal('show');
}

function ClosePackingImageModal() {
    $('#imgPackingImage').attr('src', '#');
    $('#ModalPackingImage').modal('hide');
}

function AddVendorInTable() {
    if ($("#ddlVendor").val() == '' || $("#ddlVendor").val() == '0') {
        $('#loading').hide();
        toastr.error('Please select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else if ($("#txtVenProductCode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Vendor Product Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtVenProductCode").focus();
        return false;
    }
    debugger;
    if (ValidateVendorId() == false) {
        VendorProductReset();
        $('#loading').hide();
        toastr.error('Selected Vendor Product Code already added.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else {
        data = {
            //ProductAutoId: $("#hdnProductId").val(),
            VendorId: $("#ddlVendor").val().trim(),
            VendorProductCode: $("#txtVenProductCode").val().trim(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/ValidateVendorProductCode",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
                if (response.d == 'false') {
                    swal("Error!", "Some Error Occured.", "error", { closeOnClientOutside: false }).then(function () {
                        window.location.reload();
                    });
                }
                else if (response.d == 'Session') {
                    swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                        window.location.href = '/Default.aspx';
                    });
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var VendorProductCodeRespose = xml.find("Table");
                    if ($(VendorProductCodeRespose).find('SuccessCode').text() == '0') {
                        $('#loading').hide();
                        $('#loading').hide();
                        toastr.error($(VendorProductCodeRespose).find('SuccessMessage').text(), 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                        $("#txtVenProductCode").focus();
                        return false;
                        //swal("Warning!", $(VendorProductCodeRespose).find('SuccessMessage').text(), "warning", { closeOnClientOutside: false });
                    }
                    else if ($(VendorProductCodeRespose).find('SuccessCode').text() == '1') {
                        $('#loading').show();
                        var row = $("#tblVendorProductList thead tr:first-child").clone(true);
                        $(".Action", row).html("<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditVendor(this)' />&nbsp;&nbsp;<i class='fa fa-trash' style ='color:red' title='Delete' onclick='DeleteVenodrProductRow(this)' ></i>").css('background-color', 'white');
                        $(".VendorId", row).html($("#ddlVendor").val()).css('background-color', 'white');
                        $(".VendorName", row).html($("#ddlVendor option:selected").text()).css('background-color', 'white');
                        $(".VendorProductCode", row).html($("#txtVenProductCode").val().trim()).css('background-color', 'white');
                        $("#tblVendorProductList").append(row);
                        row = $("#tblVendorProductList tbody tr:last-child").clone(true);
                        //$("#ddlVendor").val($("#ddlVendor").val()).hide().select2();
                        //$("#ddlVendor option[value=" + $("#ddlVendor").val() + "]").attr('disabled', 'disabled').select2();
                        VendorProductReset();
                        $('#loading').hide();
                    }
                    else {
                        swal("Error!", "Some error occured.", "error", { closeOnClientOutside: false });
                    }
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            }
        });
    }
}

function VendorProductReset() {
    $("#ddlVendor").val('0').select2();
    $("#txtVenProductCode").val('');
    $("#btnUpdateVendor").hide();
    $("#btnAddVendor").show();

}


function DeleteVenodrProductRow(e) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this Vendor.",
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
            ConfirmDeleteVendorProduct(e);
        }
        else {
            $('#loading').hide();
        }
    })
}

function ConfirmDeleteVendorProduct(e) {
    debugger;
    //$("#ddlVendor option[value=" + $(e).parent().parent().find('.VendorId').text() + "]").removeAttr('disabled').select2();
    $('#loading').hide();
    $(e).closest('tr').remove();
    VendorProductReset();
    swal("", "Vendor deleted successfully.", "success", { closeOnClientOutside: false });
}

function BindStoreList() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/BindStoreList",
        data: "",
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
            if (response.d == 'false') {
                swal("Success!", response.d, "success", { closeOnClickOutside: false }).then(function () {
                    Reset();
                });
            }
            else if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StoreList = xml.find("Table");
                var CurrentStore = xml.find("Table1");
                var html = "";
                if (StoreList.length <=1) {
                    $("#DivStoreListHead").hide();
                }
                else {
                    html += '<div class="col-md-6" id="divAllStore">';
                    html += '<input class="form-check-input"  type="checkbox" onchange="selectAll()" name="AllStore" value="0" id="AllflexCheckDefault">';
                    html += '&nbsp;&nbsp;<span class="form-check-label" for="AllflexCheckDefault">All Stores</span>';
                    html += '</div>';
                    $.each(StoreList, function () {
                        debugger;
                        if ($(CurrentStore).find('StoreId').text() != $(this).find('AutoId').text()) {
                            html += '<div class="col-md-6">';
                            html += '<input class="form-check-input" type="checkbox" name="Store" value="' + $(this).find('AutoId').text() + '" >';
                            html += '&nbsp;&nbsp;<span class="form-check-label" for="flexCheckDefault">' + $(this).find('CompanyName').text() + '</span>';
                            html += '</div>';
                        }
                    });
                    $('#DivStoreList').html(html);
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

function selectAll() {
    debugger;
    if ($("input:checkbox[name=AllStore]").is(':checked')) {
        $("input:checkbox[name=Store]").each(function () {
            debugger;
            $(this).prop('checked', true).change();
        });
    }
    else {
        $("input:checkbox[name=Store]").each(function () {
            debugger;
            $(this).prop('checked', false).change();
        });
    }
}

function EditVendor(e) {
    debugger;
    $("#ddlVendor").val($(e).parent().parent().find('.VendorId').text()).select2();
    $("#txtVenProductCode").val($(e).parent().parent().find('.VendorProductCode').text());
    $("#btnUpdateVendor").attr('onclick', 'UpdateProductVendor(' + $(e).closest('tr').index() + ')');
    $("#btnAddVendor").hide();
    $("#btnUpdateVendor").show();
}

function UpdateProductVendor(index) {
    if ($("#ddlVendor").val() == '' || $("#ddlVendor").val() == '0') {
        $('#loading').hide();
        toastr.error('Please select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else if ($("#txtVenProductCode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Vendor Product Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtVenProductCode").focus();
        return false;
    }
    debugger;
    var result = true;
    $("#tblVendorProductList tbody tr").each(function () {
        if (($(this).find(".VendorId").text().trim() == $("#ddlVendor").val().trim()) && ($(this).find(".VendorProductCode").text().trim() == $("#txtVenProductCode").val().trim()) && $(this).index() != index) {
            result = false;
        }
    });
    if (result == false) {
        VendorProductReset();
        $('#loading').hide();
        toastr.error('Selected Vendor Product Code already added.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    data = {
        //ProductAutoId: $("#hdnProductId").val(),
        VendorId: $("#ddlVendor").val().trim(),
        VendorProductCode: $("#txtVenProductCode").val().trim(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/ValidateVendorProductCode",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'false') {
                swal("Error!", "Some Error Occured.", "error", { closeOnClientOutside: false }).then(function () {
                    window.location.reload();
                });
            }
            else if (response.d == 'Session') {
                swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var VendorProductCodeRespose = xml.find("Table");
                if ($(VendorProductCodeRespose).find('SuccessCode').text() == '0') {
                    $('#loading').hide();
                    toastr.error($(VendorProductCodeRespose).find('SuccessMessage').text(), 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                    $("#txtVenProductCode").focus();
                    return false;
                    //swal("Warning!", $(VendorProductCodeRespose).find('SuccessMessage').text(), "warning", { closeOnClientOutside: false });
                }
                else if ($(VendorProductCodeRespose).find('SuccessCode').text() == '1') {
                    $("#ddlVendor option[value=" + $("#tblVendorProductList tbody tr:eq(" + index + ")").find('.VendorId').text() + "]").removeAttr('disabled').select2();
                    $("#tblVendorProductList tbody tr:eq(" + index + ")").remove();
                    $("#btnUpdateVendor").hide();
                    $("#btnAddVendor").show();
                    AddVendorInTable();
                }
                else {
                    swal("Error!", "Some error occured.", "error", { closeOnClientOutside: false });
                }
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });


}

function ChangeProductStatus(AutoId, e) {
    var Status = 0;
    debugger;
    if (AutoId == '' || AutoId == 0 || AutoId == null) {
        $('#loading').hide();
        toastr.error('Product Status not Changed.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }

    else if ($(e).prop("checked") == true) {
        Status = 1;
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/ChangeProductStatus",
        data: "{'AutoId':'" + AutoId + "','Status':'" + Status + "'}",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Product Status Changed for selected Store.", "success", { closeOnClientOutside: false }).then(function () {
                    debugger;
                    window.location.reload();
                });
            }
            else {
                swal("Error!", response.d, "error", { closeOnClientOutside: false });
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function EditVendor1(AutoId, e) {
    $("#ddlVendor").val($(e).parent().parent().find('.VendorId').text()).select2();
    $("#txtVenProductCode").val($(e).parent().parent().find('.VendorProductCode').text());
    $("#btnUpdateVendor1").attr('onclick', 'UpdateProductVendorInDB(' + AutoId + ')');
    $("#btnAddVendor").hide();
    $("#btnUpdateVendor").hide();
    $("#btnAddVendor1").hide();
    $("#btnUpdateVendor1").show();
}

function DeleteVenodrProductRow1(AutoId) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this Vendor.",
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
            ConfirmDeleteVendorProductFromDB(AutoId);
        }
        else {
            $('#loading').hide();
        }
    })
}

function ConfirmDeleteVendorProductFromDB(AutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/DeleteVendorProductFromDB",
        data: "{'AutoId':'" + AutoId + "'}",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Vendor Product Code Deleted Successfully.", "success", { closeOnClientOutside: false }).then(function () {
                    debugger;
                    window.location.reload();
                });
            }
            else {
                swal("Error!", response.d, "error", { closeOnClientOutside: false });
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function UpdateProductVendorInDB(AutoId) {
    if ($("#ddlVendor").val() == '' || $("#ddlVendor").val() == '0') {
        $('#loading').hide();
        toastr.error('Please select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else if ($("#txtVenProductCode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Vendor Product Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtVenProductCode").focus();
        return false;
    }

    data = {
        AutoId: AutoId,
        VendorId: $("#ddlVendor").val(),
        VendorProductCode: $("#txtVenProductCode").val().trim()
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/UpdateProductVendorInDB",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Vendor Product Code Updated Successfully.", "success", { closeOnClientOutside: false }).then(function () {
                    debugger;
                    window.location.reload();
                });
            }
            else {
                swal("Warning!", response.d, "warning", { closeOnClientOutside: false });
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function AddVendorInDB() {
    if ($("#ddlVendor").val() == '' || $("#ddlVendor").val() == '0') {
        $('#loading').hide();
        toastr.error('Please select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else if ($("#txtVenProductCode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Vendor Product Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtVenProductCode").focus();
        return false;
    }

    debugger;
    if (ValidateVendorId() == false) {
        $("#ddlVendor").val('0').select2();
        $("#txtVenProductCode").val('');
        $("#btnUpdateVendor").hide();
        $('#loading').hide();
        toastr.error('Selected Vendor Product Code already added.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
    else {
        data = {
            AutoId: $("#hdnProductId").val(),
            VendorId: $("#ddlVendor").val(),
            VendorProductCode: $("#txtVenProductCode").val().trim()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ProductMaster.aspx/AddVendorInDB",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            beforeSend: function () {
                $('#fade').show();
            },
            complete: function () {
                $('#fade').hide();
            },
            success: function (response) {
                if (response.d == 'true') {
                    swal("Success!", "Vendor Product Code Added Successfully.", "success", { closeOnClientOutside: false }).then(function () {
                        debugger;
                        window.location.reload();
                    });
                }
                else {
                    swal("Warning!", response.d, "warning", { closeOnClientOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error", { closeOnClientOutside: false });
                $('#loading').hide();
            }
        });
    }
}

function ValidateVendorId() {
    debugger;
    var result = true;
    $("#tblVendorProductList tbody tr").each(function () {
        if (($(this).find(".VendorId").text().trim() == $("#ddlVendor").val().trim()) && ($(this).find(".VendorProductCode").text().trim() == $("#txtVenProductCode").val().trim())) {
            result = false;
        }
    });
    return result;
}

function BindAgeRestriction() {
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/BindAgeRestriction",
        data: "{'DeptId':'" + $("#ddlDept").val() + "'}",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                swal("Error!", "Some error occured.", "error", { closeOnClientOutside: false })
            }
            else if (response.d == 'Session') {
                swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var AgeRestId = xml.find("Table");
                $("#ddlAgeRestriction").val($(AgeRestId).find('AgeRestrictionId').text()).select2();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
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
            //if (table == "Product") {
            //    SKUProductDeletedIds += $(e).parent().parent().find(".SKUItemAutoId").text() + ",";
            //}
            //else if (table == "Barcode") {
            //    SKUBarcodeDeletedIds += $(e).parent().parent().find(".BarcodeAutoId").text() + ",";
            //}
            deleteItemrecord1(e, table);
        }
    })
}

function deleteItemrecord1(e, table) {
    $(e).closest('tr').remove();
    //if (table == "Product") {
    //    calc_totalFoot();
    //    swal("", "Product deleted successfully.", "success", { closeOnClickOutside: false });
    //}else
    if (table == "Barcode") {
        fnResetBarcode();
        swal("", "Barcode deleted successfully.", "success", { closeOnClickOutside: false });
    }
}

function fnResetBarcode() {
    $("#txtBarcode").val('');
    $("#btnAddBarcode").show();
    $("#btnAddBarcode1").hide();
    $("#btnBarcodeUpdate").hide();
    $("#btnBarcodeUpdate1").hide();
}

function fnResetBarcodeInUpdate() {
    $("#txtBarcode").val('');
    $("#btnAddBarcode").hide();
    $("#btnAddBarcode1").show();
    $("#btnBarcodeUpdate").hide();
    $("#btnBarcodeUpdate1").hide();
}

function CheckOpenStock(e) {
    if (parseFloat($('#txtInStock').val()) < parseFloat($(e).val())) {
        $('#txtLowStock').val('0');
        toastr.error('Alert Stock QTY must be less than Current Stock QTY.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    }
}

function AddBarcodeInTable() {
    debugger;
    $('#loading').show();
    var validate = 1, i = 0;
    if ($("#txtBarcode").val().trim() == "") {
        validate = 0;
        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").focus();
        return false;
    }
    $("#tblBarcodeListBody tr").each(function (index, item) {
        var x = $(item).find('.Barcode').text();
        if (x == $("#txtBarcode").val().trim()) {
            validate = 0;
            i++;
        }
        //alert(x);
    });
    if (i > 0) {
        toastr.error('Barcode already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").val('');
        $("#txtBarcode").focus();
        return false;
    }
    data = {
        ProductAutoId: 0,
        Barcode: $("#txtBarcode").val().trim().toUpperCase(),
    }

    debugger;
    //
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/ValidateBarcode",
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
            if (response.d == 'true') {
                $('#loading').hide();
                if (validate == 1) {
                    var Barcodetable = '';
                    Barcodetable += '<tr>';
                    Barcodetable += '<td class="Action" style="width: 50px;text-align:center"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditBarcodeInTable(this)" />&nbsp;&nbsp;<a id="deleterow" title="Delete" onclick="deleterow1(this, \'' + 'Barcode' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                    Barcodetable += '<td class="BarcodeAutoId" style="white-space: nowrap;display:none;">0</td>';
                    Barcodetable += '<td class="Barcode" style="white-space: nowrap;text-align:center">' + $("#txtBarcode").val().trim().toUpperCase() + '</td>';
                    Barcodetable += '<td class="ActionId" style="white-space: nowrap;display:none;">1</td>';
                    Barcodetable += '</tr>';
                    $("#tblBarcodeListBody").append(Barcodetable);
                    $("#txtBarcode").val('');
                }
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                $('#loading').hide();
                $("#txtBarcode").val('');
                toastr.error(response.d, 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                $("#txtBarcode").focus();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

//function AddBarcodeInTable() {
//    debugger;
//    var validate = 1, i = 0;
//    if ($("#txtBarcode").val().trim() == "") {
//        validate = 0;
//        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
//        $("#txtBarcode").focus();
//        return false;
//    }
//    $("#tblBarcodeListBody tr").each(function (index, item) {
//        var x = $(item).find('.Barcode').text();
//        if (x == $("#txtBarcode").val().trim()) {
//            validate = 0;
//            i++;
//        }
//        //alert(x);
//    });
//    if (i > 0) {
//        toastr.error('Barcode already exists.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
//        $("#txtBarcode").val('');
//        $("#txtBarcode").focus();
//        return false;
//    }
//    if (validate == 1) {
//        var Barcodetable = '';
//        Barcodetable += '<tr>';
//        Barcodetable += '<td class="Action" style="width: 50px;text-align:center"><img src="/Style/img/edit.png" title="Edit" class="imageButton" onclick="EditBarcodeInTable(this)" />&nbsp;&nbsp;<a id="deleterow" title="Delete" onclick="deleterow1(this, \'' + 'Barcode' + '\')"><span class="fa fa-trash" style="color: red;"></span></a></td>';
//        Barcodetable += '<td class="BarcodeAutoId" style="white-space: nowrap;display:none;">0</td>';
//        Barcodetable += '<td class="Barcode" style="white-space: nowrap;text-align:center">' + $("#txtBarcode").val().trim() + '</td>';
//        Barcodetable += '<td class="ActionId" style="white-space: nowrap;display:none;">1</td>';
//        Barcodetable += '</tr>';
//        $("#tblBarcodeListBody").append(Barcodetable);
//        $("#txtBarcode").val('');
//    }
//}

function DeleteBarcode1(e) {
    debugger;
    var Barcode = $(e).parent().parent().find('.Barcode').text();
    if (Barcode == '') {
        swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
        return false
    }
    else {
        swal({
            title: "Are you sure?",
            text: "You want to delete this Barcode.",
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
                DeleteBarcodeFromDB(Barcode);
            }
        })
    }
}

function DeleteBarcodeFromDB(Barcode) {
    data = {
        ProductAutoId: $("#hdnProductId").val(),
        Barcode: Barcode.trim(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/DeleteBarcodeInDB",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'true') {
                fnResetBarcodeInUpdate();
                swal("Success!", "Barcode deleted successfully.", "success", { closeOnClientOutside: false }).then(function () {
                    window.location.reload();
                });
            }
            else if (response.d == 'Session') {
                swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                swal("Warning!", response.d, "warning", { closeOnClientOutside: false })
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function AddBarcodeInDB() {
    debugger;
    if ($("#txtBarcode").val().trim() == "") {
        validate = 0;
        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").focus();
        return false;
    }

    data = {
        ProductAutoId: $("#hdnProductId").val(),
        Barcode: $("#txtBarcode").val().trim().toUpperCase(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/AddBarcodeInDB",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'true') {
                swal("Success!", "Barcode Added Successfully.", "success", { closeOnClientOutside: false }).then(function () {
                    window.location.reload();
                });
            }
            else if (response.d == 'Session') {
                swal("Warning!", "Session expired.", "warning", { closeOnClientOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                swal("Warning!", response.d, "warning", { closeOnClientOutside: false })
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function EditBarcode1(e) {
    $("#hdnBarcodeForEdit").val($(e).parent().parent().find('.Barcode').text());
    $("#txtBarcode").val($(e).parent().parent().find('.Barcode').text());
    $("#btnAddBarcode").hide();
    $("#btnAddBarcode1").hide();
    $("#btnBarcodeUpdate").hide();
    $("#btnBarcodeUpdate1").show();
}

function UpdateBarcodeInTable1() {
    debugger
    if ($("#txtBarcode").val().trim() == "") {
        validate = 0;
        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").focus();
        return false;
    }
    else if ($("#hdnBarcodeForEdit").val() == '') {
        toastr.error('Some error occured.Please try again.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").val('');
        $("#btnAddBarcode").hide();
        $("#btnAddBarcode1").show();
        $("#btnBarcodeUpdate").hide();
        $("#hdnBarcodeForEdit").val('');
        $("#btnBarcodeUpdate1").hide();
        $("#txtBarcode").focus();
        return false;
    }
    else {
        if ($("#hdnBarcodeForEdit").val().trim() != $("#txtBarcode").val().trim()) {
            data = {
                ProductAutoId: $("#hdnProductId").val(),
                Barcode: $("#txtBarcode").val().trim().toUpperCase(),
                BarcodeForEdit: $("#hdnBarcodeForEdit").val().trim(),
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ProductMaster.aspx/UpdateBarcodeInDB",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
                    if (response.d == 'true') {
                        swal("Success!", "Barcode updated successfully.", "success", { closeOnClientOutside: false }).then(function () {
                            window.location.reload();
                        });
                    }
                    else if (response.d == 'Session') {
                        swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                            window.location.href = '/Default.aspx';
                        });
                    }
                    else {
                        swal("Warning!", response.d, "warning", { closeOnClientOutside: false })
                    }
                    $('#loading').hide();
                },
                error: function (err) {
                    swal("Error!", err.d, "error", { closeOnClientOutside: false });
                    $('#loading').hide();
                },
                failure: function (err) {
                    swal("Error!", err.d, "error", { closeOnClientOutside: false });
                    $('#loading').hide();
                }
            });
        }
        else {
            swal("Success!", "Barcode updated successfully.", "success", { closeOnClientOutside: false }).then(function () {
                $("#txtBarcode").val('');
                $("#btnAddBarcode").hide();
                $("#btnAddBarcode1").show();
                $("#btnBarcodeUpdate").hide();
                $("#hdnBarcodeForEdit").val('');
                $("#btnBarcodeUpdate1").hide();
                $("#txtBarcode").focus();
            });
        }
    }
}

function EditBarcodeInTable(e) {
    $("#txtBarcode").val($(e).parent().parent().find('.Barcode').text());
    //$("#txtVenProductCode").val($(e).parent().parent().find('.VendorProductCode').text());
    $("#btnBarcodeUpdate").attr('onclick', 'UpdateBarcodeInTable(' + $(e).parent().index() + ')');
    $("#btnAddBarcode").hide();
    $("#btnAddBarcode1").hide();
    $("#btnBarcodeUpdate").show();
    $("#btnBarcodeUpdate1").hide();
}

function UpdateBarcodeInTable(index) {
    if ($("#txtBarcode").val().trim() == "") {
        validate = 0;
        toastr.error('Please enter barcode.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtBarcode").focus();
        return false;
    }
    else {
        $("#tblBarcodeList tbody tr:eq(" + index + ")").remove();
        AddBarcodeInTable();
        $("#btnAddBarcode").show();
        $("#btnAddBarcode1").hide();
        $("#btnBarcodeUpdate").hide();
        $("#btnBarcodeUpdate1").hide();
    }
}


function fillsecondPrice(e) {
    debugger;
    if ($(e).val().trim() == '' || isNaN(parseFloat($(e).val().trim()))) {
        $(e).val('0.00')
        $(e).focus();
    }
    else {
        $("#txtSellingPrice").val(parseFloat($(e).val().trim()).toFixed(2));
        $("#txtSecondaryUnitPrice").val(parseFloat($(e).val().trim()).toFixed(2));
    }
}

function ValidateVendorProductCode() {
    debugger;
    if ($("#ddlVendor").val() == "0") {
        validate = 0;
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        //$("#txtBarcode").focus();
        return false;
    }
    else if ($("#txtVenProductCode").val().trim() == "") {
        validate = 0;
        toastr.error('Please enter Vendor Product Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtVenProductCode").focus();
        return false;
    }

    data = {
        //ProductAutoId: $("#hdnProductId").val(),
        VendorId: $("#ddlVendor").val().trim(),
        VendorProductCode: $("#txtVenProductCode").val().trim(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/ValidateVendorProductCode",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
            if (response.d == 'true') {
                swal("Success!", "Barcode Added Successfully.", "success", { closeOnClientOutside: false }).then(function () {
                    window.location.reload();
                });
            }
            else if (response.d == 'Session') {
                swal("Error!", "Session expired.", "error", { closeOnClientOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                swal("Warning!", response.d, "warning", { closeOnClientOutside: false })
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}