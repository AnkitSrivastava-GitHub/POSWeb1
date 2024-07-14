$(document).ready(function () {
    SetCurrency();
    BindMixNMatchList(1);

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

function Pagevalue(e) {
    if ($(e).parent().attr("id") == "Pager") {
        BindMixNMatchList(parseInt($(e).attr("page")));
    }
    if ($(e).parent().attr("id") == "GroupItemListPager") {
        ViewGroupItemList(parseInt($(e).attr("page")));
    }
}


function BindMixNMatchList(pageIndex) {
    data = {
        GroupName: $('#txtGroupName').val().trim(),
        GroupStatus: $("#ddlGroupStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: 'POST',
        url: '/Pages/MixNMatchList.aspx/MixNMatchList',
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        // async: false,
        dataType: 'json',
        contentType: 'application/json;charset=utf-8',
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                swal('Warning!', 'Session Expired.', 'warning', { closeOnClickOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var GroupList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (GroupList.length > 0) {
                    if (pager.length > 0) {
                        $("#spMixNMatchSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spMixNMatchSortBy").show();
                    $("#MixNMatchEmptyTable").hide();
                    $("#tblMixNMatchList tbody tr").remove();
                    var row = $("#tblMixNMatchList thead tr:first-child").clone(true);
                    $.each(GroupList, function () {
                        debugger;
                        status = '';
                        $(".MixNMatchAutoId", row).html($(this).find("AutoId").text());
                        $(".GroupName", row).html($(this).find("GroupName").text());
                        $(".MixQty", row).html($(this).find("MinQty").text());
                        $(".DiscountType", row).html($(this).find("DisType").text());
                        $(".CreationDetails", row).html($(this).find("CreationDetail").text());
                        $(".Action", row).html("<a style='' href='/Pages/ProductGroup.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;<a id='btnDeleteCoupun' onclick='DeleteGroup(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;<a title='View Products' onclick='ViewGroupItemList1(" + $(this).find("AutoId").text() + ")' ><img src='/Style/img/View.png' title='View Product List' class='imageButton' style='height: 20px;width: 20px;' /></a>");
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);

                        $("#tblMixNMatchList").append(row);
                        row = $("#tblMixNMatchList tbody tr:last-child").clone(true);
                    });
                    $("#tblMixNMatchList").show();
                }
                else {
                    $("#MixNMatchEmptyTable").show();
                    $("#tblMixNMatchList").hide();
                    $("#spMixNMatchSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt($(pager).find("PageIndex").text()),
                    PageSize: parseInt($(pager).find("PageSize").text()),
                    RecordCount: parseInt($(pager).find("RecordCount").text())
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
var GroupId = 0;

function ViewGroupItemList1(GroupId1) {
    debugger;
    GroupId = GroupId1;
    ViewGroupItemList(1);
}
function ViewGroupItemList(pageIndex) {
    debugger;
    data = {
        GroupId: GroupId,
        pageIndex: pageIndex,
        PageSize: $("#ddlGroupItemListPageSize").val(),
    }
    $.ajax({
        type: 'POST',
        url: '/Pages/MixNMatchList.aspx/GroupItemList',
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        // async: false,
        dataType: 'json',
        contentType: 'application/json;charset=utf-8',
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else if (response.d == 'Session') {
                swal('Warning!', 'Session Expired.', 'warning', { closeOnClickOutside: false }).then(function () {
                    window.location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var GroupItemList = xml.find("Table1");
                var pager = xml.find("Table");
                var DisTypeId = xml.find("Table2");
                $('#hdnDiscountTypeId').val($(DisTypeId).find('DiscountType').text());
                $('#hdnDiscountVal').val($(DisTypeId).find('DiscountVal').text());
                if (GroupItemList.length > 0) {
                    if (pager.length > 0) {
                        $("#spGroupItemListSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlGroupItemListPageSize').show();
                    }
                    else {
                        $('#ddlGroupItemListPageSize').hide();
                    }
                    $("#spGroupItemListSortBy").show();
                    $("#GroupItemListEmptyTable").hide();
                    $("#tblGroupItemList tbody tr").remove();
                    var row = $("#tblGroupItemList thead tr:first-child").clone(true);
                    $.each(GroupItemList, function () {
                        debugger;
                        status = '';
                        $(".ItemAutoId", row).html($(this).find("AutoId").text());
                        $(".Department", row).html($(this).find("DepartmentName").text());
                        $(".Category1", row).html($(this).find("CategoryName").text());
                        $(".SKUName", row).html($(this).find("SKUPackingName").text());
                        $(".Unitprice", row).html($(this).find("OrgUnitPrice").text());
                        $(".UnitDiscount", row).html($(this).find("Discount").text());
                        $(".UnitDiscountP", row).html($(this).find("DiscountP").text());
                        $(".DiscountedUnitPrice", row).html($(this).find("DiscountedUnitedPrice").text());
                        $(".TaxPer", row).html($(this).find("TaxPer").text());
                        $(".Tax", row).html($(this).find("Tax").text());
                        $(".Total", row).html($(this).find("Total").text());
                        $(".Action", row).html("<a id='btnDeleteCoupun' onclick='' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblGroupItemList").append(row);
                        row = $("#tblGroupItemList tbody tr:last-child").clone(true);
                    });
                    cal_TotalPrice();
                    $("#tblGroupItemList").show();
                }
                else {
                    $("#GroupItemListEmptyTable").show();
                    $("#tblGroupItemList").hide();
                    $("#spGroupItemListSortBy").hide();
                    $("#ddlGroupItemListPageSize").hide();
                }
                $("#GroupItemListPager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt($(pager).find("PageIndex").text()),
                    PageSize: parseInt($(pager).find("PageSize").text()),
                    RecordCount: parseInt($(pager).find("RecordCount").text())
                });
                if ($('#ddlGroupItemListPageSize').val() == '0') {
                    $('#GroupItemListPager').hide();
                }
                else {
                    $('#GroupItemListPager').show();
                }
                $("#ModalGroupItemList").modal('show');
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

function cal_TotalPrice() {
    debugger;
    var UnitPrice = 0, DiscountAmt = 0, DiscountPer = 0, TaxPer = 0, TaxAmt = 0, DiscountUnitPrice = 0, TotalPrice = 0;
    if ($("#hdnDiscountTypeId").val() == '0') {
        $("#tblGroupItemList tbody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            DiscountAmt = 0;
            DiscountPer = 0;
            DiscountUnitPrice = UnitPrice - DiscountAmt;
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = DiscountUnitPrice + TaxAmt;
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    else if ($("#hdnDiscountTypeId").val() == '1') {
        $("#tblGroupItemList tbody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            DiscountAmt = $('#hdnDiscountVal').val().trim();
            if (parseFloat(UnitPrice) < parseFloat(DiscountAmt)) {
                DiscountPer = 100;
                DiscountUnitPrice = 0;
            }
            else {
                DiscountPer = (DiscountAmt * 100) / UnitPrice;
                DiscountUnitPrice = parseFloat(UnitPrice) - parseFloat(DiscountAmt);
            }
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = DiscountUnitPrice + TaxAmt;
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    else if ($("#hdnDiscountTypeId").val() == '2') {
        $("#tblGroupItemList tbody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            //DiscountAmt = $('#txtDiscountAmount').val().trim();
            DiscountPer = $('#hdnDiscountVal').val().trim();
            DiscountAmt = (UnitPrice * DiscountPer) / 100;
            DiscountUnitPrice = UnitPrice - DiscountAmt;
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = DiscountUnitPrice + TaxAmt;
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    else if ($("#hdnDiscountTypeId").val() == '3') {
        $("#tblGroupItemList tbody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            //DiscountAmt = $('#txtDiscountAmount').val().trim();
            //DiscountPer = $('#txtDiscountPer').val().trim();
            DiscountUnitPrice = $('#hdnDiscountVal').val().trim();
            if (parseFloat(UnitPrice) < parseFloat(DiscountUnitPrice)) {
                DiscountAmt = 0;
                DiscountPer = 0;
                //TaxAmt = 0;
            }
            else {
                DiscountAmt = UnitPrice - parseFloat(DiscountUnitPrice);
                DiscountPer = (DiscountAmt * 100) / UnitPrice;
            }
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = parseFloat(DiscountUnitPrice) + parseFloat(TaxAmt);
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
}

function DeleteGroup(GId) {
    var TextString = 'You want to Delete.';
    var span = document.createElement("span");
    span.innerHTML = TextString;
    swal({
        title: "Are You Sure?",
        content: span,
        allowOutsideClick: "false",
        icon: "warning",
        buttons: {
            cancel: {
                text: "No, Cancel",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes, Proceed",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            DeleteMixNMatchGroup(GId);
        }
        //else {


        //}
    });
}

function DeleteMixNMatchGroup(GId) {
    $.ajax({
        type: "POST",
        url: "/Pages/MixNMatchList.aspx/DeleteGroup",
        data: "{'GroupId':'" + GId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Product deleted successfully.", "success", { closeOnClickOutside: false });
                BindMixNMatchList(1);
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
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
    })
}