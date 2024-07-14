$(document).ready(function () {
    SetCurrency();
    //BindSKUDropdown();
    /*$('#ddlSKUStatus').select2();*/
    BindSKUList(1);
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

function Pagevalue(e) {
    BindSKUList(parseInt($(e).attr("page")));
};

function RemoveSpace(e) {
    debugger;
    $(e).val($(e).val().replace(/\s/g, ''));
}
function BindSKUList(pageIndex) {
    debugger;
    data = {
        SKUName: $('#ddlSKU').val(),
        Status: $('#ddlSKUStatus').val(),
        SKUBarcode: $('#txtSKUBarcode').val().trim(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SKUList.aspx/BindSKUList",
        data: JSON.stringify({ dataValues: JSON.stringify(data)}),
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
                var pager = xml.find("Table");
                var SKUList = xml.find("Table1");
                var status = "";
                if (SKUList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSKUSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spSKUSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#SKUEmptyTable").hide();
                    $("#tblSKUList tbody tr").remove();
                    var row = $("#tblSKUList thead tr:first-child").clone(true);
                    $.each(SKUList, function () {
                        debugger;
                        status = '';
                        $(".SKUAutoId", row).html($(this).find("AutoId").text());
                        $(".SKUId", row).html($(this).find("SKUId").text());
                        $(".SKU_Barcode", row).html($(this).find("Barcode").text());
                        $(".SKU_Name", row).html($(this).find("SKUName").text());
                        $(".SKU_Description", row).html($(this).find("Description").text());
                        $(".SKU_UnitPrice", row).html($(this).find("SKUUnitTotal").text()).css('text-align','right');
                        $(".SKU_Discount", row).html($(this).find("TotalDiscount").text()).css('text-align', 'right');

                        $(".SKU_SubTotal", row).html($(this).find("SKUSubTotal").text()).css('text-align', 'right');

                        $(".SKU_Tax", row).html($(this).find("SKUTotalTax").text()).css('text-align', 'right');
                        
                        $(".SKU_Total", row).html($(this).find("SKUTotal").text()).css('text-align', 'right');
                        $(".CreatedDetails", row).html($(this).find("CreationDetails").text());
                        $(".UpdationDetails", row).html($(this).find("UpdationDetails").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".SKU_Status", row).html(status);
                        $(".Action", row).html("<a style='' href='/Pages/SKUMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a style='height:20px;width:20px' onclick='GetBarcodeList(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/View.png' height='20' width='20' title='View Barcode' class='' /></a>");
                        $("#tblSKUList").append(row);
                        row = $("#tblSKUList tbody tr:last-child").clone(true);
                    });
                    $("#tblSKUList").show();
                }
                else {
                    $("#SKUEmptyTable").show();
                    $("#tblSKUList").hide();
                    $("#spSKUSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSize').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
            }
            $('#loading').hide();
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
function GetBarcodeList(SKUid) {
    $.ajax({
        type: "POST",
        url: "/Pages/SKUList.aspx/GetBarcodeList",
        data: "{'SKUId':'" + SKUid + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            debugger;
            var xmldoc = $.parseXML(response.d);
            var xml = $(xmldoc);
            var BarcodeList = xml.find("Table");
            var SKUName = xml.find("Table1");
            $("#spnSKUName").text($(SKUName).find('SKUName').text());
            var i = 1;
            if (BarcodeList.length > 0) {
                $("#emptyTable1").hide();
                $("#tblBarcodeList tbody tr").remove();
                var row = $("#tblBarcodeList thead tr:first-child").clone(true);
                $.each(BarcodeList, function () {
                    debugger;
                    $(".SNO", row).html(i);
                    $(".Barcode", row).html($(this).find("Barcode").text());
                    $("#tblBarcodeList").append(row);
                    row = $("#tblBarcodeList tbody tr:last-child").clone(true);
                    i++;
                });
                $("#tblBarcodeList").show();
                $('#ModalBarcode').modal('show');
            }
            else {
                $("#emptyTable1").show();
                $("#tblBarcodeList").hide();
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

function BindSKUDropdown() {
    $.ajax({
        type: "POST",
        url: "/Pages/SKUList.aspx/BindSKUDropdown",
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
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ProductList = xml.find("Table");
                $("#ddlSKU option").remove();
                $("#ddlSKU").append('<option value="0">Select SKU</option>');
                $.each(ProductList, function () {
                    $("#ddlSKU").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("SKUName").text()));
                });
                $("#ddlSKU").select2();
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