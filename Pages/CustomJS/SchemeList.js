$(document).ready(function () {
    SetCurrency();
    BindSKU();
    $('#ddlS_SchemeStatus').select2();
    BindSchemeList(1);

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

function BindSKU() {
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeList.aspx/BindSKU",
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

                    var PType = $("#ddlS_SKUList1"); var ProVal = 0;
                    $("#ddlS_SKUList1 option:not(:first)").remove();
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
                    $("#ddlS_SKUList1").select2();
                    $("#ddlS_SKUList1").val(ProVal).change();
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

function Pagevalue(e) {
    BindSchemeList(parseInt($(e).attr("page")));
};

function BindSchemeList(pageIndex) {
    data = {
        SKUAutoId: $('#ddlS_SKUList1').val(),
        SchemeName: $('#txtS_SchemeName').val(),
        Status: $('#ddlS_SchemeStatus').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeList.aspx/BindSchemeList",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClientOutside: false });
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
                        $("#spSchemeSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spSchemeSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#SchemeEmptyTable").hide();
                    $("#tblSchemeList tbody tr").remove();
                    var row = $("#tblSchemeList thead tr:first-child").clone(true);
                    $.each(SKUList, function () {
                        debugger;
                        status = '';
                        $(".SchemeAutoId", row).html($(this).find("AutoId").text());
                        $(".Scheme_Name", row).html($(this).find("SchemeName").text());
                        $(".SKU_Name", row).html($(this).find("SKUName").text());
                        $(".Quantity", row).html($(this).find("Quantity").text());
                        $(".SKUUnitPrice", row).html($(this).find("SKUUnitPrice").text()).css('text-align', 'right');
                        $(".Scheme_Tax", row).html($(this).find("Tax").text()).css('text-align', 'right');
                        $(".Scheme_Discount", row).html($(this).find("Discount").text()).css('text-align', 'right');
                        $(".Scheme_UnitPrice", row).html($(this).find("SchemePrice").text()).css('text-align', 'right');
                        $(".CreatedDetails", row).html($(this).find("CreationDetails").text());
                        $(".UpdationDetails", row).html($(this).find("UpdationDetails").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Sheme_Status", row).html(status);
                        $(".Action", row).html("<a style='' href='/Pages/SchemeMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblSchemeList").append(row);
                        row = $("#tblSchemeList tbody tr:last-child").clone(true);
                    });
                    $("#tblSchemeList").show();
                }
                else {
                    $("#SchemeEmptyTable").show();
                    $("#tblSchemeList").hide();
                    $("#spSchemeSortBy").hide();
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
