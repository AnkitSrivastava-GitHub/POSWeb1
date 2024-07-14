$(document).ready(function () {
    BindDropDowns();
    BindVendorList(1);
});

function Pagevalue(e) {
    BindVendorList(parseInt($(e).attr("page")));
};

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

                $("#ddlSCompanyName option").remove();
                $("#ddlSCompanyName").append('<option value="0">Select Store</option>');
                $.each(CompanyList, function () {
                    $("#ddlSCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyName").text()));
                });
                $("#ddlSCompanyName").select2();
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

function BindVendorList(pageIndex) {
    debugger;
    //if ($('#txtSEmailid').val().trim() != '' || (isEmail($("#txtSEmailid").val()) == false)) {
    //    toastr.error('Enter valid Email ID.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}

    $('#loading').show();
    data = {
        VendorCode: $("#txtScode").val(),
        CompanyId: $("#ddlSCompanyName").val(),
        Name: $("#txtSname").val(),
        EmailId: $("#txtSEmailid").val(),
        PhoneNo: $("#txtSMob").val(),
        Status: $("#txtSstatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowVendorMaster.aspx/BindVendorList",
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
                var VendorList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (VendorList.length > 0) {
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
                    $("#tblVendorList tbody tr").remove();
                    var row = $("#tblVendorList thead tr:first-child").clone(true);
                    $.each(VendorList, function () {
                        debugger;
                        status = '';
                        $(".AutoId", row).html($(this).find("AutoId").text());
                        $(".vendorName", row).html($(this).find("VendorName").text());
                        $(".companyName", row).html($(this).find("CompanyName").text());
                        $(".vendorCode", row).html($(this).find("VendorCode").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        $(".status", row).html(status);
                        debugger;

                        $(".EmailId", row).html($(this).find("Emailid").text());
                        $(".Mob", row).html($(this).find("MobileNo").text());
                        $(".address", row).html($(this).find("Address2").text());
                        //$(".Action", row).html("<a id='btnDeleteAge' onclick='DeleteVendor(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' href='/Pages/VendorMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' href='/Pages/VendorMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteAge' onclick='DeleteVendor(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblVendorList").append(row);
                        row = $("#tblVendorList tbody tr:last-child").clone(true);
                    });
                    $("#tblVendorList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblVendorList").hide();
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

function DeleteVendor(id) {
    debugger;
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Vendor.",
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
                AutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ShowVendorMaster.aspx/DeleteVendor",
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
                        swal("Success!", "Vendor deleted successfully.", "success", { closeOnClickOutside: false });
                        BindVendorList(1);
                    }
                    else if (response.d == 'Vendor is in use.') {
                        swal("Warning!", "Vendor is in use.", "warning", { closeOnClickOutside: false });
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
            //swal("", "Cancelled.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}