$(document).ready(function () {
    SetCurrency();
    BindStoreList();
    /*BindModuleList();*/
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
        //ShowAssignedModule(UserAutoId);
        //$('.ModuleAssign').show();
    }
    else {
        BindDropDowns();
    }
    var inputField = $('#txtmob');
    inputField.on('input', function () {
        var inputValue = inputField.val();
        var numericValue = inputValue.replace(/[^0-9]/g, '');
        inputField.val(numericValue);
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

function editUserDetail(id) {
    debugger;
    $('#loading').show();
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

                $('#loading').show();
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserDetail = xml.find("Table");
                var UserTypeList = xml.find("Table1");
                var CompanyList = xml.find("Table2");

                $("#ddluserType option").remove();
                $("#ddluserType").append('<option value="0">Select User Type</option>');
                $.each(UserTypeList, function () {
                    $("#ddluserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
                });
                $("#ddluserType").val($(UserDetail).find('UserType').text());
                $("#ddluserType").change();
                debugger;
                var StoreIds = [];
                $.each(CompanyList, function () {
                    StoreIds.push($(this).find('CompanyId').text());
                });

                $("input:checkbox[name=Store]").each(function () {
                    debugger;
                    if (StoreIds.includes($(this).val())) {
                        $(this).prop('checked', true);
                    }
                });

                $("#hdnUserId").val($(UserDetail).find('UserAutoId').text());
                $("#txtlogin").val($(UserDetail).find('LoginID').text());
                $("#txtpassword").val($(UserDetail).find('Password').text());
                $("#txtfirstname").val($(UserDetail).find('FirstName').text());
                $("#txtlastname").val($(UserDetail).find('LastName').text());
                $("#txtemail").val($(UserDetail).find('EmailID').text());
                $("#txtmob").val($(UserDetail).find('Contact').text());
                $("#ddlstatus").val($(UserDetail).find('Status').text());
                $("#txtsecuritypin").val($(UserDetail).find('SecurityPin').text());
                $("#txtsecuritypinDisc").val($(UserDetail).find('SecurityPinDisc').text());
                $("#txtWsecuritypin").val($(UserDetail).find('SecurityPinWith').text());
                $("#txtHourlyRate").val($(UserDetail).find('HourlyRate').text());
                if ($(UserDetail).find('IsAppAllowed').text() == "") {
                    $("#ddlAllowedApp").val('2').change();
                }
                else {
                    $("#ddlAllowedApp").val($(UserDetail).find('IsAppAllowed').text()).change();
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
function process(input) {
    let value = input.value;
    let numbers = value.replace(/[^0-9\.]/g, '');
    input.value = numbers;
}

function UpdateUser() {
    var validate = 1;
    debugger;
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Company Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
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
    if ($("#txtsecuritypinDisc").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Discount Security PIN Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtWsecuritypin").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Withdraw Security PIN Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtHourlyRate").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Hourly Rate Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtHourlyRate").val()) <= 0 && $("#ddluserType").val().trim() == '4') {
        toastr.error('Hourly Rate Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    var StoreIds = [], StoreIdsList = '';
    $("input:checkbox[name=Store]:checked").each(function () {
        debugger;
        StoreIds.push($(this).val());
    });
    StoreIdsList = StoreIds.join();
    if (StoreIdsList == null || StoreIdsList == '') {
        toastr.error('Please Select Atleast one Store.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    debugger;
    if (validate == 1) {
        data = {
            /* CompanyId: $("#ddlCompanyName").val(),*/
            FirstName: $("#txtfirstname").val().trim(),
            UserAutoId: $("#hdnUserId").val().trim(),
            LastName: $("#txtlastname").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            Password: $("#txtpassword").val().trim(),
            PhoneNo: $("#txtmob").val().trim(),
            UserType: $("#ddluserType").val(),
            security: $("#txtsecuritypin").val().trim(),
            securityDisc: $("#txtsecuritypinDisc").val().trim(),
            securityWithdraw: $("#txtWsecuritypin").val().trim(),
            HourlyRate: $("#txtHourlyRate").val().trim() || 0,
            Status: $("#ddlstatus").val(),
            AllowedApp: $("#ddlAllowedApp").val(),
            LoginId: $("#txtlogin").val().trim(),
            StoreIdsList: StoreIdsList
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ShowUserMaster.aspx/UpdateUser",
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
                    swal("Success!", "User updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        window.location.href = '/pages/ShowUserMaster.aspx'
                    });
                    Reset();
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
        })
    }
}
function Reset() {
    $("input:checkbox[name=AllStore]").prop('checked', false).change();
    $("#txtfirstname").val('');
    $("#ddlCompanyName").val('0');
    $("#hdnUserId").val('');
    $("#txtpassword").val('');
    $("#txtpassword").prop('type', 'password');
    $("#txtlastname").val('');
    $("#txtemail").val('');
    $("#txtmob").val('');
    $("#txtlogin").val('');
    $("#ddluserType").val(0).change();
    $("#ddlstatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
    $("#txtsecuritypin").val('');
    $("#txtHourlyRate").val('');
    $("#txtsecuritypinDisc").val('');
}
function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}

//function validate(e) {
//    var keyCode = e.keyCode || e.which;
//    var regex = /[A-Za-z]+$/;
//    var isValid = regex.test(String.fromCharCode(keyCode));
//    return isValid;
//}


function InsertUser() {
    debugger;
    var validate = 1;
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Company Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
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
    if ($("#txtsecuritypinDisc").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Discount Security PIN Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtWsecuritypin").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Withdraw Security PIN Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtHourlyRate").val().trim() == '' && $("#ddluserType").val().trim() == '4') {
        toastr.error('Hourly Rate Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtHourlyRate").val().trim()) <= 0 && $("#ddluserType").val().trim() == '4') {
        toastr.error('Hourly Rate Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    var StoreIds = [], StoreIdsList = '';
    $("input:checkbox[name=Store]:checked").each(function () {
        debugger;
        StoreIds.push($(this).val());
    });
    StoreIdsList = StoreIds.join();
    if (StoreIdsList == null || StoreIdsList == '') {
        toastr.error('Please Select Atleast one Store.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        debugger;
        data = {
            /*CompanyId: $("#ddlCompanyName").val(),*/
            firstName: $("#txtfirstname").val().trim(),
            UserAutoId: $("#hdnUserId").val().trim(),
            LastName: $("#txtlastname").val().trim(),
            LoginId: $("#txtlogin").val().trim(),
            Password: $("#txtpassword").val().trim(),
            UserType: $("#ddluserType").val(),
            Emailid: $("#txtemail").val().trim(),
            PhoneNo: $("#txtmob").val().trim(),
            Status: $("#ddlstatus").val(),
            AllowedApp: $("#ddlAllowedApp").val(),
            security: $("#txtsecuritypin").val(),
            securityDisc: $("#txtsecuritypinDisc").val().trim(),
            securityWithdraw: $("#txtWsecuritypin").val().trim(),
            HourlyRate: $("#txtHourlyRate").val().trim() || 0,
            StoreIdsList: StoreIdsList
        }
        $.ajax({
            type: "POST",
            url: "/Pages/UserMaster.aspx/InsertUser",
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
                    swal("Success!", "User added successfully.", "success", { closeOnClickOutside: false }).then(function () {
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
                var CompanyList = xml.find("Table1");

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



function BindStoreList() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/UserMaster.aspx/BindStoreList",
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
                var html = "";
                html += '<div class="col-md-3" style="padding-left:0px" id="divAllStore">';
                html += '<input class="form-check-input"  type="checkbox" onchange="selectAll()" name="AllStore" value="0" id="AllflexCheckDefault">';
                html += '&nbsp;&nbsp;<label class="form-check-label" for="flexCheckDefault">All Stores</label>';
                html += '</div>';
                $.each(StoreList, function () {
                    debugger
                    html += '<div class="col-md-3" style="padding-left:0px">';
                    html += '<input class="form-check-input" onchange="CashierWiseStoreSelection(this)"  type="checkbox" name="Store" value="' + $(this).find('AutoId').text() + '" >';
                    html += '&nbsp;&nbsp;<label class="form-check-label" for="flexCheckDefault">' + $(this).find('CompanyName').text() + '</label>';
                    html += '</div>';
                });
                $('#DivStoreList').html(html);

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
        $('#securityboxD').show();
        $('#securityboxW').show();
        $('#HourlyRate').show();
        $("input:checkbox[name=AllStore]").prop('checked', false).change();
        $("#divAllStore").hide();
    }
    else {
        $("input:checkbox[name=AllStore]").prop('checked', false).change();
        $('#HourlyRate').hide();
        $('#securitybox').hide();
        $('#securityboxD').hide();
        $('#securityboxW').hide();
        $("#divAllStore").show();
    }

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

function CashierWiseStoreSelection(evt) {
    debugger;
    if ($("#ddluserType option:selected").text() == 'Cashier') {
        $("input:checkbox[name=Store]").each(function () {
            debugger;
            if ($(this).val() != $(evt).val()) {
                $(this).prop('checked', false);
            }
        });
    }
}

function BindModuleList() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/UserMaster.aspx/BindModuleList",
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
            debugger
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
                var ModuleList = xml.find("Table");
                var html = "";
                $.each(ModuleList, function () {
                    debugger
                    html += '<tr>'
                    html += '<td><input disabled class="form-check-input" id="' + $(this).find('AutoId').text() + '"  type="checkbox" name="Module" value="' + $(this).find('AutoId').text() + '" ></td>';
                    html += '<td><a style="cursor:pointer"><span onclick="BindSubModule(' + $(this).find('AutoId').text() + ');">' + $(this).find('ModuleId').text() + '</span></a></td>';
                    html += '<td><label class="form-check-label" for="ModuleflexCheckDefault">' + $(this).find('ModuleName').text() + '</label></td>';
                    html += '</tr>';
                });
                $('#DivModuleList').html(html);

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
function BindSubModule(AutoId) {
    debugger;
    $('#DivComponentList').hide();
    data = {
        UserAutoId: $("#hdnUserId").val().trim(),
        ModuleId: AutoId || 0
    }
    $.ajax({
        type: "POST",
        url: "/Pages/UserMaster.aspx/BindSubModuleList",
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
            debugger
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
                var SubModuleList = xml.find("Table");
                var AssSubModuleList = xml.find("Table1");
                var html = "";
                $.each(SubModuleList, function () {
                    debugger
                    var id = $(this).find('AutoId').text();
                    html += '<tr>'
                    html += '<td><input disabled class="form-check-input ' + id + '"  onchange=""  type="checkbox" name="SubModule" value="' + $(this).find('AutoId').text() + '" ></td>';
                    html += '<td><a style="cursor:pointer"><span onclick="ComponentList(' + $(this).find('AutoId').text() + ',' + AutoId + ')">' + $(this).find('PageId').text() + '</span></a></td>';
                    html += '<td><label class="form-check-label" for="SubModuleflexCheckDefault">' + $(this).find('PageName').text() + '</label></td>';
                    html += '</tr>';
                });
                $('#DivSubModuleList').html(html);
                $.each(AssSubModuleList, function () {
                    var id = $(this).find('AutoId').text();
                    $('.' + id + '').prop('checked', true).change();
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
    });
}

function ComponentList(SubAutoId, ModuleAutoId) {
    debugger;
    $('#DivComponentList').show();
    data = {
        UserAutoId: $("#hdnUserId").val().trim(),
        ModuleId: SubAutoId || 0
    }
    $.ajax({
        type: "POST",
        url: "/Pages/UserMaster.aspx/BindComponentList",
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
            debugger
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
                var SubModuleList = xml.find("Table");
                var html = "";
                $.each(SubModuleList, function () {
                    debugger
                    if ($(this).find('Checked').text() == '1') {
                        html += '<tr>'
                        html += '<td><input style="cursor:pointer" checked="true" class="form-check-input" onchange="SelectComponent(' + SubAutoId + ',' + ModuleAutoId + ')"  type="checkbox" name="Component" value="' + $(this).find('AutoId').text() + '" ></td>';
                        html += '<td><a style="cursor:pointer"><span >' + $(this).find('ComponentId').text() + '</span></a></td>';
                        html += '<td><label class="form-check-label" for="SubModuleflexCheckDefault">' + $(this).find('ComponentName').text() + '</label></td>';
                        html += '</tr>';
                    }
                    else {
                        html += '<tr>'
                        html += '<td><input style="cursor:pointer" class="form-check-input" onchange="SelectComponent(' + SubAutoId + ',' + ModuleAutoId + ')"  type="checkbox" name="Component" value="' + $(this).find('AutoId').text() + '" ></td>';
                        html += '<td><a style="cursor:pointer"><span >' + $(this).find('ComponentId').text() + '</span></a></td>';
                        html += '<td><label class="form-check-label" for="SubModuleflexCheckDefault">' + $(this).find('ComponentName').text() + '</label></td>';
                        html += '</tr>';
                    }

                });
                $('#DivComponentList').html(html);

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

function SelectComponent(SubAutoId, ModuleAutoId) {
    debugger;


    if ($("input:checkbox[name=Component]").is(':checked')) {
        $('.' + SubAutoId + '').prop('checked', true).change();
        $('#' + ModuleAutoId + '').prop('checked', true).change();
    }
    else {
        $('.' + SubAutoId + '').prop('checked', false).change();
        $('#' + ModuleAutoId + '').prop('checked', false).change();
    }
}

function AssignModule() {
    debugger
    var ComponentIds = [], ComponentIdsList = '', ComponentIds1 = [], ComponentIdsList1 = '';
    if ($("input:checkbox[name=Component]").is(':checked')) {
        $('#DivComponentList > tr').each(function (index, tr) {
            ComponentIds1.push($(this).find("input").val());
            if ($(this).find("input:checkbox[name=Component]").is(':checked')) {
                ComponentIds.push($(this).find("input").val());
            }
        });
    }
    ComponentIdsList = ComponentIds.join();
    ComponentIdsList1 = ComponentIds1.join();
    if (ComponentIds.length > 0) {
        data = {
            UserAutoId: $("#hdnUserId").val().trim(),
            ComponentIdsList: ComponentIdsList,
            ComponentIdsList1: ComponentIdsList1
        }
        $.ajax({
            type: "POST",
            url: "/Pages/UserMaster.aspx/AssignModule",
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
                    swal("Success!", "Component Assigne successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        //Reset();
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
    else {
        toastr.error('Please Select Atleast one Component.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    }
}

function ShowAssignedModule(UserAutoId) {
    debugger;
    $('#loading').show();
    data = {
        UserAutoId: UserAutoId,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowUserMaster.aspx/ShowAssignedModule",
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

                $('#loading').show();
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ModuleDetail = xml.find("Table");
                $.each(ModuleDetail, function () {
                    var Id = $(this).find("AutoId").text();
                    $('#' + Id + '').prop('checked', true).change();
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
    });

}