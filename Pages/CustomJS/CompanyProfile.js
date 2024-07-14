$(document).ready(function () { 
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    StoreAutoId = getQueryString('PageId');
    if (StoreAutoId != null) {
        editCompanyProfile(StoreAutoId);
    }
    bindCurrency();
});

function bindCurrency() {
    $.ajax({
        type: "POST",
        url: "/Pages/CompanyProfile.aspx/bindCurrency",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Currency Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CurrencyList = xml.find("Table");
                $("#ddlCurrency option").remove();
                $("#ddlCurrency").append('<option value="0">Select Currency</option>');
                $.each(CurrencyList, function () {
                    $("#ddlCurrency").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CurrencyName").text()));
                });
                $("#ddlCurrency").select2().next().css('width', '250px');
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
function InsertStore() {
    debugger;
    var validate = 1;
    $('#loading').show();
    if ($("#txtCompanyName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Store Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtBilling").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Billing Address Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtCity").val().trim() == '') {
        $('#loading').hide();
        toastr.error('City Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtstate").val().trim() == '') {
        $('#loading').hide();
        toastr.error('State Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtcountry").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Country Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtzipcode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Zip Code Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtzipcode').val().trim().length) < 5 || ($('#txtzipcode').val().trim().length) > 5)) {
        $('#loading').hide();
        toastr.error('Please enter valid Zip Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        $('#loading').hide();
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() != '' && (($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        $('#loading').hide();
        toastr.error('Please enter valid Phone no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if ($('#txtphone').val() != '' && (($('#txtphone').val().trim().length) < 10 || ($('#txtphone').val().trim().length) > 10)) {
        $('#loading').hide();
        toastr.error('Please enter valid Phone no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlCurrency").val() == '' || $("#ddlCurrency").val() == 0) {
        $('#loading').hide();
        toastr.error('Currency Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    var logo = '';
    if (validate == 1) {
        debugger;
        var timeStamp = Date.parse(new Date());
        if ($("#uploadimg").val() != "") {
            logo = timeStamp + '_' + $("#uploadimg").val().split('\\').pop()
        }
        else {
            logo = "logo.ico";
        }
        data = {
            companyName: $("#txtCompanyName").val().trim(),
            BillingAddress: $("#txtBilling").val().trim(),
            ContactPerson: $("#txtcontact").val().trim(),
            Country: $("#txtcountry").val().trim(),
            MobileNo: $("#txtmob").val().trim(),
            Website: $("#txtsite").val().trim(),
            State: $("#txtstate").val().trim(),
            City: $("#txtCity").val().trim(),
            ZipCode: $("#txtzipcode").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            PhoneNo: $("#txtphone").val().trim(),
            FaxNo: $("#txtfaxno").val().trim(),
            VatNo: $("#txtvatno").val().trim(),
            Status: $("#ddlStoreStatus").val(),
            CurrencyId: $("#ddlCurrency").val(),
            AllowLottoSale: $("#ddlAllowLottoSale").val(),
            CLogo: logo,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CompanyProfile.aspx/InsertStore",
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
                    if ($("#uploadimg").val() != "") {
                        var fileUpload = $("#uploadimg").get(0);
                        var files = fileUpload.files;
                        var test = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            test.append(files[i].name, files[i]);
                        }
                        $.ajax({
                            url: "imageUploadHandler.ashx?timestamp=" + timeStamp + "&From=CompanyProfile",
                            type: "POST",
                            contentType: false,
                            processData: false,
                            data: test,
                            success: function (result) {
                                debugger;
                                console.log(result)
                            },
                            error: function (err) {

                            }
                        });
                    }
                    $('#loading').hide();
                    swal("Success!", "Store added Successfully.", "success", { closeOnClickOutside: false });
                    Reset();
                }
                else if (response.d == 'Session') {
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
        });
    }
}
function editCompanyProfile(id) {
    data = {
        StoreAutoId: id,
    }
    $.ajax({
        type: "post",
        url: "/Pages/StoreList.aspx/editCompanyProfile",
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
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var CompanyDetail = xml.find("Table");
                $("#hdnCompanyId").val($(CompanyDetail).find('AutoId').text());
                $("#txtCompanyName").val($(CompanyDetail).find('CompanyName').text());
                $("#txtid").val($(CompanyDetail).find('CompanyId').text());
                $("#txtBilling").val($(CompanyDetail).find('BillingAddress').text());
                $("#txtcontact").val($(CompanyDetail).find('ContactName').text());
                $("#txtstate").val($(CompanyDetail).find('State').text());
                $("#txtCity").val($(CompanyDetail).find('City').text());
                $("#txtzipcode").val($(CompanyDetail).find('ZipCode').text());
                $("#txtemail").val($(CompanyDetail).find('EmailId').text());
                $("#txtcountry").val($(CompanyDetail).find('Country').text());
                $("#txtsite").val($(CompanyDetail).find('Website').text());
                $("#txtphone").val($(CompanyDetail).find('PhoneNo').text());
                $("#txtmob").val($(CompanyDetail).find('TeliPhoneNo').text());
                $("#txtfaxno").val($(CompanyDetail).find('FaxNo').text());
                $("#ddlStoreStatus").val($(CompanyDetail).find('Status').text());
                $("#ddlAllowLottoSale").val($(CompanyDetail).find('AllowLotterySale').text());
                if ($(CompanyDetail).find('Currency').text() != '') {
                    $("#ddlCurrency").val($(CompanyDetail).find('Currency').text()).change();
                }
                else {
                    $("#ddlCurrency").val('0').change();
                }
               
                debugger;
                $("#txtvatno").val($(CompanyDetail).find('VatNo').text());
                $("#imgPreview").attr('src', '/pages/images/' + $(CompanyDetail).find('CLogo').text());
                $("#hdnimage").val($(CompanyDetail).find('CLogo').text());

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
function NumericInput(event) {
    debugger;
    if (!(event.keyCode == 85
        || event.keyCode == 46
       /* || (event.keyCode >= 35 && event.keyCode <= 40)*/
        || (event.keyCode >= 48 && event.keyCode <= 57)
    )) {
        event.preventDefault();
    }
}
function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}
function updateCompanyProfile() {
    debugger
    var validate = 1;
    $('#loading').show();
    if ($("#txtCompanyName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Store Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtBilling").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Billing Address Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtCity").val().trim() == '') {
        $('#loading').hide();
        toastr.error('City Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtcountry").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Country Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtstate").val().trim() == '') {
        $('#loading').hide();
        toastr.error('State Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtzipcode").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Zip Code Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtzipcode').val().trim().length) < 5 || ($('#txtzipcode').val().trim().length) > 5)) {
        $('#loading').hide();
        toastr.error('Please enter valid Zip Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        $('#loading').hide();
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() != '' && (($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        $('#loading').hide();
        toastr.error('Please enter valid Phone no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
   
    if ($('#txtphone').val() != '' && (($('#txtphone').val().trim().length) < 10 || ($('#txtphone').val().trim().length) > 10)) {
        $('#loading').hide();
        toastr.error('Please enter valid Phone no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlCurrency").val() == '' || $("#ddlCurrency").val() == 0) {
        $('#loading').hide();
        toastr.error('Currency Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    var logo = '';
    debugger;
    if (validate == 1) {
        var timeStamp = Date.parse(new Date());
        if ($("#uploadimg").val() != "") {
            logo = timeStamp + '_' + $("#uploadimg").val().split('\\').pop()
        }
        else {
            if ($('#imgPreview').attr('src') == '') {
                logo = "logo.ico";
            }
            else {
               logo = $("#hdnimage").val();
            }
        }
        data = {
            AutoId: $("#hdnCompanyId").val(),
            companyName: $("#txtCompanyName").val().trim(),
            BillingAddress: $("#txtBilling").val().trim(),
            ContactPerson: $("#txtcontact").val().trim(),
            Country: $("#txtcountry").val().trim(),
            MobileNo: $("#txtmob").val().trim(),
            Website: $("#txtsite").val().trim(),
            State: $("#txtstate").val().trim(),
            City: $("#txtCity").val().trim(),
            ZipCode: $("#txtzipcode").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            PhoneNo: $("#txtphone").val().trim(),
            FaxNo: $("#txtfaxno").val().trim(),
            VatNo: $("#txtvatno").val().trim(),
            Status: $("#ddlStoreStatus").val(),
            CurrencyId: $("#ddlCurrency").val(),
            CurrencyId: $("#ddlCurrency").val(),
            AllowLottoSale: $("#ddlAllowLottoSale").val(),
            CLogo: logo,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CompanyProfile.aspx/updateCompanyProfile",
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
                    debugger;
                    if ($("#uploadimg").val() != "") {
                        var fileUpload = $("#uploadimg").get(0);
                        var files = fileUpload.files;
                        var test = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            test.append(files[i].name, files[i]);
                        }
                        $.ajax({
                            url: "imageUploadHandler.ashx?timestamp=" + timeStamp + "&From=CompanyProfile",
                            type: "POST",
                            contentType: false,
                            processData: false,
                            data: test,
                            success: function (result) {
                                debugger;
                                console.log(result)
                            },
                            error: function (err) {

                            }
                        });
                    }
                    swal("Success!", "Store Updated Successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                        window.location.href = '/Pages/CompanyProfile.aspx';
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
        })
    }
}

function Reset() {
    $("#txtCompanyName").val('');
    $("#hdnCompanyId").val('');
    $("#txtBilling").val('');
    $("#txtid").val('');
    $("#txtCity").val('');
    $("#txtcountry").val('');
    $("#txtmob").val('');
    $("#txtstate").val('');
    $("#txtzipcode").val('');
    $("#txtemail").val('');
    $("#txtphone").val('');
    $("#txtfaxno").val('');
    $("#txtvatno").val('');
    $("#txtsite").val('');
    $("#txtcontact").val('');
    $("#btnSave").show();
    $("#btnUpdate").hide();
    $('#divimgPreview').hide();
    $("#imgPreview").attr('src', '');
    $("#imgPath").val('');
    $('#uploadimg').val('');
}
function readURL(input) {
    debugger;
    var flag = false;
    if ($(input).val().trim() != '') {
        $('#divimgPreview').show();
        $('#imgPreview').show();
        var ext = "." + $(input).val().substr($(input).val().lastIndexOf('.') + 1);;

        //if ($(input)[0].files[0].size > 10485760) {
        //    swal("Error!", "Image Size must be less than 10MB.", "error");  
        //    flag = 'false'
        //    $(input).val('');
        //    return false;
        //}

        var str = '.png,.jpg,.jpeg,.gif,.bmp';
        var strarray = str.split(',');
        for (var i = 0; i < strarray.length; i++) {
            if (strarray[i] == ext.toLowerCase()) {
                flag = 'True'
            }
        }
        if (flag == 'True') {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#imgPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        else {
            $(input).val('');
            $('#imgPreview').removeAttr('src');
            $('#imgPreview').hide();
            $('#divimgPreview').hide();
            swal('Error!', 'Please select valid file type.', 'error', { closeOnClickOutside: false });
        }
    }
    else {
        $(input).val('');
        $('#imgPreview').attr('src','../pages/images/logo.ico');
        //$('#imglogo').hide();
    }
    
}
//function Reset(){
//    location.replace("CompanyProfile.aspx");
//}