$(document).ready(function () {
    //BindDropDowns();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    UserAutoId = getQueryString('PageId');
    if (UserAutoId != null) {
        editUserDetail(UserAutoId);
    };
    var inputField = $('#txtmob');
    inputField.on('input', function () {
        var inputValue = inputField.val();
        var numericValue = inputValue.replace(/[^0-9]/g, '');
        inputField.val(numericValue);
    });
});
function editUserDetail(id) {
    debugger;
    data = {
        UserAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowUserMaster.aspx/editUserDetail",
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
                var UserTypeList = xml.find("Table1");
                $("#ddluserType option").remove();
                $("#ddluserType").append('<option value="0">Select User Type</option>');
                $.each(UserTypeList, function () {
                    $("#ddluserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
                });
                $("#hdnUserId").val($(UserDetail).find('UserAutoId').text());
                $("#ddluserType").val($(UserDetail).find('UserType').text());
                $("#ddluserType").change();
                $("#txtlogin").val($(UserDetail).find('LoginID').text());
                $("#txtpassword").val($(UserDetail).find('Password').text());
                $("#txtfirstname").val($(UserDetail).find('FirstName').text());
                $("#txtlastname").val($(UserDetail).find('LastName').text());
                $("#txtemail").val($(UserDetail).find('EmailID').text());
                $("#txtmob").val($(UserDetail).find('Contact').text());
                $("#ddlstatus").val($(UserDetail).find('Status').text());
                $("#txtsecuritypin").val($(UserDetail).find('SecurityPin').text());
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

function OpenSecurityPin() {
    debugger;
    if ($('#ddluserType option:selected').text() == 'Cashier') {
        $('#securitybox').show();
    }
    else {
        $('#securitybox').hide();
    }
}

function UpdateUser() {
    var validate = 1;
    debugger;
    if ($("#txtfirstname").val().trim() == '') {
        toastr.error('First Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtlogin").val().trim() == '') {
        toastr.error('Login ID Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtpassword").val().trim() == '') {
        toastr.error('Password Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() != '' && (($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid phone no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddluserType").val().trim() == '0') {
        toastr.error('User Type Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtsecuritypin").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Security PIN Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    debugger;
    if (validate == 1) {
        data = {
            FirstName: $("#txtfirstname").val().trim(),
            UserAutoId: $("#hdnUserId").val().trim(),
            LastName: $("#txtlastname").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            Password: $("#txtpassword").val().trim(),
            PhoneNo: $("#txtmob").val().trim(),
            UserType: $("#ddluserType").val(),
            security: $("#txtsecuritypin").val().trim(),
            Status: $("#ddlstatus").val(),
            LoginId: $("#txtlogin").val().trim(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/MyAccount.aspx/MyAccount",
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
                debugger;
                if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else if (response.d == 'false') {
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                else {
                    debugger;
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var UserDetail = xml.find("Table");
                    var UserTypeList = xml.find("Table1");
                    $("#ddluserType option").remove();
                    $("#ddluserType").append('<option value="0">Select User Type</option>');
                    $.each(UserTypeList, function () {
                        $("#ddluserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
                    });
                    $("#hdnUserId").val($(UserDetail).find('UserAutoId').text());
                    $("#txtlogin").val($(UserDetail).find('LoginID').text());
                    $("#txtpassword").val($(UserDetail).find('Password').text());
                    $("#txtfirstname").val($(UserDetail).find('FirstName').text());
                    $("#txtlastname").val($(UserDetail).find('LastName').text());
                    $("#txtemail").val($(UserDetail).find('EmailID').text());
                    $("#txtmob").val($(UserDetail).find('Contact').text());
                    $("#ddluserType").val($(UserDetail).find('UserType').text()).change();
                    $("#ddlstatus").val($(UserDetail).find('Status').text());
                    $("#txtsecuritypin").val($(UserDetail).find('SecurityPin').text());
                    swal("Success!", "Details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        $("#btnUpdate").show();
                    });
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

function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}

function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/UserMaster.aspx/BindDropDowns",
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
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table");
                $("#ddluserType option").remove();
                $("#ddluserType").append('<option value="0">Select User Type</option>');

                $.each(UserList, function () {
                    $("#ddluserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
                });
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

function ViewPassword() {
    debugger;
    if ($('#txtpassword').prop('type') == 'password') {
        $('#txtpassword').prop("type", "text");
    }
    else {
        $('#txtpassword').prop("type", "password");
    }
}