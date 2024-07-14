$(document).ready(function () {
    SetCurrency();
    BindStoreList();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    AutoId = getQueryString('PageId');
    if (AutoId != null) {
        editCoupon(AutoId);
    };
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        min: true,
        selectYears: true,
        selectMonths: true,
    });
    var now = new Date(); var today1 = '';
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    var year = now.getFullYear();
    $("#txtStartDate").val(today);
    var day1 = ("0" + now.getDate()).slice(-2);
    var month1 = ("0" + (now.getMonth() + 1)).slice(-2);
    if (year % 4 === 0 && year % 100 != 0) {
        today1 = (month1) + "/" + (day1) + "/" + (now.getFullYear() + 1);
        
    }
    if (year % 4 === 0 && year % 100 != 0 && year % 400 === 0) {
         today1 = (month1) + "/" + (day1) + "/" + (now.getFullYear() + 1);
    }
    else {
        day1 = ("0" + (now.getDate() - 1)).slice(-2);
         today1 = (month1) + "/" + (day1) + "/" + (now.getFullYear() + 1);
    }

    $("#txtEndDate").val(today1);

    $('#ddlCouponType').on('change', function () {
        var Ctype = $('#ddlCouponType').val();
        if (Ctype == 0) {
            $('.spn_disc1').show();
            $('.spn_disc').hide();
            $('#txtDiscount').attr('Placeholder', '0.000');
            $('#txtDiscount').attr('value', '0.000');
        }
        else if (Ctype == 1) {
            $('.spn_disc').show();
            $('.spn_disc1').hide();
            $('#txtDiscount').attr('Placeholder', '0.00');
            $('#txtDiscount').attr('value', '0.00');
        }
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

function Changedisc() {

    if ($('#ddlCouponType').val() == 0) {
        $('#txtDiscount').val('0.000');
    }
    else {
        $('#txtDiscount').val('0.00');
    }

}

function Checkdisc(e) {
    var Amt = parseFloat($(e).val());
    if ($('#ddlCouponType').val() == 0) {
        if (Amt > 100) {
            $('#txtDiscount').val('0.000');
        }
    }
}
function BindStoreList() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/CouponMaster.aspx/BindStoreList",
        data: "",
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
                swal("Success!", response.d, "success", { closeOnClickOutside: false });
                BindCouponList(1);
                Reset();
            }
            else if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StoreList = xml.find("Table");
                var html = "";
                html += '<div class="col-md-4" style="padding-left:15px" id="divAllStore">';
                html += '<input class="form-check-input"  type="checkbox" onchange="selectAll()" name="AllStore" value="0" id="AllflexCheckDefault">';
                html += '&nbsp;&nbsp;<label class="form-check-label" for="flexCheckDefault">All Stores</label>';
                html += '</div>';
                $.each(StoreList, function () {
                    debugger
                    html += '<div class="col-md-4">';
                    html += '<input class="form-check-input flexCheckDefault" type="checkbox" name="Store" value="' + $(this).find('AutoId').text() + '" id="flexCheckDefault">';
                    html += '&nbsp;&nbsp;<label class="form-check-label" for="flexCheckDefault">' + $(this).find('CompanyName').text() + '</label>';
                    html += '</div>';
                });
                $('#divStoreList').html(html);

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

function AddCoupon() {
    debugger
    var validate = 1;
    if ($("#txtCouponCode").val().trim() == "") {
        toastr.error('Coupon code required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtCouponCode").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#ddlCouponType").val().trim() == "2") {
        toastr.error('Coupon Type required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#ddlCouponType").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtDiscount").val().trim() == "" || parseFloat($("#txtDiscount").val()) == 0) {
        toastr.error('Discount required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscount").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtStartDate").val().trim() == "") {
        toastr.error('Start Date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtStartDate").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtEndDate").val().trim() == "") {
        toastr.error('End Date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEndDate").addClass('border-warning');
        validate = 0;
        return false;
    }
    if (Date.parse($("#txtEndDate").val().trim()) < Date.parse($("#txtStartDate").val().trim())) {
        toastr.error('End Date should be greater then Start Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEndDate").addClass('border-warning');
        validate = 0;
        return false;
    }

    if ($("#ddlCouponType").val() == "1" && parseFloat($("#txtAmount").val().trim()) < parseFloat($("#txtDiscount").val().trim())) {
        // if (parseFloat($("#txtAmount").val().trim()) > parseFloat($("#txtDiscount").val().trim())) {
        toastr.error('Discount should be less than or equil to Minimum Order Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
        //}
    }
    if (validate == 1) {
        debugger;
        data = {
            Couponcode: $('#txtCouponCode').val().trim(),
            CouponDescription: $('#txtDiscription').val().trim(),
            TermsDescription: $('#txtTermsDescription').val().trim(),
            CouponType: $("#ddlCouponType").val().trim(),
            Discount: $("#txtDiscount").val().trim(),
            Amount: $("#txtAmount").val().trim() || 0,
            StartDate: $("#txtStartDate").val().trim(),
            EndDate: $("#txtEndDate").val().trim(),
            Status: $("#ddlStatus").val(),
            /*StoreIdString: StoreIdString*/
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CouponMaster.aspx/AddCoupon",
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
                    swal("Success!", "Coupon details added successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                    });
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
}


function UpdateCoupon() {
    debugger;
    /* $('#loading').show();*/
    var validate = 1;
    if ($("#txtCouponCode").val().trim() == "") {
        toastr.error('Coupon code required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtCouponCode").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#ddlCouponType").val().trim() == "2") {
        toastr.error('Coupon Type required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#ddlCouponType").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtDiscount").val().trim() == "" || parseFloat($("#txtDiscount").val()) == 0) {
        toastr.error('Discount required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscount").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtStartDate").val().trim() == "") {
        toastr.error('Start Date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtStartDate").addClass('border-warning');
        validate = 0;
        return false;
    }
    if ($("#txtEndDate").val().trim() == "") {
        toastr.error('End Date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEndDate").addClass('border-warning');
        validate = 0;
        return false;
    }
    if (Date.parse($("#txtEndDate").val().trim()) < Date.parse($("#txtStartDate").val().trim())) {
        toastr.error('End Date should be greater then Start Date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtEndDate").addClass('border-warning');
        validate = 0;
        return false;
    }

    if ($("#ddlCouponType").val() == "1" && parseFloat($("#txtAmount").val().trim()) < parseFloat($("#txtDiscount").val().trim())) {
        // if (parseFloat($("#txtAmount").val().trim()) > parseFloat($("#txtDiscount").val().trim())) {
        toastr.error('Discount should be less than Minimum Order Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
        //}
    }

    //var StoreIds = [], StoreIdString = '';
    //$("input:checkbox[name=Store]:checked").each(function () {
    //    debugger;
    //    StoreIds.push($(this).val());
    //});
    //StoreIdString = StoreIds.join();
    //if (StoreIdString == null || StoreIdString == '') {
    //    toastr.error('Please Select Atleast one Store.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if (validate == 1) {
        debugger;

        data = {
            CouponAutoId: $("#hdnCouponId").val(),
            Couponcode: $('#txtCouponCode').val().trim(),
            CouponDescription: $('#txtDiscription').val().trim(),
            TermsDescription: $('#txtTermsDescription').val().trim(),
            CouponType: $("#ddlCouponType").val().trim(),
            Discount: $("#txtDiscount").val().trim(),
            Amount: $("#txtAmount").val().trim() || 0,
            StartDate: $("#txtStartDate").val().trim(),
            EndDate: $("#txtEndDate").val().trim(),
            Status: $("#ddlStatus").val(),
            /* StoreIdString: StoreIdString*/
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ShowCouponMaster.aspx/UpdateCoupon",
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
                    swal("Success!", "Coupon details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                        $('#loading').hide();
                    });
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
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
        })
    }
}

function Reset() {
    $("#txtCouponCode").val('');
    $('#txtDiscription').val('');
    $('#txtTermsDescription').val('');
    $("#txtDiscount").val('');
    $("#ddlCouponType").val(2);
    $("#txtAmount").val('');
    //$("#txtStartDate").val('');
    //$("#txtEndDate").val('');
    $("#hdnCouponId").val('');
    $("input:checkbox[name=Store]").each(function () {
        debugger;
        $(this).attr('checked', false);
    });
    $("#ddlStatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}

function editCoupon(id) {
    debugger;
    /*$('#loading').show();*/
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowCouponMaster.aspx/editCoupon",
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
                var CouponDetail = xml.find("Table"), StorIds = [];
                $("#hdnCouponId").val(id);
                $("#txtCouponCode").val($(CouponDetail).find('CouponCode').text());
                $("#txtDiscription").val($(CouponDetail).find('CouponName').text());
                $("#txtTermsDescription").val($(CouponDetail).find('TermsAndDescription').text());
                $("#ddlCouponType").val($(CouponDetail).find('CouponType').text());
                if ($(CouponDetail).find('CouponType').text() == 0) {
                    $('.spn_disc1').show();
                    $('.spn_disc').hide();
                }
                else {
                    $('.spn_disc').show();
                    $('.spn_disc1').hide();
                }
                $("#txtDiscount").val($(CouponDetail).find('Discount').text());
                $("#txtAmount").val($(CouponDetail).find('CouponAmount').text());
                $("#txtStartDate").val($(CouponDetail).find('StartDate').text());
                $("#txtEndDate").val($(CouponDetail).find('EndDate').text());
                $("#ddlStatus").val($(CouponDetail).find('Status').text());
                StorIds = ($(CouponDetail).find('StoreIds').text()).split(',');
                $("input:checkbox[name=Store]").each(function () {
                    debugger;
                    if (StorIds.includes($(this).val())) {
                        $(this).attr('checked', true);
                    }
                });
                debugger
                if ($('#flexCheckDefault:checked').length == $('.flexCheckDefault').length) {
                    $('#AllflexCheckDefault').attr('checked', true);
                }
                $("#btnSave").hide();
                $("#btnUpdate").show();
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