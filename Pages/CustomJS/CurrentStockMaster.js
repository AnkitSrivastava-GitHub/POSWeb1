$(document).ready(function () {
    BindVendor();
    BindCurrentStockList(1);
});

function BindVendor() {
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/BindProduct",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Product Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var VendorList = xml.find("Table1");
                $("#ddlVendor option").remove();
                $("#ddlVendor").append('<option value="0">All Vendor</option>');
                $.each(VendorList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text()));
                });
                $("#ddlVendor").select2();
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

function Pagevalue(e) {
    BindCurrentStockList(parseInt($(e).attr("page")));
};

function BindCurrentStockList(pageIndex) {
    data = {
        InvoiceNo: $('#txtInvoiceNumber').val().trim(),
        PONumber: $('#txtPONumber').val().trim(),
        VendorAutoId: $('#ddlVendor').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/InvoiceList.aspx/BindInvoiceList",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Invoice Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var pager = xml.find("Table");
                var InvoiceList = xml.find("Table1");
                var status = "";
                if (InvoiceList.length > 0) {
                    if (pager.length > 0) {
                        $("#spInvoiceSortBy").text($(pager).find("SortByString").text());
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
                    $("#tblPreviousStockList").show();
                    $("#tblInvoiceList tbody tr").remove();
                    var row = $("#tblInvoiceList thead tr:first-child").clone(true);
                    $.each(InvoiceList, function () {
                        status = '';
                        $(".InvoiceAutoId", row).html($(this).find("AutoId").text());
                        $(".InvoiceNumber", row).html($(this).find("InvoiceNo").text());
                        $(".PONumber", row).html($(this).find("PoNumber").text());
                        $(".BatchNumber", row).html($(this).find("BatchNo").text());
                        $(".Vendor", row).html($(this).find("VendorName").text());
                        $(".InvoiceDate", row).html($(this).find("InvoiceDate").text());
                        $(".POItems", row).html("<a title='View Invoice Items' style='cursor:pointer;' onclick='ViewInvoiceItem(" + $(this).find("AutoId").text() + ")'>View Items</a>");
                        
                        $(".UpdationDetails", row).html($(this).find("UpdationDetails").text());
                        
                        $(".Action", row).html("<a style='' onclick='OpenStock(" + $(this).find("AutoId").text() + ");'><img src='/Style/img/View.png' title='Edit' class='imageButton' /></a>");
                        
                        $("#tblInvoiceList").append(row);
                        row = $("#tblInvoiceList tbody tr:last-child").clone(true);
                    });
                    $("#tblInvoiceList").show();
                }
                else {
                    $("#InvoiceEmptyTable").show(); 
                    $("#tblPreviousStockList").hide();
                    $("#tblInvoiceList").hide();
                    $("#spInvoiceSortBy").hide();
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
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function ViewInvoiceItem(Id) {
    $.ajax({
        type: "POST",
        url: "/Pages/InvoiceList.aspx/ViewInvoiceItem2",
        data: "{'InvoiceAutoId':'" + Id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Unit Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var InvoiceProductList = xml.find("Table");
                if (InvoiceProductList.length > 0) {
                    $("#InvoiceProductEmptyTable").hide();
                    $("#tblInvoiceProductList tbody tr").remove();
                    var row = $("#tblInvoiceProductList thead tr:first-child").clone(true);
                    $.each(InvoiceProductList, function () {
                        $(".InvoiceItemAutoId", row).html($(this).find("AutoId").text());
                        $(".ProductAutoId", row).html($(this).find("ProductId").text());
                        $(".ProductName", row).html($(this).find("ProductName").text());
                        $(".UnitType", row).html($(this).find("PackingName").text());
                        $(".UnitAutoId", row).html($(this).find("PackingId").text());
                        $(".Quantity", row).html($(this).find("ReceivedQty").text());   
                        $(".SellingUnitCost", row).html($(this).find("ProductUnitPrice").text()).css('text-align', 'right');
                        $(".SecondaryCost", row).html(parseFloat($(this).find("SecUnitPrice").text()).toFixed(2)).css('text-align', 'right');
                        $(".PreviousCost", row).html(parseFloat($(this).find("CostPrice").text()).toFixed(2)).css('text-align', 'right');
                        $(".SUnitPrice", row).html(parseFloat($(this).find("UnitPrice").text()).toFixed(2)).css('text-align', 'right');
                        $(".Tax", row).html($(this).find("Tax").text()).css('text-align', 'right');
                        $(".Total", row).html(parseFloat($(this).find("Total").text()).toFixed(2)).css('text-align', 'right');
                        $(".CreatedDate", row).html($(this).find("CreatedDate").text());                        
                        $("#tblInvoiceProductList").append(row);
                        row = $("#tblInvoiceProductList tbody tr:last-child").clone(true);
                    });
                    $("#tblInvoiceProductList").show();
                }
                else {
                    $("#InvoiceProductEmptyTable").show();
                    $("#tblInvoiceProductList").hide();
                }
                $('#InvoiceProductListModal').modal('show');
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

function OpenStock(Id) {
    $('#PreviousStockModal').modal('show');
    ViewStockProduct(Id);
}

function ViewStockProduct(Id) {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/InvoiceList.aspx/ViewStockProduct",
        data: "{'InvoiceAutoId':'" + Id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger
            if (response.d == 'false') {
                swal("", "No Stock Details Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var InvoiceList = xml.find("Table");
                //var InvoiceList = xml.find("Table1");
                var status = "";
                if (InvoiceList.length > 0) {
                    $("#PreviousStockEmptyTable").hide();
                    $("#PreviousStockModal tbody tr").remove();
                    var row = $("#PreviousStockModal thead tr:first-child").clone(true);
                    $.each(InvoiceList, function () {
                        status = '';
                        $(".ProductAutoId", row).html($(this).find("AutoId").text());
                        $(".ProductName", row).html($(this).find("ProductName").text());
                        $(".PreviousStock", row).html($(this).find("PreviousStock").text());
                        $(".PurchaseStock", row).html($(this).find("PurchaseStock").text());
                        $(".EffectedStock", row).html($(this).find("EffectedStock").text());

                        $("#tblPreviousStockList").append(row);
                        row = $("#tblPreviousStockList tbody tr:last-child").clone(true);
                    });
                    $("#PreviousStockModal").show();
                }
                else {
                    $("#PreviousStockEmptyTable").show();
                    $("#PreviousStockModal").hide();                    
                }
                //$(".Pager").ASPSnippets_Pager({
                //    ActiveCssClass: "current",
                //    PagerCssClass: "pager",
                //    PageIndex: parseInt(pager.find("PageIndex").text()),
                //    PageSize: parseInt(pager.find("PageSize").text()),
                //    RecordCount: parseInt(pager.find("RecordCount").text())
                //});
                //if ($('#ddlPageSize').val() == '0') {
                //    $('#Pager').hide();
                //}
                //else {
                //    $('#Pager').show();
                //}
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



