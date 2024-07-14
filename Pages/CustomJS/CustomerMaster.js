$(document).ready(function () {
    BindDropDowns();
    BindCustomerList(1);
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    debugger;
    AutoId = getQueryString('PageId');
    if (AutoId != null) {
        editCustomerDetail(AutoId);
    };

    $(function () {
        $("#txtdob").datepicker({
            maxDate: new Date()
        });
    });
});

function NumericInput(event) {
    if (!(event.keyCode == 8                                
        || event.keyCode == 46                             
        || (event.keyCode >= 35 && event.keyCode <= 40)   
        || (event.keyCode >= 48 && event.keyCode <= 57)    
    )) {
        event.preventDefault();     
    }
}

function validate(e) {
    var keyCode = e.keyCode || e.which;
    var regex = /[A-Za-z]+$/;
    var isValid = regex.test(String.fromCharCode(keyCode));
    return isValid;
}
function Pagevalue(e) {
    BindCustomerList(parseInt($(e).attr("page")));
};
function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}
function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/CustomerMaster.aspx/BindDropDowns",
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
                swal('Error!', 'Some error occured.', 'error');
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");
                $("#ddlstate option").remove();
                $("#ddlstate").append('<option value="0">Select State</option>');
                $.each(StateList, function () {
                    $("#ddlstate").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("state").text()));
                    // $("#ddlSemptype").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("EmpType").text()));

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
function InsertCustomer() {
    var validate = 1;
    if ($("#txtfname").val().trim() == '') {
        toastr.error('Customer Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid EmailId.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() == '') {
        toastr.error('Mobile No. Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid mobile no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            FirstName: $("#txtfname").val(),
            LastName: $("#txtlname").val(),
            MobileNo: $("#txtmob").val(),
            Address: $("#txtaddress").val(),
            State: $("#ddlstate").val(),
            City: $("#txtcity").val(),
            ZipCode: $("#txtzip").val(),
            EmailId: $("#txtemail").val(),
            DOB: $("#txtdob").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CustomerMaster.aspx/InsertCustomer",
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
                    swal("Success!", "Customer Added Successfully.", "success");
                    // BindVendorList(1);
                    Reset();
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Error!", response.d, "error");
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            }
        });
    }
}
function BindCustomerList(pageIndex) {
    debugger;
    $('#loading').show();
    data = {
        Name: $("#txtSname").val(),
        EmailId: $("#txtSEmailid").val(),
        PhoneNo: $("#txtSMob").val(),
        // DOB: $("#txtSstatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowCustomerMaster.aspx/BindCustomerList",
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
                var CustomerList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (CustomerList.length > 0) {
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
                    //$("#ddlPageSize").show();
                    $("#EmptyTable").hide();
                    $("#tblCustomerList tbody tr").remove();
                    var html = '';
                    html += '<tbody>';
                    //var row = $("#tblCustomerList thead tr:first-child").clone(true);
                    $.each(CustomerList, function () {
                        debugger;
                        html += '<tr>';
                        html += '<td class="Action" style="width: 50px;"><a id="btnDeletecustomer" onclick="DeleteCustomer(' + $(this).find("AutoId").text() + ')" title="Delete Customer" style="cursor: pointer;"><i class="fa fa-trash" style="color: red;"></i></a>&nbsp;&nbsp;&nbsp;<a href="/Pages/CustomerMaster.aspx?PageId=' + $(this).find("AutoId").text() + '"><img src="/Style/img/edit.png" title="Edit" class="imageButton" id="edit"/></a></td>';
                        html += '<td class="CustomerName" style="white-space: nowrap">' + $(this).find("FirstName").text()+'</td>';
                        html += '<td class="EmailId" style="width:100px;text-align:center;">' + $(this).find("EmailId").text()+'</td>';
                        html += '<td class="Mob" style="width:100px;text-align:center;">' + $(this).find("MobileNo").text() + '</td>';
                        html += '<td class="address" style="white-space: nowrap;text-align:center;">' + $(this).find("Address").text() + '</td>';
                        html += '</tr>';
                    });
                    html += '</tbody>';
                    $("#tblCustomerList").append(html);
                    //$("#tblCustomerList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblCustomerList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                //var pager = xml.find("Table");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        }

    });
}
function editCustomerDetail(id) {
    debugger;
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowCustomerMaster.aspx/editCustomerDetail",
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
                $("#hdnCustomerId").val(id);
                $("#txtfname").val($(UserDetail).find('FirstName').text());
                $("#txtlname").val($(UserDetail).find('LastName').text());
                $("#txtmob").val($(UserDetail).find('MobileNo').text());
                $("#txtaddress").val($(UserDetail).find('Address').text());
                $("#ddlstate").val($(UserDetail).find('state').text());
                $("#txtcity").val($(UserDetail).find('City').text());
                $("#txtzip").val($(UserDetail).find('zipCode').text());
                $("#txtemail").val($(UserDetail).find('EmailId').text());
                $("#txtdob").val($(UserDetail).find('DOB').text());
                $("#btnSave").hide();
                $("#btnUpdate").show();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        }
    });

}
function UpdateCustomer() {
    var validate = 1;
    debugger;
    if ($("#txtfname").val().trim() == '') {
        toastr.error('Customer Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtemail').val() != '' && (isEmail($("#txtemail").val()) == false)) {
        toastr.error('Enter valid EmailId.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#txtmob').val() == '') {
        toastr.error('Mobile No. Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ((($('#txtmob').val().trim().length) < 10 || ($('#txtmob').val().trim().length) > 10)) {
        toastr.error('Please enter valid mobile no.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    debugger;
    if (validate == 1) {
        data = {
            AutoId: $("#hdnCustomerId").val(),
            FirstName: $("#txtfname").val(),
            LastName: $("#txtlname").val(),
            MobileNo: $("#txtmob").val(),
            Address: $("#txtaddress").val(),
            State: $("#ddlstate").val(),
            City: $("#txtcity").val(),
            ZipCode: $("#txtzip").val(),
            EmailId: $("#txtemail").val(),
            DOB: $("#txtdob").val(),

        }
        $.ajax({
            type: "POST",
            url: "/Pages/ShowCustomerMaster.aspx/UpdateCustomer",
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
                    swal("Success!", "Customer updated Successfully.", "success");
                    BindCustomerList(1);
                    Reset();
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Error!", response.d, "error");
                }
                $('#loading').hide();

            },
            error: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            }
        })
    }
}
function DeleteCustomer(id) {
    debugger;
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Customer.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: false,
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
                AutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ShowCustomerMaster.aspx/DeleteCustomer",
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
                        swal("Success!", "Customer Deleted Successfully.", "success");
                        BindCustomerList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error");
                    }
                    $('#loading').hide();
                },
                error: function (err) {
                    swal("Error!", err.d, "error");
                    $('#loading').hide();
                },
                failure: function (err) {
                    swal("Error!", err.d, "error");
                    $('#loading').hide();
                }
            });
        }
        else {
            swal("", "Cancelled.", "error");
            $('#loading').show();
        }
    });
}
function Reset() {
    //$("#txtfname").val('');
    //$("#txtlname").val('');
    //$("#hdnCustomerId").val('');
    //$("#txtmob").val('');
    //$("#txtaddress").val('');
    //$("#ddlstate").val(0);
    //$("#txtcity").val('');
    //$("#txtzip").val('');
    //$("#txtemail").val('');
    //$("#txtdob").val('');
    //$("#btnSave").show();
    //$("#btnUpdate").hide();
    location.replace("CustomerMaster.aspx");
}