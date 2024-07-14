$(document).ready(function () {
    BindDropDowns();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    AutoId = getQueryString('PageId');
    if (AutoId != null) {
        editVendorDetail(AutoId);
    };   
    $('#btnSave').click(function () {
        InsertVendor();
    });
});

function process(input) {
    let value = input.value;
    let numbers = value.replace(/[^0-9]/g, "");
    input.value = numbers;
}

function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}
function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/VendorMaster.aspx/BindDropDowns",
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
                var StateList = xml.find("Table");
                var CompanyList = xml.find("Table1");
                $("#ddlstate option").remove();
                $("#ddlstate").append('<option value="0">Select State</option>');
                $.each(StateList, function () {
                    $("#ddlstate").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("State").text()));
                });
                $("#ddlstate").select2();
                debugger;
                $("#ddlCompanyName option").remove();
                $("#ddlCompanyName").append('<option value="0">Select Store</option>');
                $.each(CompanyList, function () {
                    $("#ddlCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyName").text()));
                });
                $("#ddlCompanyName").select2();

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
function InsertVendor() {
    var validate = 1;
    if ($("#txtVendorCode").val() == '') {
        toastr.error('Vendor Code Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Store Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtname").val().trim() == '') {
        toastr.error('Vendor Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val().trim() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

     //var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
     //   if (!filter.test($('#txtemail').val())) {
     //       alert('Please provide a valid email address');
     //       email.focus;
     //       return false;
     //   }
   

    if ($('#txtmob').val().trim() == '') {
        toastr.error('Contact No. Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid Contact no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (($('#txtzip').val().trim().length) != '' && ($("#txtzip").val().trim().length) < 5) {
        toastr.error('Enter valid Zip Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    
    debugger
    if (validate == 1) {
        data = {
            VendorCode: $("#txtVendorCode").val(),
            CompanyId: $("#ddlCompanyName").val(),
            Name: $("#txtname").val().trim(),
            MobileNo: $("#txtmob").val().trim(),
            Address: $("#txtaddress").val().trim(),
            State: $("#ddlstate").val(),
            City: $("#txtcity").val().trim(),
            ZipCode: $("#txtzip").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            Status: $("#ddlstatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/VendorMaster.aspx/InsertVendor",
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
                    swal("Success!", "Vendor details added successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                    });
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
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

function editVendorDetail(id) {
    debugger;
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowVendorMaster.aspx/editVendorDetail",
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
                var UserDetail = xml.find("Table");
                if (UserDetail.length > 0) {
                    $("#hdnVendorId").val(id);
                    $("#txtname").val($(UserDetail).find('VendorName').text());
                    $("#ddlCompanyName").val($(UserDetail).find('CompanyId').text()).select2();
                    $("#txtVendorCode").val($(UserDetail).find('VendorCode').text());
                    $("#txtmob").val($(UserDetail).find('MobileNo').text());
                    $("#txtaddress").val($(UserDetail).find('Address1').text());
                    $("#ddlstate").val($(UserDetail).find('State').text()).select2();
                    $("#txtcity").val($(UserDetail).find('City').text());
                    $("#txtzip").val($(UserDetail).find('Zipcode').text());
                    $("#txtemail").val($(UserDetail).find('Emailid').text());
                    $("#ddlstatus").val($(UserDetail).find('Status').text());
                    $("#btnSave").hide();
                    $("#btnUpdate").show();
                }
                else {
                    swal('Warning', 'No Vendor Details Found.', 'warning', { closeOnClickOutside: false }).then(function () {
                        window.location.href = '/Pages/VendorMaster.aspx';
                    });
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
function UpdateVendor() {
    var validate = 1;
    debugger;
    if ($("#txtVendorCode").val().trim() == '') {
        toastr.error('Vendor Code Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Store Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtname").val().trim() == '') {
        toastr.error('Vendor Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() == '') {
        toastr.error('Contact No. Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid Contact no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (($('#txtzip').val().trim().length) != '' && ($("#txtzip").val().trim().length) < 5) {
        toastr.error('Enter valid Zip Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    debugger;
    if (validate == 1) {
        data = {
            VendorCode: $("#txtVendorCode").val(),
            CompanyId: $("#ddlCompanyName").val(),
            VendorName: $("#txtname").val().trim(),
            AutoId: $("#hdnVendorId").val().trim(),
            MobileNo: $("#txtmob").val().trim(),
            Address: $("#txtaddress").val().trim(),
            State: $("#ddlstate").val(),
            City: $("#txtcity").val().trim(),
            zipcode: $("#txtzip").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            Status: $("#ddlstatus").val(),

        }
        $.ajax({
            type: "POST",
            url: "/Pages/ShowVendorMaster.aspx/UpdateVendor",
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
                    swal("Success!", "Vendor updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        //Reset();
                        window.location.reload();
                    });
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else if (response.d == 'Vendor is not exists!') {
                    swal("Error!", response.d, "error", { closeOnClickOutside: false }).then(function () {
                        window.location.href = '/Pages/VendorMaster.aspx';
                    });                    
                }
                else {
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                    //    window.location.href = '/VendorMaster.aspx'
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
    $("#txtVendorCode").val('');
    $("#ddlCompanyName").val('0').select2();
    $("#txtname").val('');
    $("#hdnVendorId").val('');
    $("#txtmob").val('');
    $("#txtaddress").val('');
    $("#ddlstate").val('0').select2();
    $("#txtcity").val('');
    $("#txtzip").val('');
    $("#txtemail").val('');
    $("#ddlstatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}
