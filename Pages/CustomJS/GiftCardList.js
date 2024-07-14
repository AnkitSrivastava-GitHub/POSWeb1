$(document).ready(function () {
    SetCurrency();
    BindCouponList(1);
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
    });
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/CouponMaster.aspx/CurrencySymbol",
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
    BindCouponList(parseInt($(e).attr("page")));
};

function BindCouponList(pageIndex) {
    debugger;
    $('#loading').show();
    if ($("#txtStartDate").val().trim() != '' && $("#txtEndDate").val().trim() && (Date.parse($("#txtStartDate").val()) > Date.parse($("#txtEndDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
   
    data = {
        Couponcode: $('#txtSCouponCode').val(),
        StartDate: $("#txtStartDate").val(),
        EndDate: $("#txtEndDate").val(),
        Status: $("#ddlSStatus").val(),
        UseStatus: $("#ddlUsed").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowCouponMaster.aspx/BindCouponList",
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
                var CouponList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (CouponList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spSortBy").show();
                    $("#EmptyTable").hide();
                    $("#tblCouponList tbody tr").remove();
                    var row = $("#tblCouponList thead tr:first-child").clone(true);
                    $.each(CouponList, function () {
                        debugger;
                        status = '';
                        $(".CouponAutoId", row).html($(this).find("AutoId").text());
                        $(".CouponName", row).html($(this).find("CouponName").text());
                        //$(".CouponType", row).html($(this).find("CouponType").text());
                        if ($(this).find("CouponType").text() == 0) {
                            $(".Discount", row).html($(this).find("Discount").text() + '%');
                            $(".CouponType", row).html('Percentage');
                        }
                        else {
                            $(".Discount", row).html(CSymbol + $(this).find("Discount").text());
                            $(".CouponType", row).html('Fixed');
                        }
                        $(".MinAmount", row).html($(this).find("CouponAmount").text());
                        $(".StartDate", row).html($(this).find("StartDate").text());
                        $(".EndDate", row).html($(this).find("EndDate").text());
                        $(".CouponCode", row).html($(this).find("CouponCode").text());
                        $(".Created", row).html($(this).find("CreationDetails").text());
                        $(".Updated", row).html($(this).find("UpdationDetails").text());
                        //if ($(this).find("Applied").text() == '1') {
                        //    //$(".Used", row).html('Yes');
                        //    $(".Action", row).html("<a id='btnDeleteCoupun' onclick='isDeleteCoupon(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;");
                        //}
                        //else {
                        //$(".Used", row).html('No');
                        //$(".Action", row).html("<a id='btnDeleteCoupun' onclick='isDeleteCoupon(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' href='/Pages/CouponMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' href='/Pages/CouponMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteCoupun' onclick='isDeleteCoupon(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        //}
                        $(".TermsAndDescription", row).html($(this).find("TermsAndDescription").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);

                        $("#tblCouponList").append(row);
                        row = $("#tblCouponList tbody tr:last-child").clone(true);
                    });
                    $("#tblCouponList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblCouponList").hide();
                    $("#spSortBy").hide();
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

function isDeleteCoupon(id) {
    debugger;
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Coupon.",
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
                closeModal: false
            }
        },
    }).then((isConfirm) => {
        if (isConfirm) {
            data = {
                CouponAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ShowCouponMaster.aspx/DeleteCoupon",
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
                        swal("Success!", "Coupon deleted successfully.", "success", { closeOnClickOutside: false });
                        BindCouponList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false });
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
        else {
            $('#loading').hide();
            //swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}


