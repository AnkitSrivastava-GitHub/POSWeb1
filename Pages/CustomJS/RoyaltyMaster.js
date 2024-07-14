$(document).ready(function () {
    SetCurrency();
    BindRoyaltyList();
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/RoyaltyMaster.aspx/CurrencySymbol",
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

function UpdateRoyalty() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtAmtPerRoyaltyPoint").val().trim() == '' || parseFloat($("#txtAmtPerRoyaltyPoint").val().trim()) <= 0) {
        $('#loading').hide();
        toastr.error('Please Fill Amount Per Reward  Point.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtMinOrderAmt").val().trim()) <= 0 || $("#txtMinOrderAmt").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Minimum Order Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {
        data = {
            AmtPerRoyaltyPoint: parseFloat($("#txtAmtPerRoyaltyPoint").val()).toFixed(2),
            MinOrderAmt: $("#txtMinOrderAmt").val(),
            Royaltytatus: $("#ddlStatus").val(),
            RoyaltyId: $("#hdnRoyaltyId").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/RoyaltyMaster.aspx/UpdateRoyalty",
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
                    BindRoyaltyList();
                    swal("Success!", "Reward  details updated successfully.", "success", { closeOnClickOutside: false });
                    //BindSafeCashList(1);
                    //Reset();
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

function UpdateAmtRoyalty() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtRoyaltyApointsAsPerAmt").val().trim() == '' || parseFloat($("#txtRoyaltyApointsAsPerAmt").val().trim()) <= 0) {
        $('#loading').hide();
        toastr.error('Please Fill Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtRoyaltyPoints").val().trim()) <= 0 || $("#txtRoyaltyPoints").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Reward  Points.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtMinOrderAmtForRoyalty").val().trim()) <= 0 || $("#txtMinOrderAmtForRoyalty").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Please Fill Minimum Order Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {
        data = {
            RoyaltyApointsAsPerAmt: parseFloat($("#txtRoyaltyApointsAsPerAmt").val()).toFixed(2),
            MinOrderAmtForRoyalty: parseFloat($("#txtMinOrderAmtForRoyalty").val()).toFixed(2),
            RoyaltyPoints: $("#txtRoyaltyPoints").val().trim(),
            AmtRoyaltyStatus: $("#ddlAmtRoyaltyStatus").val(),
            AmtRoyaltyId: $("#hdnAMtRoyaltyId").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/RoyaltyMaster.aspx/UpdateAmtRoyalty",
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
                    BindRoyaltyList();
                    swal("Success!", "Amount Wise Reward  details updated successfully.", "success", { closeOnClickOutside: false });
                    //BindSafeCashList(1);
                    //Reset();
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

function BindRoyaltyList() {
    debugger;
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/Pages/RoyaltyMaster.aspx/RoyaltyList",
        data: "{}",
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
                var AmtRoyaltyList = xml.find("Table1");
                var RoyaltyList = xml.find("Table");
                if (RoyaltyList.length > 0) {
                    $("#hdnRoyaltyId").val($(RoyaltyList).find("AutoId").text());
                    $("#txtAmtPerRoyaltyPoint").val($(RoyaltyList).find("AmtPerRoyaltyPoint").text());
                    $("#txtMinOrderAmt").val($(RoyaltyList).find("MinOrderAmt").text());
                    $("#ddlStatus").val($(RoyaltyList).find("Status").text());
                }
                if (AmtRoyaltyList.length > 0) {
                    $("#hdnAMtRoyaltyId").val($(AmtRoyaltyList).find("AutoId").text());
                    $("#txtRoyaltyApointsAsPerAmt").val($(AmtRoyaltyList).find("Amount").text());
                    $("#txtRoyaltyPoints").val($(AmtRoyaltyList).find("RoyaltyPoint").text());
                    $("#ddlAmtRoyaltyStatus").val($(AmtRoyaltyList).find("Status").text());
                    $("#txtMinOrderAmtForRoyalty").val($(AmtRoyaltyList).find("MinOrderAmt").text());
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

