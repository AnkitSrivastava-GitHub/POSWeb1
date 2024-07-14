$(document).ready(function () {
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    EditInvoicePrintDetails();
});

function ChangeFooter() {
    if ($('#ddlFooter').val() == 1) {
        $('.Footer').show();
    }
    else {
        $('.Footer').hide();
    }
}
function EditInvoicePrintDetails() {
    $.ajax({
        type: "post",
        url: "/Pages/InvoicePrintDetails.aspx/EditInvoicePrintDetails",
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
                if (CompanyDetail.length > 0) {
                    $("#hdnCompanyId").val($(CompanyDetail).find('AutoId').text());
                    $("#txtStoreN").val($(CompanyDetail).find('StoreName').text());
                    $("#txtBilling").val($(CompanyDetail).find('BillingAddress').text());
                    $("#txtcontact").val($(CompanyDetail).find('ContactPersone').text());
                    $("#txtstate").val($(CompanyDetail).find('State').text());
                    $("#txtCity").val($(CompanyDetail).find('City').text());
                    $("#txtzipcode").val($(CompanyDetail).find('ZipCode').text());
                    $("#txtemail").val($(CompanyDetail).find('EmailId').text());
                    $("#txtcountry").val($(CompanyDetail).find('Country').text());
                    $("#txtsite").val($(CompanyDetail).find('WebSite').text());
                    $("#txtmob").val($(CompanyDetail).find('MobileNo').text());
                    $("#ddlShowPoints").val($(CompanyDetail).find('ShowHappyPoints').text());
                    $("#ddlFooter").val($(CompanyDetail).find('ShowFooter').text());
                    $("#ddlLogo").val($(CompanyDetail).find('ShowLogo').text()).change();
                    if ($(CompanyDetail).find('ShowFooter').text() == 1) {
                        $(".Footer").show();
                        $("#txtFooter").val($(CompanyDetail).find('Footer').text());
                    }
                    else {
                        $(".Footer").hide();
                    }
                    $("#btnSave").hide();
                    $("#btnUpdate").show();
                }
                else {
                    $("#btnSave").show();
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
function UpdateInvoicePrintDetails() {
    debugger
    var validate = 1;
    if ($("#txtStoreN").val().trim() == '') {
        toastr.error('Store Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtBilling").val().trim() == '') {
        toastr.error('Billing Address Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtCity").val().trim() == '') {
        toastr.error('City Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtcountry").val().trim() == '') {
        toastr.error('Country Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtstate").val().trim() == '') {
        toastr.error('State Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtzipcode").val().trim() == '') {
        toastr.error('Zip Code Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtzipcode').val().trim().length) < 5 || ($('#txtzipcode').val().trim().length) > 5)) {
        toastr.error('Please enter valid Zip Code.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() != '' && (($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid mobile no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    var logo = '';
    debugger;
    if (validate == 1) {
        var timeStamp = Date.parse(new Date());
        
        data = {
            AutoId: $("#hdnCompanyId").val() || 0,
            StoreName: $("#txtStoreN").val().trim(),
            BillingAddress: $("#txtBilling").val().trim(),
            ContactPerson: $("#txtcontact").val().trim(),
            Country: $("#txtcountry").val().trim(),
            MobileNo: $("#txtmob").val().trim(),
            Website: $("#txtsite").val().trim(),
            State: $("#txtstate").val().trim(),
            City: $("#txtCity").val().trim(),
            ZipCode: $("#txtzipcode").val().trim(),
            EmailId: $("#txtemail").val().trim(),
            Footer: $("#txtFooter").val().trim(),
            ShowHappyPoints: $("#ddlShowPoints").val(),
            ShowFooter: $("#ddlFooter").val(),
            ShowLogo: $("#ddlLogo").val(),
            CLogo: logo,
        }
        $.ajax({
            type: "POST",
            url: "/Pages/InvoicePrintDetails.aspx/UpdateInvoicePrintDetails",
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
                   
                    swal("Success!", "Invoice Details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        Reset();
                        EditInvoicePrintDetails();
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
    $("#ddlLogo").val(0).change();
    $("#ddlFooter").val(0).change();
    $("#ddlShowPoints").val(0).change();
    $("#txtFooter").val('');
    $("#txtStoreN").val('');
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
    $("#txtsite").val('');
    $("#txtcontact").val('');
    $("#btnSave").show();
    $("#btnUpdate").hide();
    $('#divimgPreview').hide();
    $("#imgPreview").attr('src', '');
    $("#imgPath").val('');
    $('#uploadimg').val('');
}